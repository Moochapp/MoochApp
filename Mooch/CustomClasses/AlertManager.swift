////
//  AlertManager.swift
//  HealthApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import FCAlertView

class AlertManager {
    public static func success(view: UIViewController, title: String, subtitle: String?) {
        let alert = FCAlertView()
        alert.makeAlertTypeSuccess()
        alert.showAlert(inView: view, withTitle: title, withSubtitle: subtitle, withCustomImage: nil, withDoneButtonTitle: "Okay", andButtons: nil)
    }
    
    public static func fail(view: UIViewController, title: String, subtitle: String?) {
        let alert = FCAlertView()
        alert.makeAlertTypeCaution()
        alert.showAlert(inView: view, withTitle: title, withSubtitle: subtitle, withCustomImage: nil, withDoneButtonTitle: "Okay", andButtons: nil)
    }
    
    public static func verifyCode(view: UIViewController, title: String, subtitle: String?, code: @escaping (String?)->()) {
        let alert = FCAlertView()
        let tf = UITextField()
        tf.keyboardType = .numberPad
        alert.addTextField(withCustomTextField: tf, andPlaceholder: "Verification Code") { (text) in
            code(text)
        }
        alert.showAlert(inView: view, withTitle: title, withSubtitle: subtitle, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
    }
}

