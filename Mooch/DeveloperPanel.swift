////
//  DeveloperPanel.swift
//  Mooch
//
//  Created by App Center on 4/12/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import LDLogger

class DeveloperPanel {
    static let shared = DeveloperPanel()
    
    var shouldLoadDummyData = true
    var devMode = false
    var shouldStartOnTabbar = false
    
}
