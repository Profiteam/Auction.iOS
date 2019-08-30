//
//  WalletViewController.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController, WalletViewProtocol, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {

    var presenter: WalletPresenterProtocol?
    
    @IBOutlet var pageIndicator: UIPageControl!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var containerBarView: UIView!
    @IBOutlet weak var topContainerConstraint: NSLayoutConstraint!
    @IBOutlet var pagePosY: NSLayoutConstraint!
    @IBOutlet var largeTitlePosY: NSLayoutConstraint!
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    
    var tab1VC = WalletBalanceRouter.createModule()
    var tab2VC = WalletCardRouter.createModule()
    
    let defaults = UserDefaults.standard
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 0
        
        createPageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:  //.iPhones_5_5s_5c_SE
            largeTitlePosY.constant = 62.0
            customTitle.font =  UIFont(name: "Exo2.0-Medium", size: 42.0)
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
                self.view.layoutSubviews()
            })
            
            UIView.animate(withDuration: 0.5, animations: {
                self.customTitle.alpha = 1.0
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.customTitle.alpha = 0.0
    }
    
    //MARK: - CreatePagination
    private func createPageViewController() {
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = self.containerBarView.frame
        }
        
        let walletBalanceRouter = WalletBalanceRouter.createModule()
        let walletCardRouter = WalletCardRouter.createModule()
        
        tab1VC = walletBalanceRouter
        tab2VC = walletCardRouter
        
        arrVC = [tab1VC, tab2VC]
        pageController.setViewControllers([tab1VC], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        addChild(pageController)
        view.addSubview(pageController.view)
        view.layoutSubviews()
        pageController.didMove(toParent: self)
    }
    
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if(arrVC .contains(viewCOntroller)) {
            return arrVC.index(of: viewCOntroller)!
        }
        
        return -1
    }
    
    //MARK: - Pagination Delegate Methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewCOntroller: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if (completed) {
            currentPage = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            
            if (pageIndicator.currentPage == 1) {
                pageIndicator.page = 0
            } else {
                pageIndicator.page = 1
            }
            
            //defaults.set(true, forKey: "viewScrolled")
        }
    }
}
    //MARK: - Set Top bar after selecting Option from Top Tabbar
//    private func resetTabBarForTag(tag: Int) {
//
//        var sender: UIButton!
//
//        if(tag == 0) {
//            sender = btnTab1
//        }
//        else if(tag == 1) {
//            sender = btnTab2
//        }
//
//        currentPage = tag
//
//        unSelectedButton(btn: btnTab1)
//        unSelectedButton(btn: btnTab2)
//
//        selectedButton(btn: sender)
//    }
    
    //MARK: - UIScrollView Delegate Methods
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (currentPage == 0) {
//            viewLine.center.x = btnTab1.center.x
//        } else {
//            viewLine.center.x = btnTab2.center.x
//        }
//    }
