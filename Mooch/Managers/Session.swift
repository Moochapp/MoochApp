////
//  Session.swift
//  Mooch
//
//  Created by Luke Davis on 01/26/2019.
//  Copyright © 2019 rlukedavis. All rights reserved.
//

import Foundation
import FirebaseAuth

class Session {

    static var moocher: Moocher!
    static var currentDeviceToken: String?
    
    static func updateDataForCurrentUser() {
        DispatchQueue.global(qos: .userInitiated).async {
            let query = FirebaseManager.items.whereField("Owner", isEqualTo: moocher.id)
            query.getDocuments(completion: { (snap, error) in
                guard error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                
                guard let snap = snap else { return }
                
                var items: [Item] = []
                for item in snap.documents {
                    items.append(Item(document: item))
                }
                moocher.items = items
            })
        }
    }
    
}
