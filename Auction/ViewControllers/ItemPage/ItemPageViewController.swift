//
//  ItemPageViewController.swift
//  Auction
//
//  Created by Q on 19/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import CountdownLabel
import ImageSlideshow
import Kingfisher

class ItemPageViewController: UIViewController, ItemPageViewProtocol, CustomBottomBarProtocol {

    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: ItemPagePresenterProtocol?
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var customBarView = CustomBottomBar()
    var modalView = CustomModalView()
    var itemHeaderView = ItemHeaderView()
    var descriptionCell = DescriptionCell()
    var notificationCell = NotificationCell()
    var betCell = BetCell()
    var buyItNowCell = BuyItNowCell()
    var userDidBet: Bool = false
    var bets = [BetsData]()
    var desriptionText = String()
    var buyItNowPrice = String()
    var winTime = String()
    
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
        
        self.presenter?.interactor?.getStartedLot(lotId: UserDefaults.standard.string(forKey: "lotID")!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveSocketMessage(notification:)), name: NSNotification.Name(rawValue: "income_bet"), object: nil)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "ItemHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ItemHeaderView")
        tableView.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.register(UINib(nibName: "BetCell", bundle: nil), forCellReuseIdentifier: "BetCell")
        tableView.register(UINib(nibName: "BuyItNowCell", bundle: nil), forCellReuseIdentifier: "BuyItNowCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        modalView.removeFromSuperview()
        customBarView.removeFromSuperview()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setStartedLot(data: Data) {
        let startedLotResponse = try? JSONDecoder().decode(StartedLotResponse.self, from: data)
        desriptionText = startedLotResponse?.descriptions ?? ""
        buyItNowPrice = startedLotResponse?.buyNowPrice ?? ""
        
        /* TO-DO WINNER TIME
         
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var dateString = dateFormatter.date(from: startedLotResponse?.winTimer ?? "00:00:00")
        print(dateString)
         
        */
        
        tableView.reloadData()
        
        itemHeaderView.timerLabel.delegate = self
        itemHeaderView.nameLabel.text = startedLotResponse?.name
        itemHeaderView.priceLabel.text = NSLocalizedString("Start price: ", comment: "") + (startedLotResponse?.startPrice ?? "") + NSLocalizedString(" bids", comment: "")
        
        let baseUrl = URLs.baseUrl.dropLast()
        itemHeaderView.slideShowView.setImageInputs([
            KingfisherSource(urlString: baseUrl + (startedLotResponse?.image1 ?? ""))!,
            KingfisherSource(urlString: baseUrl + (startedLotResponse?.image2 ?? ""))!,
            KingfisherSource(urlString: baseUrl + (startedLotResponse?.image3 ?? ""))!,
            KingfisherSource(urlString: baseUrl + (startedLotResponse?.image4 ?? ""))!
        ])
        
        let pageIndicator = UIPageControl()
        pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
        pageIndicator.pageIndicatorTintColor = UIColor.black
        itemHeaderView.slideShowView.pageIndicator = pageIndicator
        
        // Header Timer
        
        switch startedLotResponse?.status {
        case 1:
            // New
            let trimmedIsoString = startedLotResponse!.startDate?.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
            let formatter = ISO8601DateFormatter()
            let date = formatter.date(from: trimmedIsoString ?? "")
            let countdownTime: TimeInterval = TimeInterval(date!.offsetFrom(date: Date()))
            
            itemHeaderView.timerLabel.setCountDownTime(minutes: countdownTime)
            itemHeaderView.timerLabel.start()
        case 2:
            // Started
            if !itemHeaderView.timerLabel.isCounting {
                itemHeaderView.timerLabel.text = "Started"
                customBarView.changeButtonStyle(style: 0)
            }
            
            let idString: Int = startedLotResponse?.id ?? 0
            appDelegate.connectSocket(token: UserDefaults.standard.string(forKey: "token")!, lotID: String(idString))
            
            self.presenter?.interactor?.getBets(lotId: String(idString))
            
            if bets.count == 0 {
                if let closedDate = startedLotResponse?.closeDate {
                    reloadTimer(time: getTimeDifferense(timeString: closedDate, addingTime: 0))
                }
            }
        default:
            buyItNowPrice = ""
            itemHeaderView.timerLabel.text = "Closed"
        }
    }
    
    func setBets(data: Data) {
        bets.removeAll()
        let betResponse = try? JSONDecoder().decode(BetsResponse.self, from: data)
        for dict in betResponse!.data {
            bets.append(dict)
        }

        let timeString = bets.first?.date
        reloadTimer(time: getTimeDifferense(timeString: timeString ?? "", addingTime: 20))
        
        if bets.first?.userID == UserDefaults.standard.string(forKey: "user_id") {
            customBarView.animateTimer(timerDuration: getTimeDifferense(timeString: timeString ?? "", addingTime: 20))
            customBarView.middleButton.isUserInteractionEnabled = false
        } else {
            customBarView.changeButtonStyle(style: 0)
            customBarView.middleButton.isUserInteractionEnabled = true
        }
        
        tableView.reloadSections(IndexSet(integersIn: 2...2), with: .automatic)
    }
    
    // MARK: -
    // MARK: - methods
    
    func createBottomBar() {
        customBarView.createOverlay()
        customBarView.delegate = self
        customBarView.countdownLabel.delegate = self
        view.addSubview(customBarView)
    }
    
    func reloadTimer(time: TimeInterval) {
        itemHeaderView.timerLabel.setCountDownTime(minutes: time)
        itemHeaderView.timerLabel.start()
    }
    
    func getTimeDifferense(timeString: String, addingTime: Int) -> TimeInterval {
        let trimmedIsoString = timeString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
        let date = ISO8601DateFormatter().date(from: trimmedIsoString)
        let calendar = Calendar.current
        
        if date != nil {
            let time = calendar.date(byAdding: .second, value: addingTime, to: date!)
            let countdownTime: TimeInterval = TimeInterval(time!.offsetFrom(date: Date()))
            
            return countdownTime
        }
        
        return TimeInterval()
    }
    
    func stringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK: -
    // MARK: - WEB SOCKET RESPONSE
    
    @objc func receiveSocketMessage(notification: NSNotification) {
        let notificationString: String = notification.userInfo?["message"] as! String
        let betSocketResponse = try? JSONDecoder().decode(BetSocketResponse.self, from: notificationString.data(using: .utf8)!)
        
        // Bet Time Countdown
        
        if betSocketResponse?.data != nil {
            let timeString = (betSocketResponse?.data!.date!)!
            let trimmedIsoString = timeString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
            let date = ISO8601DateFormatter().date(from: trimmedIsoString)
            let calendar = Calendar.current
            let time = calendar.date(byAdding: .second, value: 20, to: date!)
            let countdownTime: TimeInterval = TimeInterval(time!.offsetFrom(date: Date()))
            reloadTimer(time: countdownTime)
            
            self.presenter?.interactor?.getBets(lotId: (betSocketResponse?.data?.lotID)!)
        }
        
        // Check the winner
        
        let winStatus = stringToDictionary(text: notificationString)
        let dict: [String : Any] = winStatus?["data"] as? [String : Any] ?? [:]
        for (key, value) in dict {
            if key == "win_user" {
                let winUser = value
                if String(describing: winUser) == UserDefaults.standard.string(forKey: "user_id") {
                    // Win auction
                    modalView = .init(frame: UIScreen.main.bounds)
                    modalView.button.addTarget(self, action: #selector(modalViewButtonAction), for:.touchUpInside)
                    view.addSubview(modalView)
                
                    modalView.animate()
                } else {
                    // Auction is closed
                    modalView = .init(frame: UIScreen.main.bounds)
                    modalView.button.addTarget(self, action: #selector(modalViewButtonAction), for:.touchUpInside)
                    modalView.closedModalView()
                    view.addSubview(modalView)
                    
                    modalView.prepare()
                    modalView.animate()
                }
            }
        }
    
        // Bet Error
        
        if betSocketResponse?.error != nil{
            if betSocketResponse?.error == "lot is closed" {
                modalView = .init(frame: UIScreen.main.bounds)
                modalView.closedModalView()
                view.addSubview(modalView)
                
                modalView.prepare()
                modalView.animate()
            } else {
                let alertController = UIAlertController(title: betSocketResponse?.error, message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
            customBarView.countdownLabel.cancel()
        }
    }
    
    @objc func modalViewButtonAction() {
        modalView.removeFromSuperview()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - CustomBottomBarProtocol
    
    func middleButtonDidTouch(sender: UIButton) {
        let dict: [String : Any] = ["type" : "bet"]
        let jsonData = try! JSONSerialization.data(withJSONObject: dict)
        let jsonString = String(data: jsonData, encoding: .utf8)
        
        if appDelegate.socket.isConnected {
            appDelegate.socket.write(string: jsonString!)
            userDidBet = true
        }
    }
}

extension ItemPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    // tableView Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            itemHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ItemHeaderView") as! ItemHeaderView
            itemHeaderView.timerLabel.countdownDelegate = self
            return itemHeaderView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300.0
        } else {
            return 0.0
        }
    }
    
    // tableView Footer
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90.0))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 12.0
        case 2:
            return 12.0
        case 3:
            return 120.0
        default:
            return 0.0
        }
    }
    
    // tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 2:
            if bets.count > 0 {
                return bets.count
            } else  {
                return 1
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            if !buyItNowPrice.isEmpty {
                return UITableView.automaticDimension
            } else {
                return 0.0
            }
        case 2:
            if bets.count > 0 {
                return 134.0
            } else  {
                if buyItNowPrice.isEmpty {
                    return 0.0
                } else {
                    return 94.0
                }
            }
        case 3:
            return UITableView.automaticDimension
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        descriptionCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
        notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        betCell = tableView.dequeueReusableCell(withIdentifier: "BetCell") as! BetCell
        buyItNowCell = tableView.dequeueReusableCell(withIdentifier: "BuyItNowCell") as! BuyItNowCell
        
        switch indexPath.section {
        case 1:
            if !buyItNowPrice.isEmpty {
                buyItNowCell.buyItNowLabel.text = NSLocalizedString("Buy it now for ", comment: "") + buyItNowPrice + " $"
                
                return buyItNowCell
            } else {
                return UITableViewCell()
            }
        case 2:
            if bets.count > 0 {
                let nameString = bets[indexPath.row].username
                if let range = nameString?.range(of: "#") {
                    betCell.nickname.text = String((nameString![nameString!.startIndex..<range.lowerBound]))
                }
                
                let dateString: String = bets[indexPath.row].date ?? ""
                if let index = (dateString.range(of: "T")?.upperBound) {
                    let timeString = String(dateString.suffix(from: index))
                    if let range = timeString.range(of: ".") {
                        betCell.time.text = String(timeString[timeString.startIndex..<range.lowerBound])
                    }
                }
                
                betCell.nickname.text = "@" + (bets[indexPath.row].username ?? "")
                betCell.betsCount.text = NSLocalizedString("Bets: ", comment: "") + String(bets[indexPath.row].value ?? 0)
                betCell.bet.text = String(bets[indexPath.row].value ?? 0) + NSLocalizedString(" bids", comment: "")
                
                if let imageUrl = bets[indexPath.row].avatar {
                    var resultUrl = URLs.baseUrl
                    resultUrl.removeLast()
                    resultUrl = resultUrl + imageUrl
                    betCell.avatar.kf.setImage(with: URL(string: resultUrl))
                } else {
                    betCell.avatar.image = UIImage()
                }
                
                return betCell
            } else  {
                if buyItNowPrice.isEmpty {
                    return UITableViewCell()
                } else {
                    return notificationCell
                }
            } 
        case 3:
            if !desriptionText.isEmpty {
                descriptionCell.descriptionLabel?.text = desriptionText
                
                return descriptionCell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let itemPagePaymentViewController = ItemPagePaymentRouter.createModule()
            navigationController?.pushViewController(itemPagePaymentViewController, animated: true)
        default:
            break
        }
    }
}

extension ItemPageViewController: CountdownLabelDelegate, LTMorphingLabelDelegate {
    func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
        switch timeRemaining {
        case 0:
            modalView.prepare()
        case 60:
            customBarView.countdownLabel.timeFormat = "ss"
            customBarView.countdownLabel.font = UIFont.systemFont(ofSize: 32.0, weight: .medium)
        default:
            break
        }
    }
    
}


extension Date {
    func offsetFrom(date : Date) -> Int {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = difference.second ?? 0
        if let second = difference.second, second > 0 {
            return seconds
        }
        return 0
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
