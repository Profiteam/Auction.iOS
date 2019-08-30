//
//  BidPaymentViewController.swift
//  Auction
//
//  Created by Q on 27/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit
import WebKit

class BidPaymentViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var backButtonImage: UIImageView!
    
    
    var paymentUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        loadPaymentPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        topConstraint.constant = (navigationController?.navigationBar.frame.height)!
        
        if let locale = NSLocale.current.languageCode {
            if String(locale) == "ar" {
                let newImage = backButtonImage.image?.rotate(radians: .pi)
                backButtonImage.image = newImage
            }
        }
    }
    
    // MARK: -
    // MARK: - IBAction's
    
    @IBAction func backButtonGesture(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: -
    // MARK: - Methods

    func loadPaymentPage() {
        let url = URL(string: paymentUrl)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}


extension BidPaymentViewController: WKUIDelegate, WKNavigationDelegate {
    

}
