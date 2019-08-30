//
//  HomeViewController.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit
import Alamofire

protocol SearchTextFieldDelegate: AnyObject {
    func beginSearchByText(text: String)
    func switchItemCellStyle(_ sender: UIButton)
}

class HomeViewController: UIViewController, HomeViewProtocol, UIScrollViewDelegate {

    @IBOutlet weak var containerBarView: UIView!
    @IBOutlet weak var containerBarHeight: NSLayoutConstraint!
    @IBOutlet private weak var btnTab1: UIButton!
    @IBOutlet private weak var btnTab2: UIButton!
    @IBOutlet private weak var btnTab3: UIButton!
    @IBOutlet private weak var viewLine: UIView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var switchStyleButton: UIButton!
    @IBOutlet var searchTextField: UITextField!
    
    var presenter: HomePresenterProtocol?
    
    weak var searchTextFieldDelegate: SearchTextFieldDelegate?
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    
    var tab1VC = NewAuctionsRouter.createModule()
    var tab2VC = ClosedAuctionsRouter.createModule()
    var tab3VC = BookmarkedRouter.createModule()
    
    let newAuctionsViewController = NewAuctionsRouter.createModule()
    let closedAuctionsViewController = ClosedAuctionsRouter.createModule()
    let bookmarkedViewController = BookmarkedRouter.createModule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 0
        
        createPageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: -
    // MARK: - methods
    
    private func selectedButton(btn: UIButton) {
        btn.setTitleColor(Colours.placeholderTextColor, for: .normal)

        UIView.animate(withDuration: 0.3, animations: {
            self.viewLine.center.x = btn.center.x
            self.view.layoutSubviews()
        })
    }
    
    private func unSelectedButton(btn: UIButton) {
        btn.setTitleColor(UIColor.init(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.0), for: UIControl.State.normal)
    }
    
    func animateSearchButton(selected: Bool) {
        if selected {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchButton.center.x = self.switchStyleButton.center.x
                self.searchButton.isSelected = true
                self.switchStyleButton.alpha = 0.0
                
                self.view.layoutSubviews()
            })
            searchButton.tag = 1
            searchTextField.becomeFirstResponder()
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.searchButton.frame.origin.x = self.switchStyleButton.frame.origin.x - self.searchButton.frame.width - 18.0
                self.searchButton.isSelected = false
                self.switchStyleButton.alpha = 1.0
                
                self.view.layoutSubviews()
            })
            
            view.endEditing(true)
        }
    }
    
    // MARK: -
    // MARK: - IBActions
    
    @IBAction private func btnOptionClicked(btn: UIButton) {
        pageController.setViewControllers([arrVC[btn.tag]], direction: UIPageViewController.NavigationDirection.reverse, animated: false, completion: {(Bool) -> Void in
        })
    
        resetTabBarForTag(tag: btn.tag)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        animateSearchButton(selected: sender.isSelected)
    }
    
    // MARK: -
    // MARK: - CreatePagination
    
    private func createPageViewController() {
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
            svScroll.isScrollEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: self.containerBarView.frame.size.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - self.containerBarView.frame.size.height - 64.0)
        }

        tab1VC = newAuctionsViewController
        tab2VC = closedAuctionsViewController
        tab3VC = bookmarkedViewController

        arrVC = [tab1VC, tab2VC, tab3VC]
        
        pageController.setViewControllers([tab1VC], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        addChild(pageController)
        view.addSubview(pageController.view)
        view.layoutSubviews()
        pageController.didMove(toParent: self)
    }
    
    
    private func indexofviewController(viewCOntroller: UIViewController) -> Int {
        if arrVC .contains(viewCOntroller) {
            return arrVC.index(of: viewCOntroller)!
        }
        
        return -1
    }
    
    //MARK: -
    //MARK: - Set Top bar after selecting Option from Top Tabbar
    
    private func resetTabBarForTag(tag: Int) {
        
        var sender: UIButton!
        
        if tag == 0 {
            sender = btnTab1
        }
        else if tag == 1 {
            sender = btnTab2
        }
        else if tag == 2 {
            sender = btnTab3
        }
        
        currentPage = tag
        
        unSelectedButton(btn: btnTab1)
        unSelectedButton(btn: btnTab2)
        unSelectedButton(btn: btnTab3)
        
        selectedButton(btn: sender)
    }
}

extension HomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = indexofviewController(viewCOntroller: viewController)
        if index != -1 {
            index = index - 1
        }
        
        if index < 0 {
            return nil
        } else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexofviewController(viewCOntroller: viewController)
        if index != -1 {
            index = index + 1
        }
        
        if index >= arrVC.count {
            return nil
        } else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            currentPage = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            
            resetTabBarForTag(tag: currentPage)
        }
    }
}
