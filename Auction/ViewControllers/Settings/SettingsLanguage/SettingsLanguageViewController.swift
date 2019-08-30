//
//  SettingsLanguageViewController.swift
//  Auction
//
//  Created by Q on 25/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class SettingsLanguageViewController: UIViewController, SettingsLanguageViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var backButton: UIButton!
    
    var presenter: SettingsLanguagePresenterProtocol?
    
    var indicatorView = IndicatorView()
    var settingSelectionCell = SettingSelectionCell()
    var dataArray = [[String : Any]]()
    var languageData = [LanguageData]()
    var languageBundle : Bundle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingSelectionCell", bundle: nil), forCellReuseIdentifier: "SettingSelectionCell")
        tableView.tableFooterView = UIView()
        
        // IndicatorView
        
        indicatorView.addActivityIndicator()
        view.addSubview(indicatorView)
        indicatorView.showActivityIndicator()
        
        self.presenter?.interactor?.getLanguage()
    }
    
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

    // MARK: -
    // MARK: - Presenter Callback
    
    func setLanguage(data: Data) {
        languageData.removeAll()
        
        let languageResponse = try? JSONDecoder().decode(LanguageResponse.self, from: data)
        for dict in languageResponse! {
            languageData.append(dict)
        }
        
        indicatorView.hideActivityIndicator()
        
        tableView.reloadData()
    }
    
    func languageSelected() {
        indicatorView.hideActivityIndicator()
        
        let alert = UIAlertController(title: nil, message: NSLocalizedString("Please, restart the application for the changes to take effect", comment: ""), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: -
    // MARK: - Method's
 
    func changeLanguage(languageID: Int) {
        switch languageID {
        case 2:
            Bundle.changeLanguage(lang: "ar")
        default:
            Bundle.changeLanguage(lang: "en")
        }
        let languageRequest = LanguageRequest.init(languageID: languageID)
        let dict = try! languageRequest.toDictionary()
        
        self.presenter?.interactor?.setUserLanguage(params: dict)
    }

    // MARK -
    // MARK - IBAction's
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsLanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        settingSelectionCell = tableView.dequeueReusableCell(withIdentifier: "SettingSelectionCell") as! SettingSelectionCell
        
        if languageData.count > 0 {
            settingSelectionCell.label.text = languageData[indexPath.row].fullName
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

        indicatorView.showActivityIndicator()
        
        UserDefaults.standard.set(languageData[indexPath.row].id, forKey: "lang_id")
        changeLanguage(languageID: languageData[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let currentCell = tableView.cellForRow(at: indexPath) as? SettingSelectionCell {
            currentCell.label.textColor = Colours.placeholderTextColor
            settingSelectionCell.setSelected(false, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if UserDefaults.standard.object(forKey: "lang_id") == nil {
            if UserDefaults.standard.string(forKey: "current_lang") == "ENG" {
                if indexPath.row == 0 {
                    settingSelectionCell.label.textColor = .white
                    settingSelectionCell.setSelected(true, animated: false)
                } else {
                    settingSelectionCell.label.textColor = Colours.placeholderTextColor
                    settingSelectionCell.setSelected(false, animated: false)
                }
            }
        } else {
            if indexPath.row + 1 == UserDefaults.standard.integer(forKey: "lang_id") {
                settingSelectionCell.label.textColor = .white
                settingSelectionCell.setSelected(true, animated: false)
            } else {
                settingSelectionCell.label.textColor = Colours.placeholderTextColor
                settingSelectionCell.setSelected(false, animated: false)
            }
        }
    }
}


extension Bundle {
    private static var bundle: Bundle!
    
    public static func localizedBundle() -> Bundle! {
        if bundle == nil {
            let appLang = UserDefaults.standard.string(forKey: "app_lang") ?? "en"
            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
            bundle = Bundle(path: path!)
        }
        
        return bundle;
    }
    
    public static func changeLanguage(lang: String) {
        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}
