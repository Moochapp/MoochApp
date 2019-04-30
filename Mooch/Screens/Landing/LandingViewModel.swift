////
//  LandingViewModel.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import Firebase
import LDLogger

class LandingViewModel: NSObject {
    
    // MARK: - Properties
    var coordinator: MainCoordinator!
    
    // MARK: - Init
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public
    public func initializeApp(user exists: @escaping (Bool)->()) {
        shouldNavigateToMain(completion: { (done) in
            if done {
                exists(true)
            } else {
                exists(false)
            }
        })
    }
    
    // MARK: - Private
    private func shouldNavigateToMain(completion: @escaping (Bool)->()) {
        checkForUser(completion: { (done) in
            if done {
                // user exists; we need to send them to the main portion of the app
                completion(true)
            } else {
                // no user; we need to send them to onboarding.
                completion(false)
            }
        })
    }
    
    private func checkForUser(completion: @escaping (Bool)->()) {
        if Auth.auth().currentUser != nil {
            let moocher = Moocher(user: Auth.auth().currentUser!)
            Session.shared.moocher = moocher
            moocher.syncToLocal { (error) in
                guard error == nil else {
                    Log.d(error!.localizedDescription)
                    completion(false)
                    return
                }
                completion(true)
            }
        } else {
            completion(false)
        }
    }
    
}
