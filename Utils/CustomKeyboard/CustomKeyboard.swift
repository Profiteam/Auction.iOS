//
//  CustomKeyboard.swift
//  Auction
//
//  Created by Q on 05/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import AVFoundation

protocol CustomKeyboardButtonDelegate: class {
    func numericButtonPressed(sender: String)
    func doneButtonPressed()
    func removeButtonPressed()
}

class CustomKeyboard: UIView {
    
    weak var delegate: CustomKeyboardButtonDelegate?
    
    var audioPlayer = AVAudioPlayer()
    let deleteSound = Bundle.main.url(forResource: "KeypressDelete", withExtension: "mp3")
    let returnSound = Bundle.main.url(forResource: "KeypressReturn", withExtension: "mp3")
    let standartSound = Bundle.main.url(forResource: "KeypressStandard", withExtension: "mp3")
    
    var button = UIButton()
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height/1.96
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createKeyboard()
        
        self.createButtonView()
    }

    func createKeyboard() {
        //Adding shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.9
        self.layer.shadowRadius = 6.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //Adding CornerRadius
        self.layer.cornerRadius = 10.0
        //hide bottomCorner
        let hideBottomCornerView = UIView.init(frame: CGRect.init(x: 0.0, y: self.frame.height - 20.0, width: self.frame.width, height: 20.0))
        hideBottomCornerView.backgroundColor = .white
        self.addSubview(hideBottomCornerView)
    }
    
    func createButtonView() {
        let buttonWidth: CGFloat = width/3
        let buttonHeight: CGFloat = height/4
       
        var xPos: CGFloat = 0.0
        var yPos: CGFloat = 0.0
        
        var i = 0
        while i < 12 {
            button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Regular", size: 48.0)!
            button.setTitleColor(UIColor.init(red: 0.29, green: 0.29, blue: 0.29, alpha: 1.0), for: .normal)
            button.setTitleColor(UIColor.lightGray, for: .highlighted)
            
            switch i {
            case 3:
                yPos = yPos + buttonHeight
                xPos = 0.0
                button = UIButton.init(frame: CGRect(x: xPos, y: yPos, width: buttonWidth, height: buttonHeight))
                button.setTitle(String(i + 1), for: .normal)
            case 6:
                yPos = yPos + buttonHeight
                xPos = 0.0
                button = UIButton.init(frame: CGRect(x: xPos, y: yPos, width: buttonWidth, height: buttonHeight))
                button.setTitle(String(i + 1), for: .normal)
            case 9:
                yPos = yPos + buttonHeight
                xPos = 0.0
                button = UIButton.init(frame: CGRect(x: xPos, y: yPos, width: buttonWidth, height: buttonHeight))
                button.setTitle("", for: .normal)
                button.setImage(UIImage.init(named: "ic_keyboard_remove"), for: .normal)
            case 10:
                button = UIButton.init(frame: CGRect(x: xPos, y: yPos, width: buttonWidth, height: buttonHeight))
                button.setTitle("0", for: .normal)
            case 11:
                button = UIButton.init(frame: CGRect(x: xPos, y: yPos, width: buttonWidth, height: buttonHeight))
                button.setTitle("", for: .normal)
                button.setImage(UIImage.init(named: "ic_keyboard_enter"), for: .normal)
            default:
                button = UIButton.init(frame: CGRect(x: xPos, y: yPos, width: buttonWidth, height: buttonHeight))
                button.setTitle(String(i + 1), for: .normal)
            }

            i = i + 1
            xPos = xPos + buttonWidth

            if (i == 10) {
                button.addTarget(self, action: #selector(self.removeButtonClicked), for: .touchUpInside)
            } else if (i == 12) {
                button.addTarget(self, action: #selector(self.doneButtonClicked), for: .touchUpInside)
            } else {
                button.addTarget(self, action: #selector(self.numericButtonClicked(button:)), for: .touchUpInside)
            }
            
            self.addSubview(button)
        }
    }
    
    @objc func numericButtonClicked(button: UIButton) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: standartSound!)
            audioPlayer.play()
        } catch {
            print("couldn't load sound file")
        }
        
        delegate?.numericButtonPressed(sender: (button.titleLabel?.text)!)
    }
    
    @objc func doneButtonClicked() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: returnSound!)
            audioPlayer.play()
        } catch {
            print("couldn't load sound file")
        }
        
        delegate?.doneButtonPressed()
    }
    @objc func removeButtonClicked() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: deleteSound!)
            audioPlayer.play()
        } catch {
            print("couldn't load sound file")
        }
        
        delegate?.removeButtonPressed()
    }
    
    func showKeyboard() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.frame.origin.y = UIScreen.main.bounds.height - self.height
        }, completion: nil)
    }
    
    func hideKeyboard() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.frame.origin.y = UIScreen.main.bounds.height + self.height
        }, completion: nil)
    }
}
