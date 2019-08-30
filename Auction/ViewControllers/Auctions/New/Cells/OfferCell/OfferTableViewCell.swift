//
//  OfferTableViewCell.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

protocol OfferCellButtonDelegate {
    func offerCellButton(_ sender: UIButton)
}

class OfferTableViewCell: UITableViewCell {

    @IBOutlet var insideView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    var delegate: OfferCellButtonDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.insideView.layer.cornerRadius = 10.0
        self.insideView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.insideView.layer.shadowColor = Colours.shadowColor
        self.insideView.layer.shadowOpacity = 1.0
        self.insideView.layer.shadowRadius = 3.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func offerButtonAction(_ sender: UIButton) {
        self.delegate?.offerCellButton(sender)
    }
}
