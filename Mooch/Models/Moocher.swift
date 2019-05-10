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
import LDLogger

enum MoocherError: Error {
    case MoocherDataDocumentDoesNotExist(String)
}

class Moocher: FirebaseUser {
    
    // MARK: - Properties
    let firebaseUser: User
    
    var id: String
    var fullName: String
    var items: [Item] = []
    var favoriteCategories: [String] = []
    
    // MARK: Initializer
    init(user: User) {
        self.firebaseUser = user
        self.id = user.uid
        guard let name = user.displayName else {
            fatalError("User is not valid. Firebase users should always have a display name")
        }
        self.fullName = name
    }
    
    public func initializeUser(completion: @escaping (Bool, Error?)->()) {
        FirebaseManager.users.document(self.id).setData(["ID": self.id, "FullName": self.fullName]) { (error) in
            guard error == nil else {
                completion(false, error!)
                return
            }
            completion(true, nil)
        }
    }
    
    // MARK: - Class methods
    private func toMap() -> [String: Any] {
        let map: [String: Any] = ["ID": firebaseUser.uid,
                                  "FullName": fullName,
                                  "favoriteCategories": favoriteCategories]
        return map
    }
    
    private func getDataFromMap(document: DocumentSnapshot) {
        if let data = document.data() {
            self.id = data["ID"] as! String
            self.fullName = data["FullName"] as! String
            self.favoriteCategories = (data["favoriteCategories"] as? [String]) ?? []
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
    
    static func findUser(with phone: String) {
        
    }
}

extension Moocher {
    static func nameFrom(id: String, completion: @escaping (String?)->()) {
        FirebaseManager.users.document(id).getDocument { (snapshot, error) in
            guard error == nil else {
                Log.e(error?.localizedDescription)
                completion(nil)
                return
            }
            
            guard let snap = snapshot else {
                completion(nil)
                return
            }
            guard let data = snap.data() else {
                completion(nil)
                return
            }
            
            let name = data["FullName"] as! String
            completion(name)
        }
    }
    
    private static func getDataFromMap(document: DocumentSnapshot) {
        
    }
}
