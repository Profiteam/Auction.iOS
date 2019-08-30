//
//  BiddingHistoryViewController.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BiddingHistoryViewController: UIViewController, BiddingHistoryViewProtocol, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: BiddingHistoryPresenterProtocol?
    
    var biddingHistoryCell = BiddingHistoryCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BiddingHistoryCell", bundle: nil), forCellReuseIdentifier: "BiddingHistoryCell")
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
    
    @IBAction func backButtonGesture(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: TableView Delegate & DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        biddingHistoryCell = tableView.dequeueReusableCell(withIdentifier: "BiddingHistoryCell") as! BiddingHistoryCell
        biddingHistoryCell.selectionStyle = .none
        
        //        if (lotModel.count > 0) {
        //            biggerItemWithButtonCell.title.text = lotModel[indexPath.row].lotName
        //            biggerItemWithButtonCell.price.text = lotModel[indexPath.row].startPrice
        //            biggerItemWithButtonCell.bets.text = ""
        //
        //            if (lotModel[indexPath.row].mainImage != "/media/default.png") {
        //                let url = URL(string: URLs.baseUrl +  lotModel[indexPath.row].mainImage!)
        //                biggerItemWithButtonCell.itemImage.af_setImage(withURL: url!)
        //            } else {
        //                biggerItemWithButtonCell.itemImage.image = UIImage.init()
        //            }
        //        }
        return biddingHistoryCell
    }
}
