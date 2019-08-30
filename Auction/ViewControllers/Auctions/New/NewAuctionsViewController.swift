//
//  NewAuctionsViewController.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Kingfisher

class NewAuctionsViewController: UIViewController, NewAuctionsViewProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: NewAuctionsPresenterProtocol?
    
    var currentIndex = Int()
    var timer = Timer()
    
    var searchBarView = SearchBarView()
    let itemPageViewController = ItemPageRouter.createModule()
    var largeTitleCell = LargeTitleCell()
    var itemWithButtonCell = ItemWithButtonCell()
    var biggerItemWithButtonCell = BiggerItemWithButtonCell()
    var offerTableViewCell = OfferTableViewCell()
    var collectionView: UICollectionView!
    var itemCollectionViewCell = ItemCollectionViewCell()
    var isBiggerStyle: Bool = false
    
    var newLots = [LotData]()
    var startedLots = [LotData]()
    
    var search = String()
    var searchData = [[String: Any]]()
    var searchArray = [[String: Any]]()
    
    var rate = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkInternetConnection), userInfo: nil, repeats: true)
        
        searchBarView.searchTextField.text?.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchBarView.searchTextField.resignFirstResponder()
    }
    
    // MARK: -
    // MARK: - methods
    
    @objc func checkInternetConnection() {
        if Connectivity.isConnectedToInternet() {
            self.presenter?.interactor?.getCurrencyRate()
            
            timer.invalidate()
        }
    }
    
    func setupViews() {
        // init searchBar
        searchBarView.addSearchTextField()
        searchBarView.searchTextField.delegate = self
        searchBarView.switchButton.addTarget(self, action: #selector(switchCellStyle), for: .touchUpInside)
        view.addSubview(searchBarView)
        
        // init tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LargeTitleCell", bundle: nil), forCellReuseIdentifier: "LargeTitleCell")
        tableView.register(UINib(nibName: "ItemWithButtonCell", bundle: nil), forCellReuseIdentifier: "ItemWithButtonCell")
        tableView.register(UINib(nibName: "BiggerItemWithButtonCell", bundle: nil), forCellReuseIdentifier: "BiggerItemWithButtonCell")
        tableView.register(UINib(nibName: "OfferTableViewCell", bundle: nil), forCellReuseIdentifier: "OfferTableViewCell")
        
        // init collectionView
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 10.0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 30.0, width: UIScreen.main.bounds.width, height: 170.0), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCollectionViewCell")
    }
    
    @objc func switchCellStyle() {
        if isBiggerStyle == true {
            isBiggerStyle = false
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        } else {
            isBiggerStyle = true
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
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
        
        UserDefaults.standard.set(exchangeRateResponse?.currency, forKey: "current_curr")
        
        self.presenter?.interactor?.getNewLots(params: ["page" : 1, "size": 10])
        self.presenter?.interactor?.getStartedLots(params: ["page" : 1, "size": 10])
    }
    
    func updateFoundLots(data: Data) {
        startedLots.removeAll()
        let lotsResponse = try? JSONDecoder().decode(LotsResponse.self, from: data)
        for dict in lotsResponse! {
            startedLots.append(dict)
        }
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func updateNewLots(data: Data) {
        newLots.removeAll()
        let lotsResponse = try? JSONDecoder().decode(LotsResponse.self, from: data)
        for dict in lotsResponse! {
            newLots.append(dict)
        }
        collectionView.reloadData()
    }
    
    func updateStartedLots(data: Data) {
        searchData.removeAll()
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let dictionary = json as? [[String: Any]] {
            searchData = dictionary
        }
        searchArray = searchData
        
        searchBarView.isUserInteractionEnabled = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func updateLotStatus(data: Data) {
        self.presenter?.interactor?.getNewLots(params: ["page" : 1, "size": 10])
        self.presenter?.interactor?.getStartedLots(params: ["page" : 1, "size": 10])
    }
}

extension NewAuctionsViewController: CollectionCellButtonDelegate {
    
    func collectionAddToFavourite(_ sender: UIButton) {
        currentIndex = sender.tag
        self.presenter?.interactor?.addLotToFavorite(lotID: String(currentIndex))
    }
    
    func collectionRemoveFromFavourite(_ sender: UIButton) {
        currentIndex = sender.tag
        self.presenter?.interactor?.removeLotToFavorite(lotID: String(currentIndex))
    }
}

extension NewAuctionsViewController: CellButtonDelegate {
    
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

extension NewAuctionsViewController: BiggerCellButtonDelegate {
    
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

extension NewAuctionsViewController: OfferCellButtonDelegate {
    
    func offerCellButton(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet() {
            let bidCarouselViewController = BidCarouselRouter.createModule()
            navigationController?.pushViewController(bidCarouselViewController, animated: true)
        }
    }
}

extension NewAuctionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            if !searchBarView.searchTextField.isEditing {
                if searchBarView.searchTextField.text!.isEmpty {
                    let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 236.0))
                    headerView.backgroundColor = UIColor.clear
                    headerView.isUserInteractionEnabled = true
                    let headerTitle = UILabel(frame: CGRect(x: 16.0, y: 6.0, width: 250.0, height: 22.0))
                    headerTitle.font = UIFont(name: "AvenirNextCondensed-Regular", size: 20.0)!
                    headerTitle.tintColor = Colours.placeholderTextColor
                    headerTitle.text = NSLocalizedString("The newest", comment: "")
                    headerView.addSubview(headerTitle)
                    headerView.addSubview(collectionView)
                    return headerView
                }
                return UIView()
            } else {
                return UIView()
            }
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            if !searchBarView.searchTextField.isEditing {
                if searchBarView.searchTextField.text!.isEmpty {
                    return 198.0
                }
                return 0.0
            } else {
                return 0.0
            }
        default:
            return 0.0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return searchData.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            if isBiggerStyle == true {
                return 189.0
            } else {
                return 152.0
            }
        default:
            if !searchBarView.searchTextField.isEditing {
                if searchBarView.searchTextField.text!.isEmpty {
                    return 198.0
                }
                return 0.0
            } else {
                return 0.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        biggerItemWithButtonCell = tableView.dequeueReusableCell(withIdentifier: "BiggerItemWithButtonCell") as! BiggerItemWithButtonCell
        biggerItemWithButtonCell.delegate = self
        biggerItemWithButtonCell.button.tag = indexPath.row
        
        itemWithButtonCell = tableView.dequeueReusableCell(withIdentifier: "ItemWithButtonCell") as! ItemWithButtonCell
        itemWithButtonCell.delegate = self
        itemWithButtonCell.button.tag = indexPath.row

        if searchData.count > 0 {
            itemWithButtonCell.starButton.tag = searchData[indexPath.row]["id"] as! Int
            itemWithButtonCell.title.text = searchData[indexPath.row]["name"] as? String
            
            let bets: Int = searchData[indexPath.row]["bets_count"] as! Int
            itemWithButtonCell.bets.text = NSLocalizedString("Bets ", comment: "") + "\(String(bets))"
            
            let priceString = searchData[indexPath.row]["start_price"] as? String ?? "0"
            let price = NumberFormatter().number(from: priceString)?.doubleValue ?? 0 * rate
            
            if UserDefaults.standard.string(forKey: "current_curr") == "USD" {
                itemWithButtonCell.price.text = NSLocalizedString("Price: ", comment: "") + "\(String(format: "%g", price)) $"
                biggerItemWithButtonCell.price.text = NSLocalizedString("Price: ", comment: "") + "\(String(format: "%g", price)) $"
            } else {
                itemWithButtonCell.price.text = NSLocalizedString("Price: ", comment: "") + "\(String(format: "%g", price)) €"
                biggerItemWithButtonCell.price.text = NSLocalizedString("Price: ", comment: "") + "\(String(format: "%g", price)) €"
            }
            
            biggerItemWithButtonCell.starButton.tag = searchData[indexPath.row]["id"] as! Int
            biggerItemWithButtonCell.title.text = searchData[indexPath.row]["name"] as? String
            biggerItemWithButtonCell.bets.text = NSLocalizedString("Bets ", comment: "") + "\(String(bets))"
            
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
        
        switch indexPath.section {
        case 1:
            if isBiggerStyle == true {
                return biggerItemWithButtonCell
            } else {
                return itemWithButtonCell
            }
        default:
            if !searchBarView.searchTextField.isEditing {
                if searchBarView.searchTextField.text!.isEmpty {
                    offerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell") as! OfferTableViewCell
                    offerTableViewCell.delegate = self
                    return offerTableViewCell
                }
                return UITableViewCell()
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(searchData[indexPath.row]["id"], forKey: "lotID")
        
        let itemPageViewController = ItemPageRouter.createModule()
        navigationController?.pushViewController(itemPageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200.0))
            return footerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 && searchBarView.searchTextField.isFirstResponder {
            return UIScreen.main.bounds.height/2 - 90.0
        } else {
            return 0.0
        }
    }
}

extension NewAuctionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if newLots.count > 0 {
            return newLots.count
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 152.0, height: 154.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        itemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath as IndexPath) as! ItemCollectionViewCell
        itemCollectionViewCell.delegate = self
        
        if newLots.count > 0 {
            itemCollectionViewCell.starButton.isHidden = false
            itemCollectionViewCell.stopBlink()
            
            if let nameAr = newLots[indexPath.row].nameAr {
                if !nameAr.isEmpty {
                    itemCollectionViewCell.itemTitle.text = nameAr
                }
            } else {
                itemCollectionViewCell.itemTitle.text = newLots[indexPath.row].name
            }
            
            itemCollectionViewCell.starButton.tag = newLots[indexPath.row].id
            
            if newLots[indexPath.row].isFavorite {
                itemCollectionViewCell.starButton.isSelected = true
            } else {
                itemCollectionViewCell.starButton.isSelected = false
            }
            
            if let imageUrl = newLots[indexPath.row].image1 {
                var resultUrl = URLs.baseUrl
                resultUrl.removeLast()
                resultUrl = resultUrl + imageUrl
                itemCollectionViewCell.itemImage.kf.setImage(with: URL(string: resultUrl))
            }
            
        } else {
            itemCollectionViewCell.starButton.isHidden = true
            itemCollectionViewCell.startBlink()
        }
        
        return itemCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(newLots[indexPath.row].id, forKey: "lotID")
        
        let itemPageViewController = ItemPageRouter.createModule()
        navigationController?.pushViewController(itemPageViewController, animated: true)
    }
}

extension NewAuctionsViewController: UITextFieldDelegate {
    
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
        tableView.frame = CGRect(x: 0.0, y: -12.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 144.0)
        
        searchBarView.searchButton.isSelected = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.reloadSections(NSIndexSet(indexesIn: NSMakeRange(0, self.tableView.numberOfSections)) as IndexSet, with: .none)
        if textField.text!.isEmpty {
            tableView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 144.0)
        } else {
            tableView.frame = CGRect(x: 0.0, y: -12.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 144.0)
        }
        
        searchBarView.searchButton.isSelected = false
        
        if textField.text!.isEmpty {
            self.presenter?.interactor?.getStartedLots(params: ["page" : 1, "size": 10])
        }
    }
}


extension UIView {
    
    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay: 0.0,
                       options: [.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
