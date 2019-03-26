////
//  BasicInformationViewController.swift
//  HealthApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import FirebaseAuth

class BasicInformationViewController: UIViewController, Storyboarded {

    var coordinator: MainCoordinator!
    var newUser: User!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    
    @IBAction func doneWithName(_ sender: UIButton) {
        
        guard let name = fullNameTextField.text else { return }
        guard name.count > 0 else { return }
        
        let request = newUser.createProfileChangeRequest()
        request.displayName = name
        request.commitChanges { (error) in
            guard error == nil else {
                AlertManager.fail(view: self, title: "Hmmm...", subtitle: error!.localizedDescription)
                return
            }
            
            let moocher = Moocher(user: self.newUser)
            Session.moocher = moocher
            
            self.coordinator.mainApp()
        }
        
    }
    
}
