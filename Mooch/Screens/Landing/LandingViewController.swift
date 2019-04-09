////
//  LandingViewController.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit


/// This ViewController is responsible for starting all processes in the application.
class LandingViewController: UIViewController, Storyboarded {

    /// Coordinator set in MainCoordinator.swift
    var coordinator: MainCoordinator!
    
    /// The class responsible for handing the view
    var viewModel: LandingViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.initializeApp { (exists) in
            if exists {
                self.coordinator.mainApp()
            } else {
                coordinator.onboarding()
            }
        }
    }

}
