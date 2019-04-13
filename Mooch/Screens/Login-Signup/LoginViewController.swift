////
//  LoginViewController.swift
//  Mooch
//
//  Created by App Center on 3/8/19.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import FirebaseAuth
import LDLogger
import PhoneNumberKit

class LoginViewController: UIViewController, Storyboarded {

    
    // MARK: - Properties
    var coordinator: MainCoordinator!
    
    var signInWithEmail: Bool = true
    
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
    @IBOutlet weak var phoneTF: PhoneNumberTextField!
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
        if signInWithEmail {
            guard let email = emailTF.text else { return }
            guard email.isEmpty == false else {
                self.showError(title: "Hmm...", description: "Please enter your email address!")
                return
            }
            
            guard let password = passwordTF.text else { return }
            guard password.isEmpty == false else {
                self.showError(title: "Hmm...", description: "Please enter your password!")
                return
            }
            
            FirebaseManager.auth.signIn(withEmail: email, password: password) { (result, error) in
                guard error == nil else {
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                        case .invalidEmail:
                            self.showError(title: "Oops!", description: error!.localizedDescription)
                        case .emailAlreadyInUse:
                            self.showError(title: "Oops!", description: error!.localizedDescription)
                        default:
                            self.showError(title: "Oops!", description: "Please try again.")
                        }
                    }
                    return
                }
                
                guard let result = result else {
                    Log.e("Result block error")
                    return
                }
                
                Session.shared.moocher = Moocher(user: result.user)
                Session.shared.moocher.syncToLocal(result: { (error) in
                    guard error == nil else {
                        Log.e(error?.localizedDescription)
                        return
                    }
                    self.coordinator.mainApp()
                })
            }
        } else {
            let num = phoneTF.nationalNumber
            let adjusted = "+1\(num)"
            guard phoneTF.text!.isEmpty == false else {
                self.showError(title: "Hmm...", description: "Please enter a valid phone number.")
                return
            }
            
            PhoneAuthProvider.provider().verifyPhoneNumber(adjusted, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    self.showError(title: "Hmm...", description: error.localizedDescription)
                    return
                }
                
                guard let verification = verificationID else {
                    self.showError(title: "Hmm...", description: "Please try again later.")
                    return
                }
                
                self.showVerify(in: self, code: { (code) in
                    if let code = code {
                        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verification,
                                                                                 verificationCode: code)
                        FirebaseManager.auth.signInAndRetrieveData(with: credential, completion: { (result, error) in
                            guard error == nil else {
                                self.showError(title: "Hmm...", description: error!.localizedDescription)
                                return
                            }
                            guard let result = result else { return }
                            let user = result.user
                            Session.shared.moocher = Moocher(user: user)
                            Session.shared.moocher.syncToLocal(result: { (error) in
                                guard error == nil else {
                                    self.showError(title: "Hmm...", description: error!.localizedDescription)
                                    return
                                }
                                
                                self.coordinator.mainApp()
                            })
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        coordinator.signup()
    }
    
    // MARK: - Class Methods
    private func configureForEmail() {
        signInWithEmail = true
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
        signInWithEmail = false
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
    
    private func showError(title: String, description: String) {
        let em = EntryManager(viewController: self)
        em.showNotificationMessage(attributes: em.topFloat, title: title, desc: description, textColor: .white)
        
    }
    
    private func showVerify(in view: UIViewController, code: @escaping (String?)->()) {
        AlertManager.verifyCode(view: view,
                                title: "A verification code will be sent to you via SMS",
                                subtitle: "Enter your code here") { (text) in
            code(text)
        }
    }
    
}
