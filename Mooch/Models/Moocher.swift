////
//  Moocher.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum MoocherError: Error {
    case MoocherDataDocumentDoesNotExist(String)
}

class Moocher: FirebaseUser {
    
    // MARK: - Properties
    let firebaseUser: User
    
    var id: String
    var fullName: String
    var items: [Item] = []
    
    // MARK: Initializer
    init(user: User) {
        self.firebaseUser = user
        
        self.id = user.uid
        
        guard let name = user.displayName else {
            fatalError("User is not valid. Firebase users should always have a display name")
        }
        
        self.fullName = name
        
        FirebaseManager.users.document(self.id).setData(["ID":self.id, "FullName":self.fullName])
        
    }
    
    // MARK: - Class methods
    private func toMap() -> [String: Any] {
        let map: [String: Any] = ["ID": firebaseUser.uid,
                                  "FullName": fullName]
        return map
    }
    
    private func getDataFromMap(document: DocumentSnapshot) {
        if let data = document.data() {
            self.id = data["ID"] as! String
            self.fullName = data["FullName"] as! String
        }
    }
    
    // MARK: - Firebase User Methods
    
    /// Syncs local changes to the database
    ///
    /// - Parameter result: An optional error from the database call
    func syncChanges(result: @escaping (Error?)->()) {
        let map = self.toMap()
        FirebaseManager.users.document(firebaseUser.uid).updateData(map) { (error) in
            result(error)
        }
    }
    
    /// Syncs the database to the local app session
    ///
    /// - Parameter result: An optional error from the database call
    func syncToLocal(result: @escaping (Error?)->()) {
        FirebaseManager.users.document(firebaseUser.uid).getDocument { (document, error) in
            guard error == nil else {
                // Show an error message
                result(error)
                return
            }
            
            guard let doc = document else {
                // Show an error message
                
                result(MoocherError.MoocherDataDocumentDoesNotExist("Does not exist"))
                return
            }
            
            self.getDataFromMap(document: doc)
            result(nil)
            
        }
    }
    
}
