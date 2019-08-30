//
//  AddingCardCell.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import AKMaskField


class AddingCardCell: UITableViewCell {

    @IBOutlet var cardView: UIView!
    @IBOutlet weak var numberTextField: AKMaskField!
    @IBOutlet weak var expirationTextField: AKMaskField!
    @IBOutlet weak var cvcTextField: AKMaskField!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cardView.layer.cornerRadius = 10.0
        self.cardView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.cardView.layer.shadowColor = Colours.cardShadowColor
        self.cardView.layer.shadowOpacity = 1.0
        self.cardView.layer.shadowRadius = 20.0
        
        self.setupPlaceholders()
    }
    
    func setupPlaceholders() {
        numberTextField.maskExpression = "{dddd}       {dddd}       {dddd}       {dddd}"
        numberTextField.maskTemplate = "⌷"
        numberTextField.inputView = UIView()
        
        expirationTextField.maskExpression = "{dd}/{dd}"
        expirationTextField.maskTemplate = "⌷"
        expirationTextField.inputView = UIView()
        
        cvcTextField.maskExpression = "{ddd}"
        cvcTextField.maskTemplate = "*"
        cvcTextField.inputView = UIView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
