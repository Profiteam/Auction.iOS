//
//  BidCollectionViewCell.swift
//  Auction
//
//  Created by Q on 11/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BidCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var insideView: UIView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var bidsCount: UILabel!
    @IBOutlet var retailLabel: UILabel!
    @IBOutlet var botView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        priceLabel.adjustsFontSizeToFitWidth = true
        retailLabel.adjustsFontSizeToFitWidth = true
        bidsCount.adjustsFontSizeToFitWidth = true
        
        if #available(iOS 11.0, *) {
            botView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        let widthRatio = insideView.bounds.size.width / (backgroundImage.image?.size.width)!
        let heightRatio = insideView.bounds.size.height / (backgroundImage.image?.size.height)!
        let scale = min(widthRatio, heightRatio)
        let imageWidth = scale * (backgroundImage.image?.size.width)!
        let imageHeight = scale * (backgroundImage.image?.size.height)!
        backgroundImage.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
    }
}
