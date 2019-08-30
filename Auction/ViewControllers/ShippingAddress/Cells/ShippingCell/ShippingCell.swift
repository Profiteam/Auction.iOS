//
//  ShippingCell.swift
//  Auction
//
//  Created by Иван Меликов on 23/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class ShippingCell: UITableViewCell {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var streetAddressTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var selectStateTextField: UITextField!
    @IBOutlet var zipCodeTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var payPallButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
