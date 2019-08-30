//
//  ItemHeaderView.swift
//  Auction
//
//  Created by Q on 30/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit
import ImageSlideshow
import CountdownLabel

class ItemHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var slideShowView: ImageSlideshow!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timerLabel: CountdownLabel!
    @IBOutlet weak var timerView: UIView!
    
    override func draw(_ rect: CGRect) {
        
        // init SlideShow
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = Colours.currentPageIndicatorColor
        pageIndicator.pageIndicatorTintColor = Colours.pageIndicatorColor
        slideShowView.pageIndicator = pageIndicator
        slideShowView.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .under)
        slideShowView.activityIndicator = DefaultActivityIndicator()
        slideShowView.slideshowInterval = 4.0
        
        // Image angle corner
        
        let path = UIBezierPath(roundedRect: slideShowView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        slideShowView.layer.mask = mask
        
        // Timer label
        
        timerLabel.font = UIFont(name:"Helvetica-Regular", size: 18)
        timerLabel.animationType = .Evaporate
        timerLabel.adjustsFontSizeToFitWidth = true
    }

}
