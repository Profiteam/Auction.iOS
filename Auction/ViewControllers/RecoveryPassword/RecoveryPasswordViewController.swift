//
//  RecoveryPasswordViewController.swift
//  Auction
//
//  Created by Иван Меликов on 19/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RecoveryPasswordViewController: UIViewController, RecoveryPasswordViewProtocol, CustomKeyboardButtonDelegate {
    
    @IBOutlet var backgroundImgeView: UIView!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    
    @IBOutlet var emailView: GRView!
    @IBOutlet var passwordView: GRView!
    @IBOutlet var confirmView: GRView!
    @IBOutlet var sendButton: UIButton!
    
    @IBOutlet var passEye: UIImageView!
    @IBOutlet var confirmPassEye: UIImageView!
    
    var presenter: RecoveryPasswordPresenterProtocol?

    var phoneString = String()
    var indicatorView = IndicatorView()
    var customKeyboard = CustomKeyboard()
    var bgImage = UIImageView()
    var newString: String = "+"
    var isCodeTextField: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: -
    // MARK: - Method's

    func setupViews() {
        emailTextField.inputView = UIView()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Your phone number",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        confirmTextField.attributedPlaceholder = NSAttributedString(string: "Confirm password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        // Backgrond Image
        
        let width = UIScreen.main.bounds.width - UIScreen.main.bounds.width*0.25
        let xPos = UIScreen.main.bounds.width - width
        let height = UIScreen.main.bounds.height - UIScreen.main.bounds.height*0.28
        
        bgImage = UIImageView.init(frame: CGRect(x: xPos, y: 0.0, width: width, height: height))
        bgImage.image = UIImage.init(named: "img_auth_bg")
        bgImage.alpha = 1.0
        backgroundImgeView.addSubview(bgImage)
        
        // IndicatorView
        
        indicatorView.addActivityIndicator()
        view.addSubview(indicatorView)
        
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
    
    
    func getCode() {
        indicatorView.showActivityIndicator()
        
        phoneString = (emailTextField.text?.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression))!
        phoneString = "+" + phoneString
        
        let recoveryPasswordReqest = RecoveryPasswordReqest.init(phoneNumber: phoneString)
        let dict = try! recoveryPasswordReqest.toDictionary()
        self.presenter?.interactor?.sendPhone(params: dict)
    }
    
    func recoverPassword() {
        if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Sms code",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if passwordTextField.text == "" {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if confirmTextField.text == "" {
            confirmTextField.attributedPlaceholder = NSAttributedString(string: "Confirm password",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        if passwordTextField.text != confirmTextField.text || passwordTextField.text == "" || confirmTextField.text == "" {
            confirmTextField.text?.removeAll()
            confirmTextField.attributedPlaceholder = NSAttributedString(string: "Doesn't match",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        } else {
            indicatorView.showActivityIndicator()
            
            let changePasswordRequest = ChangePasswordRequest.init(phoneNumber: phoneString,
                                                                   code: emailTextField.text!,
                                                                   password: passwordTextField.text!)
            let dict = try! changePasswordRequest.toDictionary()
            self.presenter?.interactor?.changePassword(params: dict)
        }
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func sendCodeButtonAction(_ sender: UIButton) {
        if sender.tag == 2 {
            recoverPassword()
        } else {
            getCode()
        }
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
    
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: - Presenter's callback
    
    func showPhoneSuccess() {
        indicatorView.hideActivityIndicator()
        
        isCodeTextField = true
        
        passwordView.isHidden = false
        confirmView.isHidden = false
        
        newString = ""
        emailTextField.text = newString
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Sms code",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        sendButton.tag = 2
        sendButton.setTitle("Recover", for: .normal)
    }
    
    func showPhoneError(message: String) {
        indicatorView.hideActivityIndicator()
        
        let alert = UIAlertController(title: NSLocalizedString("Recovery Error", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showChangePasswordSuccess() {
        indicatorView.hideActivityIndicator()
        
        dismiss(animated: true, completion: nil)
    }
    
    func showChangePasswordError(message: String) {
        indicatorView.hideActivityIndicator()
        
        let alert = UIAlertController(title: NSLocalizedString("Recovery Error", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: - CustomKeyboardButtonDelegate
    
    func numericButtonPressed(sender: String) {
        if emailTextField.text?.count == 0 {
            if isCodeTextField == false {
                newString = "+"
            }
            emailTextField.text = newString
        }
        
        if isCodeTextField == false {
            if emailTextField.text!.count > 0 && emailTextField.text!.count < 15 {
                newString.append(sender)
                emailTextField.text = newString
            }
        } else {
            if emailTextField.text!.count < 4 {
                newString.append(sender)
                emailTextField.text = newString
            } else {
                view.endEditing(true)
                customKeyboard.hideKeyboard()
            }
        }
        
        switch newString.count {
        case 2:
            if isCodeTextField == false {
                newString.append("(")
            }
        case 4:
            if isCodeTextField == true {
                break
            }
        case 6:
            newString.append(")")
        default:
            break
        }
        
        emailTextField.text = newString
    }
    
    func doneButtonPressed() {
        view.endEditing(true)
        customKeyboard.hideKeyboard()
    }
    
    func removeButtonPressed() {
        if emailTextField.text!.count > 2 {
            newString.removeLast()
            emailTextField.text = newString
        }
        
        switch emailTextField.text?.count {
        case 2:
            newString = ""
            emailTextField.text = newString
        case 3:
            newString = ""
            emailTextField.text = newString
        case 5:
            newString = String(newString.dropLast(2))
        default:
            break
        }
    }
}


extension RecoveryPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTextField.text = newString
            customKeyboard.showKeyboard()
            IQKeyboardManager.shared.enableAutoToolbar = false
        } else {
            customKeyboard.hideKeyboard()
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
