//
//  TextCell.swift
//  Auction
//
//  Created by Иван Меликов on 10/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {

    @IBOutlet var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
