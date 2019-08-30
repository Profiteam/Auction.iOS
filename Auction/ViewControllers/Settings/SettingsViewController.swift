//
//  SettingsViewController.swift
//  Auction
//
//  Created by Q on 24/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet var largeTitlePosY: NSLayoutConstraint!
    
    var presenter: SettingsPresenterProtocol?
    
    var settingsCategoryCell = SettingsCategoryCell()
    var modalView = CustomModalView()
    var dataArray = [String : Any]()
    var languageString = String()
    var currencyString = String()
    var notifyValue = Bool()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsCategoryCell", bundle: nil), forCellReuseIdentifier: "SettingsCategoryCell")
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    
        self.presenter?.interactor?.getUserSettings()
    }
    
    override func viewWillLayoutSubviews() {
        switch UIScreen.main.nativeBounds.height {
        case 1136:  //.iPhones_5_5s_5c_SE
            largeTitlePosY.constant = 62.0
            customTitle.font =  UIFont(name: "AvenirNextCondensed-Regular", size: 42.0)!
        case 1334:  //.iPhones_6_6s_7_8
            largeTitlePosY.constant = 62.0
        case 1920, 2208:  //.iPhones_6Plus_6sPlus_7Plus_8Plus
            largeTitlePosY.constant = 94.0
        default:
            largeTitlePosY.constant = 94.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.topTableViewConstraint.constant = 0.0
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.5, animations: {
                self.customTitle.alpha = 1.0
                self.tableView.alpha = 1.0
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        modalView.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        customTitle.alpha = 0.0
        tableView.alpha = 0.0
        topTableViewConstraint.constant = 1000.0
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setUserSettings(data: Data) {
        let settingsResponse = try? JSONDecoder().decode(SettingsResponse.self, from: data)
        languageString = settingsResponse?.language ?? ""
        currencyString = settingsResponse?.currency ?? ""
        notifyValue = settingsResponse?.notify ?? false
        
        tableView.reloadData()
        
        settingsCategoryCell.notificationSwitch.setOn(notifyValue, animated: false)
    }
    
    func notifyChanged() {
        if settingsCategoryCell.notificationSwitch.isOn {
            settingsCategoryCell.notificationSwitch.setOn(true, animated: false)
        } else {
            settingsCategoryCell.notificationSwitch.setOn(false, animated: false)
        }
    }
    
    // MARK: -
    // MARK: - Methods
    
    func setupViews() {
        let navigationBarHeight: CGFloat = UIScreen.main.bounds.height/2.47037037
        let backgroundImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navigationBarHeight))
        backgroundImage.image = UIImage.init(named: "img_settings_bg")
        view.addSubview(backgroundImage)
        view.bringSubviewToFront(customTitle)
        tableView.layer.zPosition = 1000
    }
    
    @objc func logOut() {
        UserDefaults.standard.removeObject(forKey: "token")
        
        let authorizationViewController = AuthorizationRouter.createModule()
        navigationController?.pushViewController(authorizationViewController, animated: true)
    }
    
    @objc func switchValueDidChange() {
        if settingsCategoryCell.notificationSwitch.isOn {
            let notifyRequest = NotifyRequest.init(notify: 1)
            let dict = try! notifyRequest.toDictionary()
            self.presenter?.interactor?.updateNotify(params: dict)
        } else {
            let notifyRequest = NotifyRequest.init(notify: 0)
            let dict = try! notifyRequest.toDictionary()
            self.presenter?.interactor?.updateNotify(params: dict)
        }
    }
    
    @objc func languageButtonAction(_ sender: UITapGestureRecognizer) {
        let settingsLanguageViewController = SettingsLanguageRouter.createModule()
        navigationController?.pushViewController(settingsLanguageViewController, animated: true)
    }
    
    @objc func currencyButtonAction(_ sender: UITapGestureRecognizer) {
        let settingsCurrencyViewController = SettingsCurrencyRouter.createModule()
        navigationController?.pushViewController(settingsCurrencyViewController, animated: true)
    }
    
    @objc func logoutButtonAction(_ sender: UITapGestureRecognizer) {
        modalView = .init(frame: UIScreen.main.bounds)
        modalView.exitModalView()
        modalView.secondButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)

        UIApplication.shared.keyWindow!.addSubview(modalView)
        
        modalView.prepare()
        modalView.animate()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 52.0))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if UIScreen.main.nativeBounds.height == 1136 {
                return 126.0
            } else {
                return 160.0
            }
        }
        return 0.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 296.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        settingsCategoryCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCategoryCell") as! SettingsCategoryCell
        settingsCategoryCell.notificationSwitch.setOn(notifyValue, animated: false)
        settingsCategoryCell.languageLabel.text = languageString
        UserDefaults.standard.set(languageString, forKey: "current_lang")
        settingsCategoryCell.currencyLabel.text = currencyString
        UserDefaults.standard.set(currencyString, forKey: "current_curr")
        
        settingsCategoryCell.languageButton.addTarget(self,action:#selector(self.languageButtonAction(_:)), for:.touchUpInside)
        settingsCategoryCell.currencyButton.addTarget(self,action:#selector(self.currencyButtonAction(_:)), for:.touchUpInside)
        settingsCategoryCell.logoutButton.addTarget(self,action:#selector(self.logoutButtonAction(_:)), for:.touchUpInside)
        settingsCategoryCell.notificationSwitch.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
        
        return settingsCategoryCell
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -20.0 {
            let percent: CGFloat = (scrollView.contentOffset.y / -64)
            customTitle.alpha = percent
        } else {
            customTitle.alpha = 1.0
        }
    }
}
