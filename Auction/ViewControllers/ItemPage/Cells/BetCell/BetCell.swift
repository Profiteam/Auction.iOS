//
//  BetCell.swift
//  Auction
//
//  Created by Q on 22/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class BetCell: UITableViewCell {
    
    @IBOutlet var betsCount: UILabel!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var bet: UILabel!
    @IBOutlet var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
