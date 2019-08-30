//
//  CustomModalView.swift
//  Auction
//
//  Created by Q on 23/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class CustomModalView: UIView {
    
    let coefWidth: CGFloat = 1.09
    let coefHeight: CGFloat = 1.43
    
    let imgCoefWidth: CGFloat = 1.08
    let imgCoefHeight: CGFloat = 2.19
    
    let animateImgCoefWidth: CGFloat = 2.6
    let animateImgCoefHeight: CGFloat = 1.3
    
    var backgroundView = UIView()
    var modalView = UIView()
    var backgroundImage = UIImageView()
    var backgroudnDynamicImage = UIImageView()
    var animateImage = UIImageView()
    
    var button = UIButton()
    var secondButton = UIButton()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLayers()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        initLayers()
    }
    
    func initLayers() {
        // Background view
        
        let width: CGFloat = UIScreen.main.bounds.width/coefWidth
        let height: CGFloat = UIScreen.main.bounds.height/coefHeight
        
        let xPos: CGFloat = UIScreen.main.bounds.width/2 - width/2
        let yPos: CGFloat = UIScreen.main.bounds.height*2
        
        backgroundView = UIView.init(frame: UIScreen.main.bounds)
        backgroundView.backgroundColor = Colours.modalBehindViewColor
        
        // Modal view
        
        modalView = .init(frame:CGRect(x: xPos, y: yPos, width: width, height: height))
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 10.0
        
        
        // Background image
        
        let imageWidth: CGFloat = modalView.frame.width/imgCoefWidth
        let imageHeight: CGFloat = modalView.frame.height/imgCoefHeight
        
        let imagePosX: CGFloat = modalView.frame.size.width/2 - imageWidth/2
        let imagePosY: CGFloat = -modalView.frame.size.height/2.5 + imageHeight
        
        backgroundImage = UIImageView.init(frame: CGRect(x: imagePosX, y: imagePosY, width: imageWidth, height: imageHeight))
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.image = UIImage.init(named: "ic_oval_animate")
        
        modalView.addSubview(backgroundImage)
        
        // Dynamic Image
        
        backgroudnDynamicImage = .init(frame: backgroundImage.frame)
        backgroudnDynamicImage.contentMode = .scaleAspectFit
        backgroudnDynamicImage.alpha = 0.0
        
        modalView.addSubview(backgroudnDynamicImage)
        
        
        let animateImageWidth = imageWidth/2.3
        let animateImageHeight = imageHeight
        animateImage = .init(frame: CGRect(x: modalView.frame.size.width/2 - animateImageWidth/2,
                                           y: 0.0,
                                           width: animateImageWidth,
                                           height: animateImageHeight))
        animateImage.contentMode = .scaleAspectFit
        animateImage.alpha = 0.0
        
        
        modalView.addSubview(animateImage)
        
        // OK Button
        
        let buttonMargin = modalView.frame.width/9.0
        let buttonWidth = modalView.frame.width - buttonMargin
        let buttonHeight = buttonWidth/6.5
        
        let buttonPosX = modalView.frame.width/2 - buttonWidth/2
        let buttonPosY = modalView.frame.height - (buttonHeight + buttonHeight/2)
        
        button = .init(frame: CGRect(x: buttonPosX, y: buttonPosY, width: buttonWidth, height: buttonHeight))
        button.backgroundColor = Colours.mainBlueColor
        button.layer.cornerRadius = buttonHeight/2
        button.setTitle(NSLocalizedString("OK!", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Medium", size: 20.0)!
        button.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        
        addSubview(backgroundView)
        
        backgroundView.addSubview(modalView)
        
        modalView.addSubview(button)
    }
    
    func badgeModalView(badgeName: String, badgeImage: UIImage, description: String) {
        // Background
        
        backgroudnDynamicImage.image = UIImage()
        
        // Animate Image
        
        animateImage.image = badgeImage
        
        let labelWidth: CGFloat = modalView.frame.width - 20.0
        let labelHeight: CGFloat = 140.0
        
        let titleLabel = UILabel.init(frame:CGRect(x: modalView.frame.width/2 - labelWidth/2,
                                                   y: animateImage.frame.origin.y + animateImage.frame.height/1.3,
                                                   width: labelWidth,
                                                   height: labelHeight))
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!
        titleLabel.textAlignment = .center
        titleLabel.text = badgeName
        
        let label = UILabel.init(frame:CGRect(x: modalView.frame.width/2 - labelWidth/2,
                                              y: modalView.frame.height/2 + 24.0,
                                              width: labelWidth,
                                              height: labelHeight))
        label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0)
        label.font = UIFont(name: "AvenirNextCondensed-Regular", size: 15.0)!
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = description
        
        label.sizeToFit()
        
        modalView.addSubview(label)
        modalView.addSubview(titleLabel)
    }
    
    func winModalView() {
        animateImage.image = UIImage.init(named: "ic_win_animate")
        backgroudnDynamicImage.image = UIImage.init(named: "ic_stars_animate")
        
        // Label
        
        let labelWidth: CGFloat = modalView.frame.width - 20.0
        let labelHeight: CGFloat = 140.0
        
        let label = UILabel.init(frame:CGRect(x: modalView.frame.width/2 - labelWidth/2,
                                              y: modalView.frame.height/2,
                                              width: labelWidth,
                                              height: labelHeight))
        label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
        label.font = UIFont(name: "AvenirNextCondensed-Regular", size: 24.0)!
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        let attributedString = NSMutableAttributedString(string:"")
        
        let firstLine = "Congratulations!\n"
        let firstLineAttribute = [ NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 24.0)!]
        let secondLine = "You have won an action.\n"
        let secondLineAttribute = [NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Regular", size: 21.0)!]
        let thirdLine = "You can see your items \nat the profile"
        let thirdLineAttribute = [NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-UltraLight", size: 19.0)!]
        
        let newAttributedFirstLine: NSAttributedString = NSAttributedString(string: firstLine, attributes: firstLineAttribute)
        let newAttributedSecondLine: NSAttributedString = NSAttributedString(string: secondLine, attributes: secondLineAttribute)
        let newAttributedThirdLine: NSAttributedString = NSAttributedString(string: thirdLine, attributes: thirdLineAttribute)
        
        attributedString.append(newAttributedFirstLine)
        attributedString.append(newAttributedSecondLine)
        attributedString.append(newAttributedThirdLine)
        
        label.attributedText = attributedString
        
        modalView.addSubview(label)
    }
    
    func closedModalView() {
        // Background
        
        backgroudnDynamicImage.image = UIImage()
        
        // Animate Image
        
        animateImage.image = UIImage.init(named: "ic_auc_animate")
        
        let labelWidth: CGFloat = modalView.frame.width - 20.0
        let labelHeight: CGFloat = 140.0
        
        let label = UILabel.init(frame:CGRect(x: modalView.frame.width/2 - labelWidth/2,
                                              y: modalView.frame.height/2 + 24.0,
                                              width: labelWidth,
                                              height: labelHeight))
        label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0)
        label.font = UIFont(name: "AvenirNextCondensed-Medium", size: 24.0)!
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "The auction is closed."
        
        modalView.addSubview(label)
    }
    
    func exitModalView() {
        // Background
        
        backgroudnDynamicImage.image = UIImage.init(named: "modal_stars")
        
        // Animate Image
        
        animateImage.image = UIImage.init(named: "ic_logout_animate")
        animateImage.frame = CGRect(x: self.animateImage.frame.origin.x,
                                    y: self.animateImage.frame.origin.y,
                                    width: self.animateImage.frame.size.width,
                                    height: self.animateImage.frame.size.height)
        
        // Button
        
        let buttonWidth: CGFloat = modalView.frame.width/2 - 28.0
        let buttonHeight: CGFloat = 44.0
        let buttonPosY = modalView.frame.height - buttonHeight - 30.0
        
        button.frame = CGRect(x: 16.0, y: buttonPosY, width: buttonWidth, height: buttonHeight)
        button.setTitle("No", for: .normal)
        
        // Second Button
        
        let buttonPosX = modalView.frame.width - buttonWidth - 16.0
        secondButton = UIButton.init(frame: CGRect(x: buttonPosX, y: buttonPosY, width: buttonWidth, height: buttonHeight))
        secondButton.backgroundColor = Colours.mainBlueColor
        secondButton.layer.cornerRadius = buttonHeight/2
        secondButton.setTitle("Yes", for: .normal)
        secondButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Regular", size: 20.0)!
        
        modalView.addSubview(secondButton)
        
        // Label
        
        let labelWidth: CGFloat = modalView.frame.width - 40.0
        let labelHeight: CGFloat = 140.0
        
        let label = UILabel.init(frame:CGRect(x: modalView.frame.width/2 - labelWidth/2,
                                              y: modalView.frame.height/2 + 24.0,
                                              width: labelWidth,
                                              height: labelHeight))
        label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0)
        label.font = UIFont(name: "AvenirNextCondensed-Medium", size: 24.0)!
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = "Are you sure you want to exit?"
        
        modalView.addSubview(label)
    }
    
    func noSignalModalView() {
        // Background
        
        backgroudnDynamicImage.image = UIImage.init(named: "ic_questions_animate")
        
        // Animate Image
        
        animateImage.image = UIImage.init(named: "ic_sure_animate")
        
        // Label
        
        let labelWidth: CGFloat = modalView.frame.width - 20.0
        let labelHeight: CGFloat = 100.0
        
        let label = UILabel.init(frame:CGRect(x: modalView.frame.width/2 - labelWidth/2, 
                                              y: modalView.frame.height/2 + 12.0,
                                              width: labelWidth,
                                              height: labelHeight))
        label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0)
        label.font = UIFont(name: "AvenirNextCondensed-Medium", size: 24.0)!
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        let attributedString = NSMutableAttributedString(string:"")
        
        let firstLine = "Oops!!\n"
        let firstLineAttribute = [ NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Medium", size: 24.0)!]
        let secondLine = "No signal, try again:("
        let secondLineAttribute = [NSAttributedString.Key.font : UIFont(name: "AvenirNextCondensed-Regular", size: 21.0)!]
        
        let newAttributedFirstLine: NSAttributedString = NSAttributedString(string: firstLine, attributes: firstLineAttribute)
        let newAttributedSecondLine: NSAttributedString = NSAttributedString(string: secondLine, attributes: secondLineAttribute)
        
        attributedString.append(newAttributedFirstLine)
        attributedString.append(newAttributedSecondLine)
        
        label.attributedText = attributedString
        
        modalView.addSubview(label)
    }
    
    @objc func closeModal() {
        hide()
    }
    
    // MODAL APPEAR METHOD'S
    
    func prepare() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
                        self.modalView.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                                        y: UIScreen.main.bounds.height/2)
        }, completion: nil)
    }

    func animate() {
        UIView.animate(withDuration: 0.3, delay: 0.15, animations: {
            self.animateImage.alpha = 1.0
        }, completion: { (value: Bool) in
            UIView.animate(withDuration: 0.3, delay: 0.15, animations: {
                self.animateImage.center.y = self.animateImage.center.y + 20.0
                self.animateImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.backgroudnDynamicImage.alpha = 1.0
            })
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
            self.animateImage.alpha = 0.0
            self.modalView.center = CGPoint(x: UIScreen.main.bounds.width/2,
                                            y: 1500.0)
            self.animateImage.center.y = 1500.0
            self.backgroudnDynamicImage.alpha = 0.0
            
        }, completion: { (value: Bool) in
            self.removeFromSuperview()
        })
    }
}
