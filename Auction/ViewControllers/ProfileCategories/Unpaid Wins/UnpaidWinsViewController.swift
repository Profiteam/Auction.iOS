//
//  UnpaidWinsViewController.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class UnpaidWinsViewController: UIViewController, UnpaidWinsViewProtocol {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: UnpaidWinsPresenterProtocol?
    
    var unpaidWins = [LotData]()
    var currentIndex = Int()
    var indicatorView = IndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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
        
        self.presenter?.interactor?.getUnpaidWins()
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func backButtonGesture(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setUnpaidWins(data: Data) {
        unpaidWins.removeAll()
        let lotsResponse = try? JSONDecoder().decode(LotsResponse.self, from: data)
        for dict in lotsResponse! {
            unpaidWins.append(dict)
        }
        
        if unpaidWins.isEmpty {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        
        tableView.reloadData()
        
        indicatorView.hideActivityIndicator()
    }
    
    func showError() {
        indicatorView.hideActivityIndicator()
        tableView.isHidden = true
    }
    
    func updateLotStatus(data: Data) {
        self.presenter?.interactor?.getUnpaidWins()
    }
}

extension UnpaidWinsViewController: BiggerCellButtonDelegate {
    
    func biggerOpenItemPageViewController(_ sender: UIButton) {
        
//        UserDefaults.standard.set(unpaidWins[sender.tag].id, forKey: "lotID")
//
//        let itemPageViewController = ItemPageRouter.createModule()
//        navigationController?.pushViewController(itemPageViewController, animated: true)
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

extension UnpaidWinsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unpaidWins.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 189.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let biggerItemWithButtonCell = tableView.dequeueReusableCell(withIdentifier: "BiggerItemWithButtonCell") as! BiggerItemWithButtonCell
        biggerItemWithButtonCell.starButton.tag = unpaidWins[indexPath.row].id
        
        if unpaidWins.count > 0 {
            biggerItemWithButtonCell.button.isHidden = true
            biggerItemWithButtonCell.starButton.tag = unpaidWins[indexPath.row].id
            biggerItemWithButtonCell.title.text = unpaidWins[indexPath.row].name
            biggerItemWithButtonCell.price.text = unpaidWins[indexPath.row].startPrice
            let bets: Int = unpaidWins[indexPath.row].betsCount
            biggerItemWithButtonCell.bets.text = "Bets \(String(bets))"
            
            if unpaidWins[indexPath.row].isFavorite {
                biggerItemWithButtonCell.starButton.isSelected = true
            } else {
                biggerItemWithButtonCell.starButton.isSelected = false
            }
            
            let resultUrl = URLs.baseUrl + (unpaidWins[indexPath.row].image1 ?? "")
            biggerItemWithButtonCell.itemImage.kf.setImage(with: URL(string: resultUrl))
        }
        
        return biggerItemWithButtonCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(unpaidWins[indexPath.row].id, forKey: "lotID")
        
        let itemPagePaymentViewController = ItemPagePaymentRouter.createModule()
        navigationController?.pushViewController(itemPagePaymentViewController, animated: true)
    }
}
