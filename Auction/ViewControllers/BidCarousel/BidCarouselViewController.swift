//
//  BidCarouselViewController.swift
//  Auction
//
//  Created by Q on 11/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class BidCarouselViewController: UIViewController, BidCarouselViewProtocol {

    @IBOutlet var backButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: BidCarouselPresenterProtocol?
    
    var indicatorView = IndicatorView()
    var bidsArray = [BidData]()
    var bidCollectionViewCell = BidCollectionViewCell()
    var currentBidID = Int()
    
    var rate = Double()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        backButtonTopConstraint.constant = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height - 30.0
        
        if let locale = NSLocale.current.languageCode {
            if String(locale) == "ar" {
                let newImage = backButtonImage.image?.rotate(radians: .pi)
                backButtonImage.image = newImage
            }
        }
        
        indicatorView.showActivityIndicator()
        
        self.presenter?.interactor?.getCurrencyRate()
        self.presenter?.interactor?.getBids()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
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
        
        indicatorView.showActivityIndicator()
        
        self.presenter?.interactor?.getWallet()
    }
    
    func setWallet(data: Data) {
        indicatorView.hideActivityIndicator()
        
        let walletResponse = try? JSONDecoder().decode(WalletResponse.self, from: data)
        balanceLabel.text = String(walletResponse?.balance ?? 0) + NSLocalizedString(" bids", comment: "")
    }
    
    func setBids(data: Data) {
        indicatorView.hideActivityIndicator()
        
        bidsArray.removeAll()
        let bidsResponse = try? JSONDecoder().decode(BidsResponse.self, from: data)
        
        for dict in bidsResponse! {
            bidsArray.append(dict)
        }
        
        currentBidID = bidsArray[0].id ?? 1
        
        collectionView.reloadData()
    }
    
    func setBidPaymentUrl(data: Data) {
        let bidPaymentResponse = try? JSONDecoder().decode(BidPaymentResponse.self, from: data)
        
        let bidPaymentViewController = BidPaymentViewController()
        bidPaymentViewController.paymentUrl = bidPaymentResponse?.url ?? ""
        navigationController?.pushViewController(bidPaymentViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - methods
    
    func setupViews() {
        // IndicatorView
        
        indicatorView.addActivityIndicator()
        view.addSubview(indicatorView)
        
        collectionView.register(UINib.init(nibName: "BidCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BidCollectionViewCell")
        
        let layout = UPCarouselFlowLayout()
        switch UIScreen.main.nativeBounds.height {
        case 1136:  //.iPhones_5_5s_5c_SE
            layout.itemSize = CGSize(width:  collectionView.frame.height * 0.64, height: collectionView.frame.height * 0.8)
        default:
            layout.itemSize = CGSize(width:  collectionView.frame.height * 0.72, height: collectionView.frame.height)
        }
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 32.0)
        layout.sideItemScale = 0.81
        layout.sideItemAlpha = 1.0
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func payPallButtonAction(_ sender: UIButton) {
        self.presenter?.interactor?.getBidPaymentUrl(bidID: String(currentBidID))
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension BidCarouselViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        currentBidID = bidsArray[indexPath.row].id ?? 1
    }
}

extension BidCarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bidsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        bidCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BidCollectionViewCell", for: indexPath as IndexPath) as! BidCollectionViewCell
        
        if bidsArray.count > 0 {
            let priceString = bidsArray[indexPath.row].price ?? "0"
            let price = NumberFormatter().number(from: priceString)!.doubleValue * rate
            bidCollectionViewCell.priceLabel.text = String(format: "%g", price) + " $"
            
            if UserDefaults.standard.string(forKey: "current_curr") == "USD" {
                bidCollectionViewCell.priceLabel.text = String(format: "%g", price) + " $"
                
                if let retail = bidsArray[indexPath.row].costPerBet {
                    bidCollectionViewCell.retailLabel.text = String(format: "%g", retail * rate) + " $ " + NSLocalizedString("per bid", comment: "")
                }
            } else {
                bidCollectionViewCell.priceLabel.text = String(format: "%g", price) + " €"
                
                if let retail = bidsArray[indexPath.row].costPerBet {
                    bidCollectionViewCell.retailLabel.text = String(format: "%g", retail * rate) + " € " + NSLocalizedString("per bid", comment: "")
                }
            }
            
            if let betsCount = bidsArray[indexPath.row].betsCount {
                bidCollectionViewCell.bidsCount.text = String(betsCount) + "\n" + NSLocalizedString("bids", comment: "")
            }
        }
        
        return bidCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
