////
//  LandingViewModel.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import Firebase

class LandingViewModel: NSObject {
    
    // MARK: - Properties
    var coordinator: MainCoordinator!
    
    // MARK: - Init
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public
    public func initializeApp(user exists: (Bool)->()) {
        if shouldNavigateToMain() {
            exists(true)
        } else {
            exists(false)
        }
    }
    
    // MARK: - Private
    private func shouldNavigateToMain() -> Bool {
        if checkForUser() {
            // user exists; we need to send them to the main portion of the app
            return true
        } else {
            // no user; we need to send them to onboarding.
            return false
        }
    }
    
    private func checkForUser() -> Bool {
        if Auth.auth().currentUser != nil {
            let moocher = Moocher(user: Auth.auth().currentUser!)
            Session.shared.moocher = moocher
            return true
        } else {
            return false
        }
    }
    
}
