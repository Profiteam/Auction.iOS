//
//  SettingsCurrencyViewController.swift
//  Auction
//
//  Created by Q on 25/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class SettingsCurrencyViewController: UIViewController, SettingsCurrencyViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var backButton: UIButton!
    
    var presenter: SettingsCurrencyPresenterProtocol?
    
    var indicatorView = IndicatorView()
    var settingSelectionCell = SettingSelectionCell()
    var dataArray = [[String : Any]]()
    var lastSelectedCell = IndexPath()
    var currencyData = [CurrencyData]()
    var rate = Double()

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationHeight.constant = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        
        if let locale = NSLocale.current.languageCode {
            if String(locale) == "ar" {
                let newImage = backButton.imageView?.image?.rotate(radians: .pi)
                backButton.imageView?.image = newImage
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let rowIndex = UserDefaults.standard.integer(forKey: "curr_id") - 1
        tableView.selectRow(at: IndexPath(row: rowIndex, section: 0), animated: false, scrollPosition: .none)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingSelectionCell", bundle: nil), forCellReuseIdentifier: "SettingSelectionCell")
        tableView.remembersLastFocusedIndexPath = true
        tableView.tableFooterView = UIView()
        
        indicatorView.addActivityIndicator()
        view.addSubview(indicatorView)
        indicatorView.showActivityIndicator()
        
        self.presenter?.interactor?.getCurrency()
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setCurrency(data: Data) {
        indicatorView.hideActivityIndicator()
        
        currencyData.removeAll()
        
        let currencyResposne = try? JSONDecoder().decode(CurrencyResposne.self, from: data)
        for dict in currencyResposne! {
            currencyData.append(dict)
        }
        
        tableView.reloadData()
    }
    
    func currencySelected() {
        self.presenter?.interactor?.getCurrencyRate()
    }
    
    func setCurrencyRate(data: Data) {
        let exchangeRateResponse = try? JSONDecoder().decode(ExchangeRateResponse.self, from: data)
        rate = exchangeRateResponse?.rate ?? 0
        if rate > 0 {
            UserDefaults.standard.set(rate, forKey: "rate")
        }
        
        indicatorView.hideActivityIndicator()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - Method's
    
    func changeCurrency(currencyID: Int) {        
        let currencyRequest = CurrencyRequest.init(currencyID: currencyID)
        let dict = try! currencyRequest.toDictionary()
        
        self.presenter?.interactor?.setUserCurrency(params: dict)
    }
    
    // MARK -
    // MARK - IBAction's
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        settingSelectionCell = tableView.dequeueReusableCell(withIdentifier: "SettingSelectionCell") as! SettingSelectionCell
        
        if currencyData.count > 0 {
            settingSelectionCell.label.text = currencyData[indexPath.row].fullName
            settingSelectionCell.label.textColor = Colours.placeholderTextColor
        }
        
        let grView = GRView(frame: settingSelectionCell.bounds)
        grView.startColor = UIColor(red: 0.17, green: 0.4, blue: 0.98, alpha: 1.0)
        grView.endColor = UIColor(red: 0.17, green: 0.4, blue: 0.98, alpha: 1.0)
        grView.horizontalMode = true
        settingSelectionCell.selectedBackgroundView = grView
        
        return settingSelectionCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentCell = tableView.cellForRow(at: indexPath) as? SettingSelectionCell {
            currentCell.label.textColor = .white
        }
        
        UserDefaults.standard.set(currencyData[indexPath.row].id, forKey: "curr_id")
        
        indicatorView.showActivityIndicator()
        
        changeCurrency(currencyID: currencyData[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let currentCell = tableView.cellForRow(at: indexPath) as? SettingSelectionCell {
            currentCell.label.textColor = Colours.placeholderTextColor
            settingSelectionCell.setSelected(false, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if UserDefaults.standard.object(forKey: "curr_id") == nil {
            if UserDefaults.standard.string(forKey: "current_curr") == "USD" {
                if indexPath.row == 0 {
                    settingSelectionCell.label.textColor = .white
                    settingSelectionCell.setSelected(true, animated: false)
                } else {
                    settingSelectionCell.label.textColor = Colours.placeholderTextColor
                    settingSelectionCell.setSelected(false, animated: false)
                }
            }
        } else {
            if indexPath.row + 1 == UserDefaults.standard.integer(forKey: "curr_id") {
                settingSelectionCell.label.textColor = .white
                settingSelectionCell.setSelected(true, animated: false)
            } else {
                settingSelectionCell.label.textColor = Colours.placeholderTextColor
                settingSelectionCell.setSelected(false, animated: false)
            }
        }
    }
}
