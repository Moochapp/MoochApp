////
//  DataExtension.swift
//  Mooch
//
//  Created by App Center on 4/10/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    func getImage() -> UIImage? {
        if let image = UIImage(data: self) {
            return image
        } else {
            return nil
        }
    }
    
    func toNSData() -> NSData {
        return NSData(data: self)
    }
}
