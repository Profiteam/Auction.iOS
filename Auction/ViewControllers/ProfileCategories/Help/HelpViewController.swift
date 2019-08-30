//
//  HelpViewController.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, HelpViewProtocol {

    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: HelpPresenterProtocol?
    
    let titles = ["How it works", "How to bid in auctio", "Tips&Tricks", "Auction Special Offers", "What is a bid pack", "What is «Time as highest bidder»", "Orders&Shipping", "Payments", "Contact Support", "Privacy policy", "Terms of use"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.register(UINib(nibName: "HelpCell", bundle: nil), forCellReuseIdentifier: "HelpCell")
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

extension HelpViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let helpCell = tableView.dequeueReusableCell(withIdentifier: "HelpCell") as! HelpCell
        helpCell.titleLabel.text = titles[indexPath.row]
        
        return helpCell
    }
}
