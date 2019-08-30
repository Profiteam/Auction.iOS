//
//  InfoHeaderView.swift
//  Auction
//
//  Created by Иван Меликов on 18/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class InfoHeaderView: UITableViewHeaderFooterView {

    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var avatarImage: UIImageView!
    
    
    override func draw(_ rect: CGRect) {
        nicknameTextField.adjustsFontSizeToFitWidth = true
        emailTextField.adjustsFontSizeToFitWidth = true
        phoneTextField.adjustsFontSizeToFitWidth = true
    }
    
    func setFocusTextField(isFocused: Bool) {
        nicknameTextField.isUserInteractionEnabled = isFocused
        emailTextField.isUserInteractionEnabled = isFocused
        phoneTextField.isUserInteractionEnabled = isFocused

        if isFocused == true {
            nicknameTextField.becomeFirstResponder()
        }
    }
}

