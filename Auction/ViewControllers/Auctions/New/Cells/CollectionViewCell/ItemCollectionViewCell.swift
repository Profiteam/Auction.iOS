//
//  ItemCollectionViewCell.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

protocol CollectionCellButtonDelegate {
    func collectionAddToFavourite(_ sender: UIButton)
    func collectionRemoveFromFavourite(_ sender: UIButton)
}

class ItemCollectionViewCell: UICollectionViewCell {

    var delegate: CollectionCellButtonDelegate!

    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var starButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemTitle.adjustsFontSizeToFitWidth = true
        
        layoutIfNeeded()
        
        starButton.setImage(UIImage.init(named: "ic_unselected_star"), for: .normal)
        starButton.setImage(UIImage.init(named: "ic_selected_star"), for: .selected)
    }
    
    @IBAction func starButtonAction(_ sender: UIButton) {
        if sender.isSelected {
            self.delegate?.collectionRemoveFromFavourite(sender)
        } else {
            self.delegate?.collectionAddToFavourite(sender)
        }
    }
}
