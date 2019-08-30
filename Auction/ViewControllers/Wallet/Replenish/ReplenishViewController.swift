//
//  ReplenishViewController.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import  AKMaskField

class ReplenishViewController: UIViewController, ReplenishViewProtocol, CustomKeyboardButtonDelegate, UITextFieldDelegate {

    @IBOutlet var backButton: UIButton!
    @IBOutlet var hintTitle: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var textField: AKMaskField!
    @IBOutlet var textFieldImage: UIImageView!
    @IBOutlet var replenishTextField: AKMaskField!
    
    var presenter: ReplenishPresenterProtocol?
    
    var customKeyboard = CustomKeyboard()
    var currentTextField = UITextField()
    var newResult = String()
    var newString = String()
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        replenishTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        replenishTextField.resignFirstResponder()
    }

    func setupView() {
        let navigationBarHeight: CGFloat = UIScreen.main.bounds.height/2.47037037
        let backgroundImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navigationBarHeight))
        backgroundImage.image = UIImage.init(named: "ic_adding_card_background")
        contentView.addSubview(backgroundImage)
        
        contentView.bringSubviewToFront(self.hintTitle)
        contentView.bringSubviewToFront(self.textField)
        contentView.bringSubviewToFront(self.textFieldImage)
        view.bringSubviewToFront(self.backButton)
        
        //hintTitle set attributed text
        let attributedString = NSMutableAttributedString(string:self.hintTitle.text!)
        let attrs = [NSAttributedString.Key.font : UIFont(name: "Exo2.0-Regular", size: 18.0)]
        let gString = NSMutableAttributedString(string:"\nyou want to put on your account", attributes:attrs as [NSAttributedString.Key : Any])
        attributedString.append(gString)
        
        self.hintTitle.attributedText = attributedString
        
        replenishTextField.inputView = UIView()
        replenishTextField.delegate = self
        
        // CustomKeyboard
        
        customKeyboard = CustomKeyboard(frame:CGRect(x: 0.0,
                                                     y: UIScreen.main.bounds.height,
                                                     width: UIScreen.main.bounds.width,
                                                     height: UIScreen.main.bounds.height/1.96))
        customKeyboard.backgroundColor = .white
        customKeyboard.delegate = self
        view.addSubview(customKeyboard)
    }
    
    // MARK: Custom keyboard delegate
    func numericButtonPressed(sender: String) {
        replenishTextField.text?.append(sender)
    }
    
    func doneButtonPressed() {
        self.view.endEditing(true)
        customKeyboard.hideKeyboard()
    }
    
    func removeButtonPressed() {
        if ((replenishTextField.text?.count)! > 0) {
            replenishTextField.text?.removeLast()
        }
    }
    
    @IBAction func endEditinGesture(_ sender: Any) {
        view.endEditing(true)
        customKeyboard.hideKeyboard()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            //TO-DO
        }
    }
    
    // MARK: UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        replenishTextField = textField as? AKMaskField
        newString = textField.text!
        customKeyboard.showKeyboard()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        i = 0
    }
}
