//
//  SettingsCurrencyInteractor.swift
//  Auction
//
//  Created by Q on 25/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class SettingsCurrencyInteractor: SettingsCurrencyInteractorInputProtocol {
    
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
    

    weak var presenter: SettingsCurrencyInteractorOutputProtocol?

    func getCurrency() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.user_currency, success: { (response) in
            
            if let data = response as? Data {
                let currencyResponse = try? JSONDecoder().decode(CurrencyResposne.self, from: data)
                if currencyResponse != nil {
                    self.presenter?.receiveCurrency(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func setUserCurrency(params: [String : Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.update_currency, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let statusResponse = try? JSONDecoder().decode(StatusResponse.self, from: data)
                if statusResponse?.status == true {
                    self.presenter?.currencyDidChange()
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
