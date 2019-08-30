//
//  TotalCell.swift
//  Auction
//
//  Created by Иван Меликов on 10/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class TotalCell: UITableViewCell {

    @IBOutlet var butItNowPrice: UILabel!
    @IBOutlet var shipping: UILabel!
    @IBOutlet var salesTax: UILabel!
    @IBOutlet var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
