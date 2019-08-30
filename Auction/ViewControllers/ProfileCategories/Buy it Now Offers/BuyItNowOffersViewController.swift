//
//  BuyItNowOffersViewController.swift
//  Auction
//
//  Created by Q on 03/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BuyItNowOffersViewController: UIViewController, BuyItNowOffersViewProtocol {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: BuyItNowOffersPresenterProtocol?
    
    var buyItNowOffers = [LotData]()
    var currentIndex = Int()
    var indicatorView = IndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BiggerItemWithButtonCell", bundle: nil), forCellReuseIdentifier: "BiggerItemWithButtonCell")
        
        // IndicatorView
        
        indicatorView.addActivityIndicator()
        view.addSubview(indicatorView)
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
        
        indicatorView.showActivityIndicator()
        
        self.presenter?.interactor?.getBuyItNowOffers()
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func backButtonGesture(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setBuyItNowOffers(data: Data) {
        buyItNowOffers.removeAll()
        let lotsResponse = try? JSONDecoder().decode(LotsResponse.self, from: data)
        for dict in lotsResponse! {
            buyItNowOffers.append(dict)
        }
        
        if buyItNowOffers.isEmpty {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        
        tableView.reloadData()
        
        indicatorView.hideActivityIndicator()
    }
    
    func updateLotStatus(data: Data) {
        self.presenter?.interactor?.getBuyItNowOffers()
    }
}

extension BuyItNowOffersViewController: BiggerCellButtonDelegate {
    
    func biggerOpenItemPageViewController(_ sender: UIButton) {

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

extension BuyItNowOffersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buyItNowOffers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let biggerItemWithButtonCell = tableView.dequeueReusableCell(withIdentifier: "BiggerItemWithButtonCell") as! BiggerItemWithButtonCell
        biggerItemWithButtonCell.delegate = self
        
        if buyItNowOffers.count > 0 {
            biggerItemWithButtonCell.button.isHidden = true
            biggerItemWithButtonCell.starButton.tag = buyItNowOffers[indexPath.row].id
            biggerItemWithButtonCell.title.text = buyItNowOffers[indexPath.row].name
            biggerItemWithButtonCell.price.text = buyItNowOffers[indexPath.row].startPrice
            let bets: Int = buyItNowOffers[indexPath.row].betsCount
            biggerItemWithButtonCell.bets.text = "Bets \(String(bets))"
            
            if buyItNowOffers[indexPath.row].isFavorite {
                biggerItemWithButtonCell.starButton.isSelected = true
            } else {
                biggerItemWithButtonCell.starButton.isSelected = false
            }
            
            let resultUrl = URLs.baseUrl + (buyItNowOffers[indexPath.row].image1 ?? "")
            biggerItemWithButtonCell.itemImage.kf.setImage(with: URL(string: resultUrl))
        }
        
        return biggerItemWithButtonCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(buyItNowOffers[indexPath.row].id, forKey: "lotID")
        
        let itemPagePaymentViewController = ItemPagePaymentRouter.createModule()
        navigationController?.pushViewController(itemPagePaymentViewController, animated: true)
    }
}
