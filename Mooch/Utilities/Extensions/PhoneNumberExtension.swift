////
//  PhoneNumberExtension.swift
//  HealthApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
extension String {
    func formatPhoneNumber() {
        if self.count == 10 {
            // Area Code    405 334 3475
            
            var tmp = self
            
            if self.contains(" ") {
                tmp = tmp.replacingOccurrences(of: " ", with: "")
            }
            
            if self.contains(".") {
                tmp = tmp.replacingOccurrences(of: ".", with: "")
            }
            
            if self.contains("/") {
                tmp = tmp.replacingOccurrences(of: "/", with: "")
            }
            
            if self.contains("-") {
                tmp = tmp.replacingOccurrences(of: "-", with: "")
            }
            
            
            
            
        } else if self.count == 11 {
            // country code 1 405 334 3475
        }
    }
}
