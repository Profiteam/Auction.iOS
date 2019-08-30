//
//  AuthorizationViewController.swift
//  Auction
//
//  Created by Q on 29/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import FullMaterialLoader
import VisualEffectView

class AuthorizationViewController: UIViewController, AuthorizationViewProtocol, AnimateButtonDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var eyeImage: UIImageView!
    @IBOutlet var eyeAppleImage: UIImageView!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginErrorLabel: UILabel!
    @IBOutlet var forgotButton: UIButton!
    
    var presenter: AuthorizationPresenterProtocol?
    var indicator = MaterialLoadingIndicator()
    var animationView = AuthAnimationView()
    var isPasswordTextShown = false
    var bgImage = UIImageView()
    var indicatorView = IndicatorView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.hhTabBarView.selectTabAtIndex(withIndex: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LogIn), name: NSNotification.Name(rawValue: "reg_success"), object: nil)
        
        setupView()
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
        bgImage.alpha = 0.0
        view.addSubview(bgImage)
        view.bringSubviewToFront(contentView)
        
        // Set Placeholder Attrs
    
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Your email address",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        // AnimationView
        
        animationView = AuthAnimationView(frame: UIScreen.main.bounds)
        animationView.delegate = self
        view.addSubview(animationView)
        
        // IndicatorView
        
        indicatorView.addActivityIndicator()
        view.addSubview(indicatorView)
    }
    
    func animateAction() {
        //Hide AuthAnimationView button
        animationView.isUserInteractionEnabled = false
        animationView.animateButton.removeFromSuperview()
        
        // Show contentView after AuthAnimationView will disappear
        UIView.animate(withDuration: 0.7, animations: {
            self.bgImage.alpha = 1.0
            self.contentView.alpha = 1.0
        })
    }
    
    func signInAccount() {
        let authorizationRequest = AuthorizationRequest.init(userInfo: emailTextField.text, password: passwordTextField.text)
        let dict = try! authorizationRequest.toDictionary()
        self.presenter?.interactor?.sighIn(params: dict)
    }
    
    @objc func LogIn() {
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: -
    // MARK: - Presenter Callback

    func showSighInSuccess(data: Data) {
        indicatorView.hideActivityIndicator()
        
        let authorizationResponse = try? JSONDecoder().decode(AuthorizationResponse.self, from: data)
        UserDefaults.standard.set(authorizationResponse?.token, forKey: "token")
        UserDefaults.standard.set(authorizationResponse?.userID, forKey: "user_id")
        
        print("token = \(UserDefaults.standard.string(forKey: "token")!)\nuser_id = \(UserDefaults.standard.string(forKey: "user_id")!)")
        
        navigationController?.popViewController(animated: false)
    }

    func showSighInError(message: String) {
        indicatorView.hideActivityIndicator()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.loginErrorLabel.alpha = 1.0
        })
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        if emailTextField.text == "" {
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        if passwordTextField.text == "" {
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        }
        
        indicatorView.showActivityIndicator()
        
        signInAccount()
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        let registrationViewController = RegistrationRouter.createModule()
        present(registrationViewController, animated: true, completion: nil)
    }
    
    @IBAction func forgotButtonAction(_ sender: UIButton) {
        let recoveryPasswordViewController = RecoveryPasswordRouter.createModule()
        present(recoveryPasswordViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func eyeImageAction(_ sender: Any) {
        if isPasswordTextShown == false {
            passwordTextField.isSecureTextEntry = false
            isPasswordTextShown = true
            eyeAppleImage.alpha = 1.0
            
        } else {
            passwordTextField.isSecureTextEntry = true
            isPasswordTextShown = false
            eyeAppleImage.alpha = 0.0
        }
    }
}


extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 1.0, animations: {
            self.loginErrorLabel.alpha = 0.0
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            emailTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
