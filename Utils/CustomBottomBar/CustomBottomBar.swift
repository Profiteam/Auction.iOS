//
//  CustomBottomBar.swift
//  Auction
//
//  Created by Q on 19/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import CountdownLabel

@objc protocol CustomBottomBarProtocol {
    func middleButtonDidTouch(sender: UIButton)
}

class CustomBottomBar: UIView, CountdownLabelDelegate, LTMorphingLabelDelegate {
    
    var delegate: CustomBottomBarProtocol?
    
    var circleLayer = CAShapeLayer()
    var barHeight: CGFloat = 64.0
    var buttonInset: CGFloat = 0.0
    var countdownLabel = CountdownLabel()
    var buttonTag: Int = 0
    var middleButton = GRButton()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(image: UIImage, title: String) {
        self.init(frame: .zero)
    }
    
    func createOverlay() {
        switch UIScreen.main.nativeBounds.height {
        case 1136:  //.iPhones_5_5s_5c_SE
            barHeight = 64.0
        default:
            barHeight = 84.0
        }
        
        frame = CGRect(x: 0.0, y: UIScreen.main.bounds.height + 200.0, width: UIScreen.main.bounds.width, height: barHeight)
        backgroundColor = .clear
        
        // CutsomBar Shadow
        
        layer.shadowColor = Colours.customBottomBarColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: -2)
        
        let radius = barHeight/2
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: barHeight), cornerRadius: 0)
        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: center.x, y: 0.0), radius: radius, startAngle: 0, endAngle: .pi, clockwise: true)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.white.cgColor
        fillLayer.opacity = 1.0
        layer.addSublayer(fillLayer)
        
        createMiddleButton()
    }
    
    func createMiddleButton() {
        if UIScreen.main.nativeBounds.height > 1500.0 {
            barHeight = 84.0
        }
        
        buttonInset = barHeight/6
        
        let buttonSize = barHeight - buttonInset
        let buttonPosX = UIScreen.main.bounds.width/2 - buttonSize/2
        
        // init middle button
        middleButton = GRButton(frame: CGRect(x: buttonPosX, y: -buttonSize/2, width: buttonSize, height: buttonSize))
        middleButton.layer.cornerRadius = buttonSize/2
        middleButton.startColor = .white
        middleButton.endColor = .white
        middleButton.setImage(UIImage(named: "ic_dollar_blue"), for: .normal)
        middleButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        middleButton.isUserInteractionEnabled = false
        
        addSubview(middleButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.center.y = UIScreen.main.bounds.height - self.barHeight/2
            }, completion: nil)
        }
    }
    
    func changeButtonStyle(style: Int) {
        circleLayer.removeFromSuperlayer()
        
        if style == 0 {
            middleButton.setImage(UIImage(named: "ic_dollar_white"), for: .normal)
            middleButton.startColor = Colours.mainBlueColor
            middleButton.endColor = Colours.mainBlueColor
            middleButton.isUserInteractionEnabled = true
            middleButton.horizontalMode = true
            
            // change shadow
            middleButton.shadowColor = UIColor(red: 0.17, green: 0.4, blue: 0.98, alpha: 0.5)
            middleButton.shadowOffset = CGSize(width: 0.0, height: 2.0)
            middleButton.shadowRadius = 5.0
            middleButton.shadowOpacity = 1.0
            
            countdownLabel.alpha = 0.0
        } else {
            middleButton.removeFromSuperview()
            createMiddleButton()
        }
    }
    
    @objc func middleButtonAction(sender: UIButton) {
        self.delegate?.middleButtonDidTouch(sender: sender)
    }
    
    func animateTimer(timerDuration: CFTimeInterval) {
        middleButton.setImage(UIImage.init(), for: .normal)
        middleButton.startColor = .white
        middleButton.endColor = .white
        
        // Circle Animation
        
        let radius = (middleButton.frame.size.height + buttonInset)/2
        circleLayer.strokeColor = Colours.mainBlueColor.cgColor
        circleLayer.lineWidth = radius
        layer.addSublayer(circleLayer)
        
        let center = middleButton.center
        let startAngle: CGFloat = -0.25 * 2 * .pi
        let endAngle: CGFloat = startAngle + 2 * .pi
        circleLayer.path = UIBezierPath(arcCenter: center, radius: radius/2, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        circleLayer.strokeEnd = 0
        circleLayer.strokeEnd = 1
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = timerDuration
        circleLayer.add(animation, forKey: nil)
        
        // Countdown Label
        
        countdownLabel.frame = CGRect(x: 0.0, y: 0.0, width: 52.0, height: 52.0)
        countdownLabel.delegate = self
        countdownLabel.center = CGPoint(x: middleButton.center.x, y: middleButton.center.y)
        countdownLabel.adjustsFontSizeToFitWidth = true
        countdownLabel.textColor = Colours.mainBlueColor
        countdownLabel.textAlignment = .center
        countdownLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        countdownLabel.setCountDownTime(minutes: timerDuration)
        countdownLabel.animationType = .Evaporate
        countdownLabel.timeFormat = "mm:ss"
        addSubview(countdownLabel)
        
        bringSubviewToFront(middleButton)
        bringSubviewToFront(countdownLabel)
        countdownLabel.start()
        
        countdownLabel.alpha = 1.0
    }
}
