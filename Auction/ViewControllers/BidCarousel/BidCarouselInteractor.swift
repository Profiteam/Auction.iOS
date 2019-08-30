//
//  BidCarouselInteractor.swift
//  Auction
//
//  Created by Q on 11/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

class BidCarouselInteractor: BidCarouselInteractorInputProtocol {

    weak var presenter: BidCarouselInteractorOutputProtocol?

    func getCurrencyRate() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.exchange_rate, success: { (response) in
            
            if let data = response as? Data {
                let exchangeRateResponse = try? JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                if exchangeRateResponse != nil {
                    self.presenter?.receiveCurrencyRate(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
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
    
    func getBids() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.bid_get, success: { (response) in
            
            if let data = response as? Data {
                let bidsResponse = try? JSONDecoder().decode(BidsResponse.self, from: data)
                if bidsResponse != nil {
                    self.presenter?.receiveBids(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func getBidPaymentUrl(bidID: String) {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.bid_buy + bidID + "/", success: { (response) in
            
            if let data = response as? Data {
                let bidPaymentResponse = try? JSONDecoder().decode(BidPaymentResponse.self, from: data)
                if bidPaymentResponse?.status == true {
                    self.presenter?.receiveBidPaymentUrl(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
