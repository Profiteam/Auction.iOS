//
//  SearchBarView.swift
//  Auction
//
//  Created by Q on 04/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class SearchBarView: UIView {

    var searchTextField = UITextField()
    var switchButton = UIButton()
    var searchButton = UIButton()
    var width = UIScreen.main.bounds.width - 134.0
    var height = CGFloat()
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func addSearchTextField() {
        frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0)
        isUserInteractionEnabled = true
        backgroundColor = .white
        
        width = UIScreen.main.bounds.width
        height = 44.0
        
        // switchButton
        switchButton = UIButton.init(frame: CGRect(x: width - height - 18.0, y: 0.0, width: height, height: height))
        switchButton.setImage(UIImage.init(named: "ic_switch_style_button"), for: .normal)
        switchButton.setImage(UIImage.init(named: "ic_switch_style2_button"), for: .selected)
        addSubview(switchButton)
        
        // searchButton
        searchButton = UIButton.init(frame: CGRect(x: width - height*2 - 18.0, y: 0.0, width: height, height: height))
        searchButton.setImage(UIImage.init(named: "ic_search_button"), for: .normal)
        searchButton.setImage(UIImage.init(named: "ic_search_button_active"), for: .selected)
        searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        addSubview(searchButton)
        
        // textField
        searchTextField = UITextField.init(frame: CGRect(x: 28.0, y: 0.0, width: width - height*3, height: height))
        searchTextField.borderStyle = .none
        searchTextField.tintColor = .black
        searchTextField.placeholder = NSLocalizedString("Search", comment: "")
        addSubview(searchTextField)
    }
    
    @objc func searchButtonAction() {
        if searchButton.isSelected {
            searchTextField.resignFirstResponder()
            searchButton.isSelected = false
        } else {
            searchTextField.becomeFirstResponder()
            searchButton.isSelected = true
        }
    }
}

