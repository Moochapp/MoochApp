////
//  ProfileViewController.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import LDLogger

class ProfileViewController: UIViewController, Storyboarded {
    
    var coordinator: MainCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout(sender:)))
        
    }
    
    @objc func logout(sender: UIBarButtonItem) {
        do {
            try FirebaseManager.auth.signOut()
            coordinator.navigationController.popToRootViewController(animated: false)
        } catch {
            Log.e(error.localizedDescription)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
