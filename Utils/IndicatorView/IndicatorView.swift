//
//  IndicatorView.swift
//  Psychics.iOS
//
//  Created by Q on 08/03/2019.
//  Copyright © 2019 Q. All rights reserved.
//

import UIKit
import VisualEffectView

class IndicatorView: UIView {

    var container = UIView()
    let activityView = InstagramActivityIndicator()
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    func addActivityIndicator() {
        frame = UIScreen.main.bounds
        alpha = 0.0
        
        let visualEffectView = VisualEffectView(frame: frame)
        visualEffectView.colorTintAlpha = 0.2
        visualEffectView.blurRadius = 5
        visualEffectView.scale = 1
        addSubview(visualEffectView)
        
        activityView.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0)
        activityView.center = center
        
        activityView.animationDuration = 1
        activityView.rotationDuration = 2
        activityView.numSegments = 24
        activityView.strokeColor = Colours.mainBlueColor
        activityView.lineWidth = 6
        
        container.addSubview(activityView)
        addSubview(container)
    }
    
    func showActivityIndicator() {
        activityView.startAnimating()
       
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        })
    }
    
    func hideActivityIndicator() {
        activityView.stopAnimating()
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        })
    }
}
