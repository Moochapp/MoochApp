////
//  GetStartedViewController.swift
//  Mooch
//
//  Created by App Center on 2/21/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController, Storyboarded {

    var coordinator: MainCoordinator!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    @IBAction func getStarted(_ sender: Any) {
        coordinator.signup()
    }
    

}