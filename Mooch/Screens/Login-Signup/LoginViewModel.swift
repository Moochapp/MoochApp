////
//  LoginViewModel.swift
//  HealthApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import UIKit

class LoginViewModel {
    
    var coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }
    
    func showVerify(in view: UIViewController, code: @escaping (String?)->()) {
        AlertManager.verifyCode(view: view, title: "A verification code will be sent to you via SMS", subtitle: "Enter your code here") { (text) in
            code(text)
        }
    }
    
}
