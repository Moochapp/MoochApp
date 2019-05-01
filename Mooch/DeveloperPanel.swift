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
    var needsFirstLogout = false
    
}

extension DeveloperPanel {
    func getConfig(completion: @escaping ()->()) {
        FirebaseManager.db.collection("Developer").document("Configure").getDocument { (snap, error) in
            guard error == nil else {
                fatalError("Could not get config")
            }
            guard let data = snap?.data() else { return }
            if let bool = data["NeedsFirstLogout"] as? Bool {
                self.needsFirstLogout = bool
            }
            
            if let bool = data["ShouldLoadDummyData"] as? Bool {
                self.shouldLoadDummyData = bool
            }
            
            if let bool = data["DevMode"] as? Bool {
                self.devMode = bool
            }
            
            if let bool = data["ShouldStartOnTabbar"] as? Bool {
                self.shouldStartOnTabbar = bool
            }
            
            completion()
        }
    }
}
