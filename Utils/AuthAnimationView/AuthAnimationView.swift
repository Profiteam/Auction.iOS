//
//  AuthAnimationView.swift
//  Auction
//
//  Created by Q on 29/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

protocol AnimateButtonDelegate: class {
    func animateAction()
}

class AuthAnimationView: UIView {
    
    weak var delegate: AnimateButtonDelegate?
    
    @IBOutlet var spotImage: UIImageView!
    @IBOutlet var columnImage: UIImageView!
    @IBOutlet var manImage: UIImageView!
    @IBOutlet var pictureImage: UIImageView!
    @IBOutlet var hammerImage: UIImageView!
    @IBOutlet var cartImage: UIImageView!
    @IBOutlet var tabbarImage: UIImageView!
    @IBOutlet var animateButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupMainView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupMainView()
    }
    
    func setupMainView() {
        let view = Bundle.main.loadNibNamed("AuthAnimationView", owner: self, options: nil)?.first as! UIView
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        view.frame.size.width = width
        view.frame.size.height = height
        
        self.addSubview(view)
    }
    
    
    @IBAction func animateButtonAction(_ sender: Any) {
        
        delegate?.animateAction()
        
        /*-----------------------------Images params-----------------------------------*/
        
        let manParams = (startPoint: self.manImage.center,
                         endPoint: CGPoint(x: -400.0, y: 40.0),
                         offsetX: CGFloat(100.0),
                         offsetY: CGFloat(100.0))
        
        let columnParams = (startPoint: self.columnImage.center,
                            endPoint: CGPoint(x: -400.0, y: 0.0),
                            offsetX: CGFloat(50.0),
                            offsetY: CGFloat(50.0))
        
        let hammerParams = (startPoint: self.hammerImage.center,
                            endPoint: CGPoint(x: 400.0, y: 0.0),
                            offsetX: CGFloat(0.0),
                            offsetY: CGFloat(-50.0))
        
        let cartParams = (startPoint: self.cartImage.center,
                          endPoint: CGPoint(x: 400.0, y: self.cartImage.frame.origin.y + 50.0),
                          offsetX: CGFloat(0.0),
                          offsetY: CGFloat(20.0))
        
        let pictureParams = (startPoint: self.pictureImage.center,
                             endPoint: CGPoint(x: 400.0, y: -20.0),
                             offsetX: CGFloat(0.0),
                             offsetY: CGFloat(-50.0))
        
        let tabbarParams = (startPoint: self.tabbarImage.center,
                            endPoint: CGPoint(x: -400.0, y: 40),
                            offsetX: CGFloat(0.0),
                            offsetY: CGFloat(0.0))
        
        let spotParams = (startPoint: self.spotImage.center,
                          endPoint: CGPoint(x: 800.0, y: 0.0),
                          offsetX: CGFloat(0.0),
                          offsetY: CGFloat(-50.0))
        
        
        /*-----------------------------Images animations-------------------------------*/
        
        //manImage
        animate(view: self.manImage, fromPoint: manParams.startPoint, toPoint: manParams.endPoint, offsetX: manParams.offsetX, offsetY: manParams.offsetY, duration: 1.0, alpha: 0.6)
        
        //columnImage
        animate(view: self.columnImage, fromPoint: columnParams.startPoint, toPoint: columnParams.endPoint, offsetX: columnParams.offsetX, offsetY: columnParams.offsetY, duration: 0.6, alpha: 0.8)
        
        //hammerImage
        animate(view: self.hammerImage, fromPoint: hammerParams.startPoint, toPoint: hammerParams.endPoint, offsetX: hammerParams.offsetX, offsetY: hammerParams.offsetY, duration: 0.6, alpha: 0.8)
        
        //cartImage
        animate(view: self.cartImage, fromPoint: cartParams.startPoint, toPoint: cartParams.endPoint, offsetX: cartParams.offsetX, offsetY: cartParams.offsetY, duration: 0.6, alpha: 0.6)
        
        //spotImage
        animate(view: self.spotImage, fromPoint: spotParams.startPoint, toPoint: spotParams.endPoint, offsetX: spotParams.offsetX, offsetY: spotParams.offsetY, duration: 0.6, alpha: 0.6)
        
        //tabbarImage
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.tabbarImage.center = CGPoint(x: self.tabbarImage.center.x + 2.0,
                                              y: self.tabbarImage.center.y - 25.0)
            self.tabbarImage.alpha = 0.6
        }, completion: { finished in
            
            self.animate(view: self.tabbarImage, fromPoint: self.tabbarImage.center, toPoint: tabbarParams.endPoint, offsetX: tabbarParams.offsetX, offsetY: tabbarParams.offsetY, duration: 0.4, alpha: 0.6)
        })
        
        //pictureImage
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.pictureImage.center = CGPoint(x: self.pictureImage.center.x + 0.5,
                                               y: self.pictureImage.center.y + 20.0)
            self.tabbarImage.alpha = 0.6
        }, completion: { finished in
            
            self.animate(view: self.pictureImage, fromPoint: self.pictureImage.center, toPoint: pictureParams.endPoint, offsetX: pictureParams.offsetX, offsetY: pictureParams.offsetY, duration: 0.4, alpha: 0.6)
        })
    }
    
    func animate(view : UIView, fromPoint start : CGPoint, toPoint end: CGPoint, offsetX: CGFloat, offsetY: CGFloat, duration: CFTimeInterval, alpha: CGFloat) {
        
        // The animation
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        // Animation path
        let path = UIBezierPath()
        
        let changeAlphaDuration = 0.5
        
        // Move the "cursor" to the start
        path.move(to: start)
        
        // Calculate the control points
        let c1 = CGPoint(x: start.x + offsetX,
                         y: start.y + offsetY)
        
        let c2 = CGPoint(x: end.x,
                         y: end.y + offsetY)
        
        // Draw a curve towards the end, using control points
        path.addCurve(to: end, controlPoint1: c1, controlPoint2: c2)
        
        // Use this path as the animation path (casted to CGPath)
        animation.path = path.cgPath;
        
        // The other animations properties
        animation.fillMode              = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.duration              = duration
        animation.timingFunction        = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)
        
        // Apply it
        view.layer.add(animation, forKey:"trash")
        
        // Set fade out animation
        UIView.animate(withDuration: changeAlphaDuration, animations: {
            view.alpha = alpha
        }, completion: { (finished: Bool) in
            view.removeFromSuperview()
        })
    }
}
