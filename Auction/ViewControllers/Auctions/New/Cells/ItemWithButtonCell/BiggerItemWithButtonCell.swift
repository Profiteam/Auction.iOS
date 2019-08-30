//
//  BiggerItemWithButtonCell.swift
//  Auction
//
//  Created by Q on 10/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

protocol BiggerCellButtonDelegate {
    func biggerOpenItemPageViewController(_ sender: UIButton)
    func biggerAddToFavourite(_ sender: UIButton)
    func biggerRemoveFromFavoutire(_ sender: UIButton)
}

class BiggerItemWithButtonCell: UITableViewCell {
    
    var delegate: BiggerCellButtonDelegate!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet var starButton: UIButton!
    @IBOutlet var title: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var bets: UILabel!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var buttonWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        title.adjustsFontSizeToFitWidth = true
        price.adjustsFontSizeToFitWidth = true
        bets.adjustsFontSizeToFitWidth = true
        
        switch UIScreen.main.nativeBounds.height {
        case 1136: // iPhones_5_5s_5c_SE
            buttonWidth.constant = 120.0
        case 1334: //.iPhones_6_6s_7_8
            buttonWidth.constant = 140.0
        case 1792:  //.iPhone_XR
            buttonWidth.constant = 140.0
        case 1920, 2208: //.iPhones_6Plus_6sPlus_7Plus_8Plus
            buttonWidth.constant = 160.0
        case 2436:  //.iPhones_X_XS
            buttonWidth.constant = 140.0
        case 2688://.iPhone_XSMax
            buttonWidth.constant = 160.0
        default:
            break
        }
        
        starButton.setImage(UIImage.init(named: "ic_unselected_star"), for: .normal)
        starButton.setImage(UIImage.init(named: "ic_selected_star"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func itemPageButtonAction(_ sender: UIButton) {
        self.delegate?.biggerOpenItemPageViewController(sender)
    }
    
    @IBAction func starButtonAction(_ sender: UIButton) {
        if sender.isSelected {
            self.delegate?.biggerRemoveFromFavoutire(sender)
        } else {
            self.delegate?.biggerAddToFavourite(sender)
        }
    }
}
