////
//  MoochPhoneNumberTextField.swift
//  Mooch
//
//  Created by App Center on 3/6/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import Foundation
import PhoneNumberKit

class MoochPhoneNumberTextField: PhoneNumberTextField {
    
    init(nextTextField: UITextField, frame: CGRect = CGRect(x: 0, y: 0, width: 100, height: 30)) {
        self.nextTextField = nextTextField
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    var nextTextField: UITextField?
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self {
            nextTextField?.becomeFirstResponder()
        }
        
        return true
    }
}
