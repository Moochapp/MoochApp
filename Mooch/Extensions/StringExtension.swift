////
//  StringExtension.swift
//  Mooch
//
//  Created by App Center on 4/10/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func toNSString() -> NSString {
        return NSString(string: self)
    }
}
