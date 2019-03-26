////
//  LoginViewController.swift
//  Mooch
//
//  Created by App Center on 3/8/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, Storyboarded {

    
    // MARK: - Properties
    var coordinator: MainCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupStackView()
        setupButtons()
    }
    
    // MARK: - Setup
    private func setupStackView() {
        mainStackVIew.setCustomSpacing(16, after: signInWithEmailButton)
        mainStackVIew.setCustomSpacing(16, after: signInWithPhoneButton)
        emailTF.isHidden = true
        forgotPasswordButton.isHidden = true
        passwordTF.isHidden = true
        phoneTF.isHidden = true
        
    }
    
    func setupButtons() {
        signInWithEmailButton.layer.cornerRadius = 5
        signInWithEmailButton.setTitleColor(EKColor.LightBlue.a700, for: .normal)
        
        signInWithPhoneButton.layer.cornerRadius = 5
        signInWithPhoneButton.setTitleColor(EKColor.LightBlue.a700, for: .normal)
        
        signInButton.layer.cornerRadius = 5
        signInButton.backgroundColor = EKColor.LightBlue.a700
        signInButton.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Outlets
    @IBOutlet weak var mainStackVIew: UIStackView!
    @IBOutlet weak var signInWithEmailButton: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInWithPhoneButton: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Actions
    @IBAction func signInWithEmail(_ sender: UIButton) {
        configureForEmail()
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        
    }
    
    @IBAction func signInWithPhone(_ sender: UIButton) {
        configureForPhone()
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        coordinator.signup()
    }
    
    // MARK: - Class Methods
    private func configureForEmail() {
        UIView.animate(withDuration: 0.3, animations: {
            self.emailTF.isHidden = false
            self.passwordTF.isHidden = false
            self.forgotPasswordButton.isHidden = false
        }) { (done) in
            UIView.animate(withDuration: 0.3, animations: {
                self.phoneTF.isHidden = true
            })
        }
    }
    
    private func configureForPhone() {
        UIView.animate(withDuration: 0.3, animations: {
            self.emailTF.isHidden = true
            self.passwordTF.isHidden = true
            self.forgotPasswordButton.isHidden = true
        }) { (done) in
            UIView.animate(withDuration: 0.3, animations: {
                self.phoneTF.isHidden = false
            })
        }
    }
    
}
