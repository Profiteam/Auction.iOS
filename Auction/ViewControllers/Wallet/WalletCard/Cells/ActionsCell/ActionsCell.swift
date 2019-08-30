//
//  ActionsCell.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

protocol ActionCellButtonDelegate: class {
    func replenishButtonClicked()
    func changeCardButtonClicked()
}

class ActionsCell: UITableViewCell {
    
    weak var delegate: ActionCellButtonDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func replenishButtonAction(_ sender: Any) {
        delegate?.replenishButtonClicked()
    }
    
    @IBAction func changeCardButtonAction(_ sender: Any) {
        delegate?.changeCardButtonClicked()
    }
}
