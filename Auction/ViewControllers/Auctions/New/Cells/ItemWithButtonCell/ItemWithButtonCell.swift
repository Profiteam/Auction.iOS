//
//  ItemWithButtonCell.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

protocol CellButtonDelegate {
    func openItemPageViewController(_ sender: UIButton)
    func addToFavourite(_ sender: UIButton)
    func removeFromFavoutire(_ sender: UIButton)
}

class ItemWithButtonCell: UITableViewCell {
    
    var delegate: CellButtonDelegate!

    @IBOutlet weak var button: UIButton!
    @IBOutlet var starButton: UIButton!
    @IBOutlet var title: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var bets: UILabel!
    @IBOutlet var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.adjustsFontSizeToFitWidth = true
        price.adjustsFontSizeToFitWidth = true
        bets.adjustsFontSizeToFitWidth = true
        
        itemImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        itemImage.layer.masksToBounds = true
        
        starButton.setImage(UIImage.init(named: "ic_unselected_star"), for: .normal)
        starButton.setImage(UIImage.init(named: "ic_selected_star"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func itemPageButtonAction(_ sender: UIButton) {
        self.delegate?.openItemPageViewController(sender)
    }
    
    @IBAction func starButtonAction(_ sender: UIButton) {
        if sender.isSelected {
            self.delegate?.removeFromFavoutire(sender)
        } else {
            self.delegate?.addToFavourite(sender)
        }
    }
}
