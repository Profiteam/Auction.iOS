//
//  ProfileViewController.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import YPImagePicker
import AVFoundation
import AVKit
import Photos

class ProfileViewController: UIViewController, ProfileViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var editButtonTopSpace: NSLayoutConstraint!
    @IBOutlet var largeTitlePosY: NSLayoutConstraint!
    
    var presenter: ProfilePresenterProtocol?

    var infoHeaderView = InfoHeaderView()
    var editButtonPathValue: CGFloat = 56.0
    var collectionView: UICollectionView!
    let collectionFooterView = UIView()
    var collectionViewImageArray = [String]()
    var collectionViewTitleArray = [String]()
    var indicatorView = IndicatorView()
    
    var avatarImage = UIImage()
    var avatarData: Data = Data()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter?.interactor?.getProfile()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAvatar), name: NSNotification.Name(rawValue: "avatarChanged"), object: nil)
        
        customTitle.adjustsFontSizeToFitWidth = true
        
        // IndicatorView
        indicatorView.addActivityIndicator()
        view.addSubview(indicatorView)
        
        // TableView
        tableView.register(UINib.init(nibName: "InfoHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "InfoHeaderView")
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        tableView.register(UINib(nibName: "EmptyCell", bundle: nil), forCellReuseIdentifier: "EmptyCell")
        
        // CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        
        collectionView = UICollectionView(frame: CGRect(x: 16.0, y: 21.0, width: UIScreen.main.bounds.width - 30.0, height: 647.0), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceHorizontal = false
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib.init(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        
        //Adding shadow to collectionView
        collectionView.layer.cornerRadius = 10.0
        collectionView.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        collectionView.layer.shadowColor = Colours.shadowColor
        collectionView.layer.shadowOpacity = 1.0
        collectionView.layer.shadowRadius = 10.0
        collectionView.layer.masksToBounds = false
        
        collectionViewImageArray = ["ic_profile_auctions",
                                    "ic_profile_buy_bids",
                                    "ic_profile_badges",
                                    "ic_profile_notifications",
                                    "ic_profile_unpaid_wins",
                                    "ic_profile_buyitnow_offers",
                                    "ic_profile_my_orders",
                                    "ic_profile_bidding_history",
                                    "ic_profile_help"]
        
        collectionViewTitleArray = [NSLocalizedString("Auctions", comment: ""),
                                    NSLocalizedString("Buy Bids", comment: ""),
                                    NSLocalizedString("Badges", comment: ""),
                                    NSLocalizedString("Notifications", comment: ""),
                                    NSLocalizedString("Unpaid Wins", comment: ""),
                                    NSLocalizedString("Buy it now Offers", comment: ""),
                                    NSLocalizedString("My Orders", comment: ""),
                                    NSLocalizedString("Bidding History", comment: ""),
                                    NSLocalizedString("Help", comment: "")]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:  //.iPhones_5_5s_5c_SE
            editButtonTopSpace.constant = 74.0
            largeTitlePosY.constant = 62.0
            editButtonPathValue = 54.0
            customTitle.font =  UIFont(name: "Exo2.0-Medium", size: 42.0)
        case 1334:  //.iPhones_6_6s_7_8
            editButtonTopSpace.constant = 74.0
            largeTitlePosY.constant = 62.0
            editButtonPathValue = 54.0
        case 1920, 2208:  //.iPhones_6Plus_6sPlus_7Plus_8Plus
            editButtonTopSpace.constant = 104.0
            largeTitlePosY.constant = 94.0
            editButtonPathValue = 64.0
        default:
            editButtonTopSpace.constant = 104.0
            largeTitlePosY.constant = 94.0
            editButtonPathValue = 64.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.topTableViewConstraint.constant = 0.0
                self.view.layoutSubviews()
            })
        
            UIView.animate(withDuration: 0.5, animations: {
                self.customTitle.alpha = 1.0
                self.editButton.alpha = 1.0
                self.tableView.alpha = 1.0
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, animations: {
                self.topTableViewConstraint.constant = 1000.0
                self.view.layoutSubviews()
            })
            
            UIView.animate(withDuration: 0.8, animations: {
                self.tableView.alpha = 0.0
                self.customTitle.alpha = 0.0
                self.editButton.alpha = 0.0
            })
        }
    }
    
    // MARK: -
    // MARK: - methods
    
    func sendProfileParams() {
        let updateProfileRequest = UpdateProfileRequest.init(username: infoHeaderView.nicknameTextField.text ?? "",
                                                            firstName: "",
                                                             lastName: "",
                                                          phoneNumber: infoHeaderView.phoneTextField.text ?? "",
                                                                email: infoHeaderView.emailTextField.text ?? "")
        
        let dict = try! updateProfileRequest.toDictionary()
    
        self.presenter?.interactor?.setProfile(photo: avatarImage.jpegData(compressionQuality: 0.9) ?? Data(), params: dict)
    }
    
    @objc func makePhotoAction() {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.avatarImage = photo.image
                self.infoHeaderView.avatarImage.image = self.avatarImage
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @objc func updateAvatar() {
        self.presenter?.interactor?.getProfile()
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            editButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
            
            infoHeaderView.setFocusTextField(isFocused: true)
            infoHeaderView.avatarImage.isUserInteractionEnabled = true
        } else {
            sender.tag = 0
            editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
            
            infoHeaderView.setFocusTextField(isFocused: false)
            infoHeaderView.avatarImage.isUserInteractionEnabled = true
            
            indicatorView.showActivityIndicator()
            
            sendProfileParams()
        }
    }
    
    // MARK: -
    // MARK: - Presenter Callback
    
    func setProfile(data: Data) {
        let profileResponse = try? JSONDecoder().decode(ProfileResponse.self, from: data)
        
        infoHeaderView.nicknameTextField.text = profileResponse?.username
        infoHeaderView.emailTextField.text = profileResponse?.email
        infoHeaderView.phoneTextField.text = profileResponse?.phoneNumber
        
        if let imageUrl = profileResponse?.avatar {
            var resultUrl = URLs.baseUrl
            resultUrl.removeLast()
            resultUrl = resultUrl + imageUrl
            infoHeaderView.avatarImage.kf.setImage(with: URL(string: resultUrl))
        }
        
        editButton.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
        
        indicatorView.hideActivityIndicator()
    }
}


extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -20.0 {
            let percent: CGFloat = (scrollView.contentOffset.y / -64)
            customTitle.alpha = percent
            editButton.alpha = percent
        } else {
            customTitle.alpha = 1.0
            editButton.alpha = 1.0
        }
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        infoHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "InfoHeaderView") as! InfoHeaderView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(makePhotoAction))
        infoHeaderView.avatarImage.addGestureRecognizer(tap)
        
        return infoHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 420.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 800.0))
        footerView.addSubview(collectionView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 800.0
    }
}


extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 72.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let profileCollectionViewCell: ProfileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath as IndexPath) as! ProfileCollectionViewCell
        profileCollectionViewCell.imageView.image = UIImage.init(named: collectionViewImageArray[indexPath.row])
        profileCollectionViewCell.titleLabel.text = collectionViewTitleArray[indexPath.row]
        
        if indexPath.row == 8 {
            profileCollectionViewCell.separatorView.isHidden = true
        }
        
        return profileCollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let bidCarouselViewController = BidCarouselRouter.createModule()
            navigationController?.pushViewController(bidCarouselViewController, animated: true)
        case 2:
            let badgesViewController = BadgesRouter.createModule()
            navigationController?.pushViewController(badgesViewController, animated: true)
        case 3:
            let notificationsViewController = NotificationsRouter.createModule()
            navigationController?.pushViewController(notificationsViewController, animated: true)
        case 4:
            let unpaidWinsViewController = UnpaidWinsRouter.createModule()
            navigationController?.pushViewController(unpaidWinsViewController, animated: true)
        case 5:
            let buyItNowOrdersViewControllers = BuyItNowOffersRouter.createModule()
            navigationController?.pushViewController(buyItNowOrdersViewControllers, animated: true)
        case 6:
            let myOrdersViewController = MyOrdersRouter.createModule()
            navigationController?.pushViewController(myOrdersViewController, animated: true)
        case 7:
            let biddingHistoryViewController = BiddingHistoryRouter.createModule()
            navigationController?.pushViewController(biddingHistoryViewController, animated: true)
        case 8:
            let helpViewController = HelpRouter.createModule()
            navigationController?.pushViewController(helpViewController, animated: true)
        default:
            break
        }
    }
}
