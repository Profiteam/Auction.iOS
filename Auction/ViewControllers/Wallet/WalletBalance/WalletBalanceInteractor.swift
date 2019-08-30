//
//  WalletBalanceInteractor.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class WalletBalanceInteractor: WalletBalanceInteractorInputProtocol {

    weak var presenter: WalletBalanceInteractorOutputProtocol?

    func getWallet() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.wallet, success: { (response) in
            
            if let data = response as? Data {
                let walletResponse = try? JSONDecoder().decode(WalletResponse.self, from: data)
                if walletResponse != nil {
                    self.presenter?.receiveWallet(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func getWalletHistory() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.wallet_history, success: { (response) in
            
            if let data = response as? Data {
                let purchaseResponse = try? JSONDecoder().decode(PurchaseResponse.self, from: data)
                if purchaseResponse != nil {
                    self.presenter?.receiveWalletHistory(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
