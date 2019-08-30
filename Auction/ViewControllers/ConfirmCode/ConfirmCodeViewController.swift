//
//  ConfirmCodeViewController.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import PinCodeTextField
import FullMaterialLoader
import VisualEffectView
import Firebase
import Messages

class ConfirmCodeViewController: UIViewController, ConfirmCodeViewProtocol, CustomKeyboardButtonDelegate {
    
    @IBOutlet var confirmTextField: PinCodeTextField!
    @IBOutlet var messageLabel: UILabel!
    
    
    var presenter: ConfirmCodePresenterProtocol?
    var customKeyboard = CustomKeyboard()
    var posX: CGFloat = 0.0
    var newString = String()
    var indicatorView = IndicatorView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        confirmTextField.becomeFirstResponder()
        customKeyboard.showKeyboard()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmTextField.delegate = self
        confirmTextField.inputView = UIView()

        setupView()
    }

    // MARK: -
    // MARK: - methods
    
    func setupView() {
        messageLabel.adjustsFontSizeToFitWidth = true
        
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    func sendCode(code: String) {
        let deviceID = Messaging.messaging().fcmToken
        let confirmCodeRequest = ConfirmCodeRequest.init(phoneNumber: UserDefaults.standard.string(forKey: "phone"),
                                                         code: confirmTextField.text,
                                                         deviceID: nil,
                                                         registrationID: deviceID,
                                                         type: "ios")
        let dict = try! confirmCodeRequest.toDictionary()
        
        indicatorView.showActivityIndicator()
        
        self.presenter?.interactor?.confirmCode(params: dict)
    }

    // MARK: -
    // MARK: - Presenter Callback
    
    func showConfirmCodeSuccess(data: Data) {
        indicatorView.hideActivityIndicator()
        
        let confirmCodeResponse = try? JSONDecoder().decode(ConfirmCodeResponse.self, from: data)
        
        UserDefaults.standard.set(confirmCodeResponse?.token, forKey: "token")
        UserDefaults.standard.set(confirmCodeResponse?.userID, forKey: "user_id")
        
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reg_success"), object: nil)
        }
    }
    
    func showConfirmCodeError(message: String) {
        indicatorView.hideActivityIndicator()
        
        let alert = UIAlertController(title: NSLocalizedString("Invalid code", comment: ""), message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        newString = ""
        confirmTextField.text = newString
        confirmTextField.becomeFirstResponder()
        customKeyboard.showKeyboard()
    }
    
    // MARK: -
    // MARK: - CustomKeyboardButtonDelegate
    
    func numericButtonPressed(sender: String) {
        if newString.count == 3 {
            newString.append(sender)
            confirmTextField.text = newString
            confirmTextField.resignFirstResponder()
            
            doneButtonPressed()
        } else {
            newString.append(sender)
            confirmTextField.text = newString
        }
    }
    
    func doneButtonPressed() {
        if confirmTextField.text?.count == 4 {
            sendCode(code: confirmTextField.text ?? "")
            
            confirmTextField.resignFirstResponder()
            customKeyboard.hideKeyboard()
        }
    }
    
    func removeButtonPressed() {
        if newString.count > 0 {
            newString.removeLast()
            confirmTextField.text = newString
        }
    }
}

extension ConfirmCodeViewController: PinCodeTextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        let value = textField.text ?? ""
        print("value changed: \(value)")
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        doneButtonPressed()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
}

