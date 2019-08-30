//
//  ItemPagePaymentViewController.swift
//  Auction
//
//  Created by Иван Меликов on 10/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit
import ImageSlideshow
import Kingfisher

class ItemPagePaymentViewController: UIViewController, ItemPagePaymentViewProtocol {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: ItemPagePaymentPresenterProtocol?
    
    var customBarView = CustomBottomBar()
    var textCell = TextCell()
    var imageSlideCell = ImageSlideCell()
    var totalCell = TotalCell()
    
    var nameString = String()
    var buyNowPriceString = String()
    var salesTaxString = String()
    var shippingString = String()
    var totalString = String()
    
    var image1String = String()
    var image2String = String()
    var image3String = String()
    var image4String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "TextCell")
        tableView.register(UINib(nibName: "ImageSlideCell", bundle: nil), forCellReuseIdentifier: "ImageSlideCell")
        tableView.register(UINib(nibName: "TotalCell", bundle: nil), forCellReuseIdentifier: "TotalCell")
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
        
        createBottomBar()
        
        self.presenter?.interactor?.getFullLot(lotId: UserDefaults.standard.string(forKey: "lotID")!)
    }
    
    // MARK: -
    // MARK: - Method's
    
    func createBottomBar() {
        customBarView.createOverlay()
   
        customBarView.middleButton.startColor = Colours.mainBlueColor
        customBarView.middleButton.endColor = Colours.mainBlueColor
        customBarView.middleButton.isUserInteractionEnabled = true
        customBarView.middleButton.setImage(UIImage(named: "ic_cart"), for: .normal)
        
        customBarView.middleButton.addTarget(self, action: #selector(cartButtonAction), for: .touchUpInside)
        view.addSubview(customBarView)
    }
    
    @objc func cartButtonAction() {
        let shippingAddressViewController = ShippingAddressRouter.createModule()
        navigationController?.pushViewController(shippingAddressViewController, animated: true)
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func backButtonGesture(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setFullLot(data: Data) {
        let fullLotResponse = try? JSONDecoder().decode(FullLotResponse.self, from: data)
        
        nameString = fullLotResponse?.name ?? ""
        buyNowPriceString = NSLocalizedString("Buy it now price: ", comment: "") + String(fullLotResponse?.price ?? 0) + NSLocalizedString(" bids", comment: "")
        salesTaxString = NSLocalizedString("Sales tax: ", comment: "")  + String(fullLotResponse?.salesTaxValue ?? 0) + NSLocalizedString(" bids", comment: "")
        if fullLotResponse?.shippingCost == 0 {
            shippingString = "Shipping: FREE"
        } else {
            shippingString = NSLocalizedString("Shipping: ", comment: "") + String(fullLotResponse?.shippingCost ?? 0) + NSLocalizedString(" bids", comment: "")
        }
        
        totalString = NSLocalizedString("Total: ", comment: "") + String(fullLotResponse?.total ?? 0) + NSLocalizedString(" bids", comment: "")
        
        image1String = fullLotResponse?.image1 ?? ""
        image2String = fullLotResponse?.image2 ?? ""
        image3String = fullLotResponse?.image3 ?? ""
        
        tableView.reloadData()
    }
}

extension ItemPagePaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 280.0
        case 2:
            return 170.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        textCell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
        imageSlideCell = tableView.dequeueReusableCell(withIdentifier: "ImageSlideCell") as! ImageSlideCell
        totalCell = tableView.dequeueReusableCell(withIdentifier: "TotalCell") as! TotalCell
        
        switch indexPath.section {
        case 1:
            imageSlideCell.nameLabel.text = nameString
            
            let baseUrl = URLs.baseUrl.dropLast()
            imageSlideCell.slideView.setImageInputs([
                KingfisherSource(urlString: baseUrl + (image1String))!,
                KingfisherSource(urlString: baseUrl + (image2String))!,
                KingfisherSource(urlString: baseUrl + (image1String))!,
                KingfisherSource(urlString: baseUrl + (image1String))!
            ])
            
            return imageSlideCell
        case 2:
            totalCell.butItNowPrice.text = buyNowPriceString
            totalCell.salesTax.text = salesTaxString
            totalCell.shipping.text = shippingString
            totalCell.total.text = totalString
            
            return totalCell
        default:
            return textCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 90.0))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 160.0
        } else {
            return 0.0
        }
    }
}
