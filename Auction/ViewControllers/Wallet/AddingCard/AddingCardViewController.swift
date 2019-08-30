//
//  AddingCardViewController.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import AKMaskField
import IQKeyboardManagerSwift

class AddingCardViewController: UIViewController, AddingCardViewProtocol, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CustomKeyboardButtonDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var hintTitle: UILabel!
    
    var presenter: AddingCardPresenterProtocol?
    
    var addingCardCell = AddingCardCell()
    var personalInfoCell = PersonalInfoCell()
    var showPersonalInfoCell: Bool = false
    var hintLabel = UILabel()
    var middleButton = UIButton()
    var customKeyboard = CustomKeyboard()
    var currentTextField = UITextField()
    var result = String()
    var newResult = String()
    var newString = String()
    var i = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        showPersonalInfoCell = false
        
        middleButton.tag = 1
        
        hintTitle.alpha = 0.0
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddingCardCell", bundle: nil), forCellReuseIdentifier: "AddingCardCell")
        tableView.register(UINib(nibName: "PersonalInfoCell", bundle: nil), forCellReuseIdentifier: "PersonalInfoCell")
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    func setupView() {
        let navigationBarHeight: CGFloat = UIScreen.main.bounds.height/2.47037037
        let backgroundImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navigationBarHeight))
        backgroundImage.image = UIImage.init(named: "ic_background_wallet")
        view.addSubview(backgroundImage)
        
        view.bringSubviewToFront(self.tableView)
        view.bringSubviewToFront(self.backButton)
        
        // CustomKeyboard
        
        customKeyboard = CustomKeyboard(frame:CGRect(x: 0.0,
                                                     y: UIScreen.main.bounds.height,
                                                     width: UIScreen.main.bounds.width,
                                                     height: UIScreen.main.bounds.height/1.96))
        customKeyboard.backgroundColor = .white
        customKeyboard.delegate = self
        view.addSubview(customKeyboard)
    }
    
    // MARK: Button actions
    
    @objc func middleButtonAction(_ sender: UITapGestureRecognizer) {
        self.hintTitle.layer.zPosition = 1000
        if (self.middleButton.tag == 1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.hintTitle.alpha = 1.0
                self.view.layoutSubviews()
            })
            
            self.showPersonalInfoCell = true
        
            tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
        } else {
            self.dismiss(animated: true) {
                //TO-DO
            }
        }
    }
    
    @IBAction func endEditinGesture(_ sender: Any) {
        view.endEditing(true)
        customKeyboard.hideKeyboard()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true) 
    }
    
    // MARK: Custom keyboard delegate
    func numericButtonPressed(sender: String) {
        if currentTextField == addingCardCell.numberTextField {
            newString = currentTextField.text!.replacingOccurrences(of: "       ", with: "", options: .literal, range: nil)
        } else if (currentTextField == addingCardCell.expirationTextField) {
            newString = currentTextField.text!.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
        } else {
            newString = currentTextField.text!
        }
        
        while i <= (newString.count) {
            let index = newString.index(newString.startIndex, offsetBy: i)
            let end = newString.index(newString.startIndex, offsetBy: i)
            result = newString.replacingCharacters(in: index..<end, with: sender)
            currentTextField.text = result
            if(i != newString.count) {
                i = i + 1
            }
            break
        }
    }
    
    func doneButtonPressed() {
        currentTextField.resignFirstResponder()
        customKeyboard.hideKeyboard()
    }
    
    func removeButtonPressed() {
        if (i != 0) {
            i = i - 1
        }
        while i <= (newString.count) {
            let index = newString.index(newString.startIndex, offsetBy: i)
            let end = newString.index(newString.startIndex, offsetBy: i);
            result = newString.replacingCharacters(in: index..<end, with: "⌷")
            currentTextField.text = result
            print(result)
            break
        }
    }
    
    // MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (showPersonalInfoCell) {
            return 262.0
        } else {
            return 180.0
        }
    }
    
    // MARK: headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 117.0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (showPersonalInfoCell) {
            return 154.0
        } else {
            return 80.0
        }
    }
    
    // MARK: footerView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (showPersonalInfoCell) {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44.0))
            footerView.backgroundColor = UIColor.clear
            hintLabel = .init(frame: CGRect(x: 16.0, y: footerView.frame.height/2 - 11.0, width: 200.0, height: 22.0))
            hintLabel.backgroundColor = .clear
            hintLabel.font = UIFont.init(name: "Exo2.0-Regular", size: 16.0)
            hintLabel.textColor = Colours.hintColor
            hintLabel.text = "All field are required*"
            hintLabel.isHidden = true                                                       // SHOW IF INPUTS ARE EMPTY
            footerView.addSubview(hintLabel)
        
            return footerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (showPersonalInfoCell) {
            return 44.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        addingCardCell = tableView.dequeueReusableCell(withIdentifier: "AddingCardCell") as! AddingCardCell
        addingCardCell.selectionStyle = .none
        
        addingCardCell.numberTextField.delegate = self
        addingCardCell.numberTextField.textAlignment = .center
        addingCardCell.numberTextField.inputView = UIView()
        addingCardCell.numberTextField.becomeFirstResponder()
        
        addingCardCell.expirationTextField.delegate = self
        addingCardCell.expirationTextField.inputView = UIView()
        addingCardCell.expirationTextField.textAlignment = .center
        
        addingCardCell.cvcTextField.delegate = self
        addingCardCell.cvcTextField.inputView = UIView()
        addingCardCell.cvcTextField.textAlignment = .center
        
        personalInfoCell = tableView.dequeueReusableCell(withIdentifier: "PersonalInfoCell") as! PersonalInfoCell
        personalInfoCell.selectionStyle = .none
        
        if (showPersonalInfoCell) {
            self.middleButton.tag = 2
            return personalInfoCell
        } else {
            addingCardCell.numberTextField.becomeFirstResponder()
            return addingCardCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped section number \(indexPath.section).")
    }
    
    // MARK: UITextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let beginning = textField.beginningOfDocument
        textField.selectedTextRange = textField.textRange(from: beginning, to: beginning)
        
        switch textField {
        case addingCardCell.numberTextField:
            newString = textField.text!.replacingOccurrences(of: "       ", with: "", options: .literal, range: nil)
        case addingCardCell.expirationTextField:
            newString = textField.text!.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
            print(newString)
        default:
            newString = textField.text!
            print(newString)
            break
        }
        currentTextField = textField
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        customKeyboard.showKeyboard()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        i = 0
    }
}

