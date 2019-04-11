////
//  ImageExtension.swift
//  Mooch
//
//  Created by App Center on 4/10/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func toData() -> Data? {
        if let data = self.pngData() {
            return data
        } else {
            return nil
        }
    }
}
