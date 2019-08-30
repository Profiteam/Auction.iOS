//
//  CardCell.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

protocol CardButtonDelegate: class {
    func addCardButtonClicked()
}

class CardCell: UITableViewCell {
    
    weak var delegate: CardButtonDelegate?

    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addCardButtonAction(_ sender: Any) {
        delegate?.addCardButtonClicked()
    }
    
}
