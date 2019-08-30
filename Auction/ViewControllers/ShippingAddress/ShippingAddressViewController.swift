//
//  ShippingAddressViewController.swift
//  Auction
//
//  Created by Иван Меликов on 23/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class ShippingAddressViewController: UIViewController, ShippingAddressViewProtocol {

    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: ShippingAddressPresenterProtocol?

    var shippingCell = ShippingCell()
    var indicatorView = IndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ShippingCell", bundle: nil), forCellReuseIdentifier: "ShippingCell")
        
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
    }

    // MARK: -
    // MARK: - Method's
    
    @objc func sendAddress() {
        if shippingCell.firstNameTextField.text == "" {
            shippingCell.firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if shippingCell.lastNameTextField.text == "" {
            shippingCell.firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if shippingCell.streetAddressTextField.text == "" {
            shippingCell.streetAddressTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if shippingCell.cityTextField.text == "" {
            shippingCell.cityTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if shippingCell.selectStateTextField.text == "" {
            shippingCell.selectStateTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if shippingCell.zipCodeTextField.text == "" {
            shippingCell.zipCodeTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else if shippingCell.phoneNumberTextField.text == "" {
            shippingCell.phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "Required field",
                                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            return
        } else {
            indicatorView.showActivityIndicator()
            
            let shippingLotRequest = ShippingLotRequest.init(order: UserDefaults.standard.string(forKey: "lotID")!,
                                                             firstName: shippingCell.firstNameTextField.text ?? "",
                                                             lastName: shippingCell.lastNameTextField.text ?? "",
                                                             streetAddress: shippingCell.streetAddressTextField.text ?? "",
                                                             city: shippingCell.cityTextField.text ?? "",
                                                             state: shippingCell.selectStateTextField.text ?? "",
                                                             zipCode: shippingCell.zipCodeTextField.text ?? "",
                                                             phoneNumber: shippingCell.phoneNumberTextField.text ?? "")
            
            let dict = try! shippingLotRequest.toDictionary()
            self.presenter?.interactor?.getPaymentUrl(params: dict)
        }
            
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func backButtonGesture(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setPaymentUrl(data: Data) {
        indicatorView.hideActivityIndicator()
        
        let lotPaymentResponse = try? JSONDecoder().decode(ShippingLotResponse.self, from: data)
        
        let bidPaymentViewController = BidPaymentViewController()
        bidPaymentViewController.paymentUrl = lotPaymentResponse?.url ?? ""
        
        navigationController?.pushViewController(bidPaymentViewController, animated: true)
    }
}

extension ShippingAddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        shippingCell = tableView.dequeueReusableCell(withIdentifier: "ShippingCell") as! ShippingCell
        shippingCell.payPallButton.addTarget(self, action: #selector(sendAddress), for: .touchUpInside)
        
        return shippingCell
    }
}
