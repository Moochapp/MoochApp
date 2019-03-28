////
//  Item.swift
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Item {
    var id: String
    var name: String
    var category: String
    var owner: String
//    var availableFor: [String]
//    var status: String
//    var likes: Int
    
    init(document: DocumentSnapshot) {
        if let itemData = document.data() {
            self.id = itemData["ID"] as! String
            self.name = itemData["Name"] as! String
            self.category = itemData["Category"] as! String
            self.owner = itemData["Owner"] as! String
        } else {
            fatalError("Missing data. Should have complete item data.")
        }
    }
}
