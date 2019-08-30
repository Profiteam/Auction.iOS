//
//  NotificationsViewController.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController, NotificationsViewProtocol {

    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: NotificationsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationHeight.constant = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
        if let locale = NSLocale.current.languageCode {
            if String(locale) == "ar" {
                let newImage = backButtonImage.image?.rotate(radians: .pi)
                backButtonImage.image = newImage
            }
        }
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func backButtonGesture(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - Presenter Callback

}
