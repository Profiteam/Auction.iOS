//
//  WalletBalanceViewController.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class WalletBalanceViewController: UIViewController, WalletBalanceViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet var largeTitlePosY: NSLayoutConstraint!
    @IBOutlet weak var customTitle: UILabel!
    
    var presenter: WalletBalancePresenterProtocol?
    
    var balanceCell = BalanceCell()
    
    let defaults = UserDefaults.standard
    var topConstraintMovement = CGFloat()
    var balanceValue = Int()
    
    var purchaseArray = [PurchaseData]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.register(UINib(nibName: "BalanceCell", bundle: nil), forCellReuseIdentifier: "BalanceCell")
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        tableView.register(UINib(nibName: "NoPurchaseCell", bundle: nil), forCellReuseIdentifier: "NoPurchaseCell")
        tableView.register(UINib(nibName: "BiddingHistoryCell", bundle: nil), forCellReuseIdentifier: "BiddingHistoryCell")
        
        tableView.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 52.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:  //.iPhones_5_5s_5c_SE
            largeTitlePosY.constant = 62.0
            customTitle.font =  UIFont(name: "AvenirNextCondensed-Medium", size: 42.0)!
        case 1334:  //.iPhones_6_6s_7_8
            largeTitlePosY.constant = 62.0
        case 1920, 2208:  //.iPhones_6Plus_6sPlus_7Plus_8Plus
            largeTitlePosY.constant = 94.0
        default:
            largeTitlePosY.constant = 94.0
        }
        
        tableView.alpha = 0.0
        topConstraint.constant = 1000.0
        
        self.presenter?.interactor?.getWallet()
        self.presenter?.interactor?.getWalletHistory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch UIScreen.main.nativeBounds.height {
        case 1136: //.iPhone_5s_SE
            topConstraintMovement = 0.0
        case 1334: //.iPhones_6_6s_7_8
            topConstraintMovement = 50.0
        case 1920, 2208: //.iPhones_6Plus_6sPlus_7Plus_8Plus
            topConstraintMovement = 50.0
        default:
            topConstraintMovement = 90.0
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.topConstraint.constant = self.topConstraintMovement
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.5, animations: {
                self.customTitle.alpha = 1.0
                self.tableView.alpha = 1.0
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.customTitle.alpha = 0.0
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setWallet(data: Data) {
        let walletResponse = try? JSONDecoder().decode(WalletResponse.self, from: data)
        balanceValue = walletResponse?.balance ?? 0
        
        tableView.reloadData()
    }
    
    func setWalletHistory(data: Data) {
        let purchaseResponse = try? JSONDecoder().decode(PurchaseResponse.self, from: data)
        purchaseArray = purchaseResponse!
        
        tableView.reloadData()
    }
}


extension WalletBalanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 52.0))
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 162.0
        default:
            return 20.0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 110.0
        default:
            return 98.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let historyCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
            return historyCell
        case 2:
            if purchaseArray.count > 1 {
                let biddingHistoryCell = tableView.dequeueReusableCell(withIdentifier: "BiddingHistoryCell") as! BiddingHistoryCell
            
                biddingHistoryCell.titleLabel.text = purchaseArray[indexPath.row].name
                
                var amount = purchaseArray[indexPath.row].amount
                if let dotRange = amount.range(of: ".") {
                    amount.removeSubrange(dotRange.lowerBound..<amount.endIndex)
                    biddingHistoryCell.valueLabel.text = amount + NSLocalizedString(" bids", comment: "")
                }
                
                biddingHistoryCell.subtitleLabel.text = purchaseArray[indexPath.row].date
                biddingHistoryCell.subtitleLabel.text = biddingHistoryCell.subtitleLabel.text?.replacingOccurrences(of: "-", with: ".", options: NSString.CompareOptions.literal, range: nil)
                biddingHistoryCell.subtitleLabel.text = biddingHistoryCell.subtitleLabel.text?.replacingOccurrences(of: "T", with: " ", options: NSString.CompareOptions.literal, range: nil)

                let timeString = biddingHistoryCell.subtitleLabel.text
                if let index = timeString?.range(of: ".")?.lowerBound {
                    let substring = timeString?[..<index]
                    biddingHistoryCell.subtitleLabel.text = String(substring ?? "")
                }
                
                return biddingHistoryCell
                
            } else {
                let noPurchaseCell = tableView.dequeueReusableCell(withIdentifier: "NoPurchaseCell") as! NoPurchaseCell
                
                return noPurchaseCell
            }
        default:
            balanceCell = tableView.dequeueReusableCell(withIdentifier: "BalanceCell") as! BalanceCell
            balanceCell.balanceLabel.text = String(balanceValue) + NSLocalizedString(" bids", comment: "")
            
            return balanceCell
        }
    }
}

extension WalletBalanceViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 120.0 {
            let percent: CGFloat = (scrollView.contentOffset.y / 12.0)
            customTitle.alpha = percent
        } else {
            customTitle.alpha = 1.0
        }
    }
}
