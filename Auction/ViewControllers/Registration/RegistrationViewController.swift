//
//  RegistrationViewController.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import FullMaterialLoader
import SwiftPhoneNumberFormatter
import VisualEffectView
import IQKeyboardManagerSwift

class RegistrationViewController: UIViewController, RegistrationViewProtocol, CustomKeyboardButtonDelegate {
    
    @IBOutlet var centerConstraintY: NSLayoutConstraint!
    @IBOutlet var signInBottomConstraint: NSLayoutConstraint!
    @IBOutlet var imageView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    @IBOutlet var passEye: UIImageView!
    @IBOutlet var confirmPassEye: UIImageView!
    
    var presenter: RegistrationPresenterProtocol?
    var customKeyboard = CustomKeyboard()
    var bgImage = UIImageView()
    var result = String()
    var newString: String = "+"
    var indicatorView = IndicatorView()
        
    override func viewWillAppear(_ animated: Bool) {
        switch UIScreen.main.nativeBounds.height {
        case 1136:  //.iPhones_5_5s_5c_SE
            centerConstraintY.constant = -172.0
            signInBottomConstraint.constant = 108.0
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LogIn), name: NSNotification.Name(rawValue: "reg_success"), object: nil)
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: -
    // MARK: - methods
    
    func setupView() {
        // Background Image
        
        let width = UIScreen.main.bounds.width - UIScreen.main.bounds.width*0.25
        let xPos = UIScreen.main.bounds.width - width
        let height = UIScreen.main.bounds.height - UIScreen.main.bounds.height*0.28
        
        bgImage = UIImageView.init(frame: CGRect(x: xPos, y: 0.0, width: width, height: height))
        bgImage.image = UIImage.init(named: "img_auth_bg")
        imageView.addSubview(bgImage)
        view.bringSubviewToFront(contentView)
        
        // TextField Placeholder Attrs
        
        phoneTextField.inputView = UIView()
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "Your phone number",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Your email address",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        confirmTextField.attributedPlaceholder = NSAttributedString(string: "Confirm password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        // CustomKeyboard

        customKeyboard = CustomKeyboard(frame:CGRect(x: 0.0,
                                                     y: UIScreen.main.bounds.height,
                                                     width: UIScreen.main.bounds.width,
                                                     height: UIScreen.main.bounds.height/1.96))
        customKeyboard.backgroundColor = .white
        customKeyboard.delegate = self
        view.addSubview(customKeyboard)
        
        // IndicatorView
        
        indicatorView.addActivityIndicator()
        view.addSubview(indicatorView)
    }
    
    func registerAccount() {
        var phoneString = (phoneTextField.text?.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression))!
        phoneString = "+" + phoneString
        UserDefaults.standard.set(phoneString, forKey: "phone")
        
        let registrationResponse = RegistrationRequest.init(phoneNumber: phoneString, password: passwordTextField.text, email: emailTextField.text)
        let dict = try! registrationResponse.toDictionary()
        
        self.presenter?.interactor?.signUp(params: dict)
    }
    
    @objc func LogIn() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func showSignUpSuccess() {
        indicatorView.hideActivityIndicator()
        
        let confirmCodeViewController = ConfirmCodeRouter.createModule()
        present(confirmCodeViewController, animated: true)
    }
    
    func showSignUpError(message: String) {
        indicatorView.hideActivityIndicator()
        
        let alert = UIAlertController(title: NSLocalizedString("Registration Error", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func signUpButton(_ sender: Any) {
        if phoneTextField.text == "" {
            phoneTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if passwordTextField.text == "" {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if confirmTextField.text == "" {
            confirmTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        }
    
        if passwordTextField.text != confirmTextField.text || passwordTextField.text == "" || confirmTextField.text == "" {
            confirmTextField.text?.removeAll()
            confirmTextField.attributedPlaceholder = NSAttributedString(string: "Doesn't match",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        indicatorView.showActivityIndicator()
        
        registerAccount()
    }
    
    @IBAction func eyeImageAction(_ sender: UIButton) {
        if sender.isSelected {
            passwordTextField.isSecureTextEntry = false
            passEye.alpha = 1.0
            sender.isSelected = false
        } else {
            passwordTextField.isSecureTextEntry = true
            passEye.alpha = 0.0
            sender.isSelected = true
        }
    }
    
    @IBAction func confirmEyeImageAction(_ sender: UIButton) {
        if sender.isSelected {
            confirmTextField.isSecureTextEntry = false
            confirmPassEye.alpha = 1.0
            sender.isSelected = false
        } else {
            confirmTextField.isSecureTextEntry = true
            confirmPassEye.alpha = 0.0
            sender.isSelected = true
        }
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: - CustomKeyboardButtonDelegate
    
    func numericButtonPressed(sender: String) {
        if phoneTextField.text?.count == 0 {
            newString = "+"
            phoneTextField.text = newString
        }
        
        if phoneTextField.text!.count > 0 && phoneTextField.text!.count < 15 {
            newString.append(sender)
            phoneTextField.text = newString
        }
        
        switch newString.count {
        case 2:
            newString.append("(")
        case 6:
            newString.append(")")
        default:
            break
        }
        
        phoneTextField.text = newString
    }
    
    func doneButtonPressed() {
        view.endEditing(true)
        customKeyboard.hideKeyboard()
        
        emailTextField.becomeFirstResponder()
    }
    
    func removeButtonPressed() {
        if phoneTextField.text!.count > 2 {
            newString.removeLast()
            phoneTextField.text = newString
        }
        
        switch phoneTextField.text?.count {
        case 2:
            newString = ""
            phoneTextField.text = newString
        case 3:
            newString = ""
            phoneTextField.text = newString
        case 5:
            newString = String(newString.dropLast(2))
        default:
            break
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTextField {
            phoneTextField.text = newString
            customKeyboard.showKeyboard()
            IQKeyboardManager.shared.enableAutoToolbar = false
        } else {
            customKeyboard.hideKeyboard()
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == phoneTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
