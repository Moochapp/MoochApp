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
    var subcategory: String
    var owner: String
    var images: [UIImage] = []
    var availableFor: [Availability: Bool] = [.buy: false, .rent: false, .mooch: false]
    var rentalFee: Double?
    var rentalInterval: String?
    var price: Double?
//    var status: String
//    var likes: Int
    
    enum Availability {
        case mooch, rent, buy
    }
    
    init() {
        self.id = ""
        self.name = ""
        self.category = ""
        self.subcategory = ""
        self.owner = ""
        self.images = []
    }
    
    init(document: DocumentSnapshot) {
        if let itemData = document.data() {
            self.id = itemData["ID"] as! String
            self.name = itemData["Name"] as! String
            self.category = itemData["Category"] as! String
            self.subcategory = itemData["Subcategory"] as! String
            self.owner = itemData["Owner"] as! String
        } else {
            fatalError("Missing data. Should have complete item data.")
        }
    }
    
    
}
