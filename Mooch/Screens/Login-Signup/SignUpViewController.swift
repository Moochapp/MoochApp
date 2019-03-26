////
//  LoginViewController.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import PhoneNumberKit
import LDLogger
import IHKeyboardAvoiding


class SignUpViewController: UIViewController, Storyboarded {

    // MARK: - Class Vars
    var coordinator: MainCoordinator!
    var pnKit: PhoneNumberKit!
    var loginViewModel: LoginViewModel!
    var em: EntryManager!
    var toolbar: UIToolbar!
    
    // MARK: - Outlets
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumberField: PhoneNumberTextField!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reminder2Label: UILabel!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var inputsStackView: UIStackView!
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginViewModel = LoginViewModel(coordinator: coordinator)
        self.pnKit = PhoneNumberKit()
        self.em = EntryManager(viewController: self)
        
        setupTextFields()
        setupSignUpButton()
        setupNavigationBar()
        setupStackView()
        
    }
    
    // MARK: - Setup
    private func setupSignUpButton() {
        signUp.layer.cornerRadius = 5
        signUp.backgroundColor = EKColor.LightBlue.a700
        signUp.setTitleColor(.white, for: .normal)
        signUp.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(35)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = EKColor.LightBlue.a700
    }
    
    private func setupStackView() {
        inputsStackView.setCustomSpacing(16, after: firstName)
        inputsStackView.setCustomSpacing(16, after: lastName)
        inputsStackView.setCustomSpacing(16, after: email)
        inputsStackView.setCustomSpacing(8, after: phoneNumberField)
        inputsStackView.setCustomSpacing(16, after: reminderLabel)
        inputsStackView.setCustomSpacing(16, after: password)
        inputsStackView.setCustomSpacing(16, after: reminder2Label)
    }
    
    private func setupTextFields() {
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        
        setupToolbar()
        
        firstName.inputAccessoryView = toolbar
        lastName.inputAccessoryView = toolbar
        email.inputAccessoryView = toolbar
        password.inputAccessoryView = toolbar
        phoneNumberField.inputAccessoryView = toolbar
    }
    
    private func setupToolbar() {
        self.toolbar = UIToolbar(frame: .zero)
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing(textField:)))
        done.tintColor = EKColor.LightBlue.a700
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        self.toolbar.setItems([spacer, done], animated: true)
        self.toolbar.sizeToFit()
    }
    
    // MARK: - Actions
    @IBAction func signUp(_ sender: UIButton) {
//        coordinator.mainApp()
        
        signUp.isEnabled = false
        let num = phoneNumberField.nationalNumber
        let adjusted = "+1\(num)"
        
        checkFields { (verified, data) in
            if verified {
                guard data != nil else { return }
                em.showProcessingNote(title: "A verification code has been texted to you!", completion: {
                    PhoneAuthProvider.provider().verifyPhoneNumber(adjusted, uiDelegate: nil) { (verificationID, error) in
                        guard error == nil else {
                            Log.e(error)
                            return
                        }
                        
                        guard verificationID != nil else { return }
                        self.em.dismissEntry()
                        
                        self.loginViewModel.showVerify(in: self, code: { (code) in
                            guard let code = code else { return }
                            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: code)
                            FirebaseManager.auth.signInAndRetrieveData(with: credential, completion: { (result, error) in
                                guard error == nil else {
                                    Log.s(error!.localizedDescription)
                                    self.showError(title: "Hmm...", description: error!.localizedDescription)
                                    return
                                }
                                
                                guard let result = result else { return }
                                let user = result.user
                                
                                let emailCredential = EmailAuthProvider.credential(withEmail: data!.email, password: data!.password)
                                user.linkAndRetrieveData(with: emailCredential, completion: { (result, error) in
                                    guard error == nil else {
                                        self.showError(title: "Hmm...", description: error!.localizedDescription)
                                        return
                                    }
                                    
                                    let updates = user.createProfileChangeRequest()
                                    updates.displayName = "\(data!.first) \(data!.last)"
                                    updates.commitChanges(completion: { (error) in
                                        guard error == nil else {
                                            self.showError(title: "Hmm...", description: error!.localizedDescription)
                                            return
                                        }
                                        
                                        let moocher = Moocher(user: user)
                                        Session.moocher = moocher
                                        moocher.syncToLocal(result: { (error) in
                                            guard error == nil else {
                                                self.showError(title: "Hmm...", description: error!.localizedDescription)
                                                return
                                            }
                                            
                                            self.coordinator.mainApp()
                                        })
                                    })
                                })
                            })
                        })
                    }
                })
            } else {
                signUp.isEnabled = true
                return
            }
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        coordinator.login()
    }
    
    // MARK: - Selector Actions
    @objc func doneEditing(textField: UITextField) {
        view.endEditing(true)
    }
    
    // MARK: - Class Methods
    
    private func checkFields(completion: (Bool, (first: String, last: String, email: String, password: String, phoneNumber: String)?)->()) {
        guard let first = firstName.text else { return }
        guard first.isEmpty == false else {
            showError(title: "Oops!", description: "Please enter your first name.")
            completion(false, nil)
            return
        }
        
        guard let last = lastName.text else { return }
        guard last.isEmpty == false else {
            showError(title: "Oops!", description: "Please enter your last name.")
            completion(false, nil)
            return
        }
        
        guard let email = email.text else { return }
        guard email.isEmpty == false else {
            showError(title: "Oops!", description: "Please enter an email address.")
            completion(false, nil)
            return
        }
        guard isValidEmail(testStr: email) else {
            showError(title: "Oops!", description: "Please enter a valid email address.")
            completion(false, nil)
            return
        }
        
        guard let phoneNumber = phoneNumberField.text else { return }
        guard phoneNumber.isEmpty == false else {
            showError(title: "Oops!", description: "Please enter a mobile phone number.")
            completion(false, nil)
            return
        }
        guard phoneNumberField.isValidNumber else { return }
        
        guard let password = password.text else { return }
        guard password.isEmpty == false else {
            showError(title: "Oops!", description: "Please enter a password.")
            completion(false, nil)
            return
        }
        
        completion(true, (first: first.trimmingCharacters(in: .whitespacesAndNewlines),
                          last: last.trimmingCharacters(in: .whitespacesAndNewlines),
                          email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                          password: password,
                          phoneNumber: phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)))
    }
    
    private func showError(title: String, description: String) {
        em.showNotificationMessage(attributes: em.topFloat, title: title, desc: description, textColor: .white)
        
    }
    
    private func isValidEmail(testStr: String) -> Bool {

        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            
            let matches = regex.firstMatch(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count)) != nil
            return matches
        } catch {
            Log.e(error.localizedDescription)
            return false
        }
    }

    
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstName:
            lastName.becomeFirstResponder()
        case lastName:
            email.becomeFirstResponder()
        case email:
            phoneNumberField.becomeFirstResponder()
        case phoneNumberField:
            password.becomeFirstResponder()
        case password:
            textField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
}
