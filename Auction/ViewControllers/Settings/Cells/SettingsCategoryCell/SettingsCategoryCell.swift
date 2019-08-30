//
//  SettingsCategoryCell.swift
//  Auction
//
//  Created by Q on 24/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class SettingsCategoryCell: UITableViewCell {

    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet var notificationSwitch: UISwitch!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
