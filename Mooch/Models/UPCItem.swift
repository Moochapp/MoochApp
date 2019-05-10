////
//  UPCItem.swift
//  Mooch
//
//  Created by App Center on 5/5/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation

struct UPCResults: Codable {
    var items: [UPCItem]
}

struct UPCItem: Codable {
    var title: String
    var description: String
    var upc: String
    var images: [String]
}
