//
//  BadgesViewController.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BadgesViewController: UIViewController, BadgesViewProtocol {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var navigationHeight: NSLayoutConstraint!
    @IBOutlet var backButtonImage: UIImageView!
    
    var presenter: BadgesPresenterProtocol?
    
    var modalView = CustomModalView()
    var badges = [BadgeData]()
    var indicatorView = IndicatorView()

    let badgesArray = [1 : "New Best Friend", 2 : "Worth a Thousand Words", 3 : "Buy it Now'",
                       4 : "On The Go", 5 : "The Explorer", 6 : "Big Ticket Bidder", 7 : "Bidding Power",
                       8 : "The Techie", 9 : "Beauty and the Bids", 10 : "Game On", 11 : "Home Sweet Home", 12 : "The Chef",
                       13 : "The Champion", 14 : "Another Day, Another Auction", 15 : "Runner Up",
                       16 : "Endurance Race", 17 : "In It to Win It", 18 : "Going the Distance", 19 : "Me and My Buddies",
                       20 : "DealDash Loyal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
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
        
        self.presenter?.interactor?.getBadges()
    }
    
    // MARK: -
    // MARK: - method's
    
    func setupViews() {
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib.init(nibName: "BadgeCell", bundle: nil), forCellWithReuseIdentifier: "BadgeCell")
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func backButtonGesture(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setBadges(data: Data) {
        let badgeResponse = try? JSONDecoder().decode(BadgeResponse.self, from: data)
        
        for dict in badgeResponse! {
            badges.append(dict)
        }
        
        collectionView.reloadData()
        
        indicatorView.hideActivityIndicator()
    }
}

extension BadgesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badgesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3 + 12.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let badgeCell: BadgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath as IndexPath) as! BadgeCell
        badgeCell.titleLabel.text = badgesArray[indexPath.row + 1]
        badgeCell.badgeImage.image = UIImage.init(named: String(indexPath.row + 1))
        badgeCell.badgeImage.tintColor = .lightGray
        badgeCell.badgeImage.alpha = 0.3
        badgeCell.sizeToFit()
        
        if badges.count > 0 {
            if indexPath.row < badges.count {
                for key in badgesArray.keys {
                    if key == badges[indexPath.row].badgeNumber - 1 {
                        badgeCell.badgeImage.alpha = 1.0
                    }
                }
            }
        }
        
        return badgeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        modalView = .init(frame: UIScreen.main.bounds)
    
        let currentCell = collectionView.cellForItem(at: indexPath) as! BadgeCell
        
        if let locale = NSLocale.current.languageCode {
            if String(locale) == "ar" {
                modalView.badgeModalView(badgeName: currentCell.titleLabel.text ?? "",
                                         badgeImage: currentCell.badgeImage.image ?? UIImage(),
                                         description: "كل فقد وقبل سقطت وتنصيب. قد جيما العدّ المشتّتون مكن, وتزويده الجديدة، دون قد. كلّ أن التي التنازلي. تم أراض الساحل نفس, شاسعة الإنزال والروسية هذا ما.")
                
                
                UIApplication.shared.keyWindow!.addSubview(modalView)
                
                modalView.prepare()
                modalView.animate()
            } else {
                modalView.badgeModalView(badgeName: currentCell.titleLabel.text ?? "",
                                         badgeImage: currentCell.badgeImage.image ?? UIImage(),
                                         description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat")
                
                UIApplication.shared.keyWindow!.addSubview(modalView)
                
                modalView.prepare()
                modalView.animate()
            }
        }
    }
}
