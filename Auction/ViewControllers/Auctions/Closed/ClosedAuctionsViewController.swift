//
//  ClosedAuctionsViewController.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import Kingfisher

class ClosedAuctionsViewController: UIViewController, ClosedAuctionsViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var emptyLabel: UILabel!
    
    var presenter: ClosedAuctionsPresenterProtocol?
    
    var searchBarView = SearchBarView()
    var largeTitleCell = LargeTitleCell()
    var itemWithButtonCell = ItemWithButtonCell()
    var biggerItemWithButtonCell = BiggerItemWithButtonCell()
    var closedLots = [LotData]()
    var isBiggerStyle: Bool = false
    
    var search = String()
    var searchData = [[String: Any]]()
    var searchArray = [[String: Any]]()
    
    var currentIndex = Int()
    
    var rate = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.isHidden = false
        tableView.startBlink()
        
        self.presenter?.interactor?.getCurrencyRate()
        
        searchBarView.searchTextField.text?.removeAll()
    }
    
    // MARK: -
    // MARK: - methods
    
    func setupViews() {
        tableView.frame = CGRect(x: 0.0, y: -12.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 144.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ItemWithButtonCell", bundle: nil), forCellReuseIdentifier: "ItemWithButtonCell")
        tableView.register(UINib(nibName: "BiggerItemWithButtonCell", bundle: nil), forCellReuseIdentifier: "BiggerItemWithButtonCell")
        
        // init searchBar
        searchBarView.addSearchTextField()
        searchBarView.searchTextField.delegate = self
        searchBarView.switchButton.addTarget(self, action: #selector(switchCellStyle), for: .touchUpInside)
        searchBarView.isUserInteractionEnabled = false
        view.addSubview(searchBarView)
    }
    
    @objc func switchCellStyle() {
        if isBiggerStyle == true {
            isBiggerStyle = false
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        } else {
            isBiggerStyle = true
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setCurrencyRate(data: Data) {
        let exchangeRateResponse = try? JSONDecoder().decode(ExchangeRateResponse.self, from: data)
        rate = exchangeRateResponse?.rate ?? 0
        if rate > 0 {
            UserDefaults.standard.set(rate, forKey: "rate")
        }
        
        self.presenter?.interactor?.getClosedLots()
    }
    
    func updateClosedLots(data: Data) {
        searchData.removeAll()
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [[String: Any]] {
            searchData = dictionary
        }
        searchArray = searchData
        
        searchBarView.isUserInteractionEnabled = true
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        tableView.stopBlink()
        
        if searchData.count == 0 {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    func updateLotStatus(data: Data) {
        self.presenter?.interactor?.getClosedLots()
    }
}

extension ClosedAuctionsViewController: CellButtonDelegate {
    
    func openItemPageViewController(_ sender: UIButton) {
        
    }
    
    func addToFavourite(_ sender: UIButton) {
        currentIndex = sender.tag
        self.presenter?.interactor?.addLotToFavorite(lotID: String(currentIndex))
    }
    
    func removeFromFavoutire(_ sender: UIButton) {
        currentIndex = sender.tag
        self.presenter?.interactor?.removeLotToFavorite(lotID: String(currentIndex))
    }
}

extension ClosedAuctionsViewController: BiggerCellButtonDelegate {
    
    func biggerOpenItemPageViewController(_ sender: UIButton) {
        UserDefaults.standard.set(searchData[sender.tag]["id"], forKey: "lotID")
        
        let itemPageViewController = ItemPageRouter.createModule()
        navigationController?.pushViewController(itemPageViewController, animated: true)
    }
    
    func biggerAddToFavourite(_ sender: UIButton) {
        currentIndex = sender.tag
        self.presenter?.interactor?.addLotToFavorite(lotID: String(currentIndex))
    }
    
    func biggerRemoveFromFavoutire(_ sender: UIButton) {
        currentIndex = sender.tag
        self.presenter?.interactor?.removeLotToFavorite(lotID: String(currentIndex))
    }
}

extension ClosedAuctionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchData.count > 0 {
            return searchData.count
        } else {
            return 3
        } 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isBiggerStyle == true {
            return 189.0
        } else {
            return 152.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        itemWithButtonCell = tableView.dequeueReusableCell(withIdentifier: "ItemWithButtonCell") as! ItemWithButtonCell
        itemWithButtonCell.delegate = self
        itemWithButtonCell.starButton.isHidden = true
        
        itemWithButtonCell.button.backgroundColor = .white
        itemWithButtonCell.button.titleLabel?.adjustsFontSizeToFitWidth = true
        itemWithButtonCell.button.titleLabel?.numberOfLines = 2
        itemWithButtonCell.button.titleLabel?.textAlignment = .center
        
        biggerItemWithButtonCell = tableView.dequeueReusableCell(withIdentifier: "BiggerItemWithButtonCell") as! BiggerItemWithButtonCell
        biggerItemWithButtonCell.delegate = self
        biggerItemWithButtonCell.starButton.isHidden = true
        
        biggerItemWithButtonCell.button.backgroundColor = .clear
        biggerItemWithButtonCell.button.titleLabel?.adjustsFontSizeToFitWidth = true
        biggerItemWithButtonCell.button.titleLabel?.numberOfLines = 2
        biggerItemWithButtonCell.button.titleLabel?.textAlignment = .center
        
        if searchData.count > 0 {
            itemWithButtonCell.title.text = searchData[indexPath.row]["name"] as? String
            itemWithButtonCell.starButton.isHidden = false
            let priceString = searchData[indexPath.row]["start_price"] as? String ?? "0"
            let price = NumberFormatter().number(from: priceString)!.doubleValue * rate
            
            if UserDefaults.standard.string(forKey: "current_curr") == "USD" {
                itemWithButtonCell.price.text = NSLocalizedString("Price: ", comment: "") + "\(String(format: "%g", price)) $"
                biggerItemWithButtonCell.price.text = NSLocalizedString("Price: ", comment: "") + "\(String(format: "%g", price)) $"
            } else {
                itemWithButtonCell.price.text = NSLocalizedString("Price: ", comment: "") + "\(String(format: "%g", price)) €"
                biggerItemWithButtonCell.price.text = NSLocalizedString("Price: ", comment: "") + "\(String(format: "%g", price)) €"
            }
            
            let bets: Int = searchData[indexPath.row]["bets_count"] as! Int
            itemWithButtonCell.bets.text = NSLocalizedString("Bets ", comment: "") + "\(String(bets))"
            itemWithButtonCell.starButton.tag = searchData[indexPath.row]["id"] as! Int
            
            biggerItemWithButtonCell.starButton.isHidden = false
            biggerItemWithButtonCell.title.text = searchData[indexPath.row]["name"] as? String
            biggerItemWithButtonCell.starButton.tag = searchData[indexPath.row]["id"] as! Int
            
            if let isFavorite: Int = searchData[indexPath.row]["is_favorite"] as? Int {
                if isFavorite == 1 {
                    itemWithButtonCell.starButton.isSelected = true
                    biggerItemWithButtonCell.starButton.isSelected = true
                } else {
                    itemWithButtonCell.starButton.isSelected = false
                    biggerItemWithButtonCell.starButton.isSelected = false
                }
            }
            
            if let imageUrl = searchData[indexPath.row]["image1"] as? String {
                var resultUrl = URLs.baseUrl
                resultUrl.removeLast()
                resultUrl = resultUrl + imageUrl
                itemWithButtonCell.itemImage.kf.setImage(with: URL(string: resultUrl))
                biggerItemWithButtonCell.itemImage.kf.setImage(with: URL(string: resultUrl))
            } else {
                itemWithButtonCell.itemImage.image = UIImage.init(named: "ic_placeholder")
                itemWithButtonCell.itemImage.contentMode = .scaleAspectFit
                biggerItemWithButtonCell.itemImage.image = UIImage.init(named: "ic_placeholder")
                biggerItemWithButtonCell.itemImage.contentMode = .scaleAspectFit
            }
        }
        
        if isBiggerStyle == true {
            return biggerItemWithButtonCell
        } else {
            return itemWithButtonCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200.0))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if searchBarView.searchTextField.isFirstResponder {
            return UIScreen.main.bounds.height/2 - 90.0
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(searchData[indexPath.row]["id"], forKey: "lotID")
        
        let itemPageViewController = ItemPageRouter.createModule()
        navigationController?.pushViewController(itemPageViewController, animated: true)
    }
}

extension ClosedAuctionsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            search = String(search.dropLast())
        } else {
            search = textField.text! + string
        }
        
        let predicate = NSPredicate(format: "SELF.name CONTAINS[cd] %@", search)
        let arr = (searchArray as NSArray).filtered(using: predicate)
        if arr.count > 0 {
            searchData.removeAll(keepingCapacity: true)
            searchData = arr as! [[String : Any]]
        } else {
            if search.count > 0 {
                searchData.removeAll(keepingCapacity: true)
            } else {
                searchData = searchArray
            }
        }
        
        tableView.reloadData()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.reloadSections(NSIndexSet(indexesIn: NSMakeRange(0, self.tableView.numberOfSections)) as IndexSet, with: .none)
        searchBarView.searchButton.isSelected = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.reloadSections(NSIndexSet(indexesIn: NSMakeRange(0, self.tableView.numberOfSections)) as IndexSet, with: .none)
        searchBarView.searchButton.isSelected = false
        
        if textField.text!.isEmpty {
            self.presenter?.interactor?.getClosedLots()
        }
    }
}
