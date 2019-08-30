//
//  BookmarkedInteractor.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

class BookmarkedInteractor: BookmarkedInteractorInputProtocol {

    weak var presenter: BookmarkedInteractorOutputProtocol?

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
    
    func getBookmarkedLots() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.lot_bookmarked, success: { (response) in
            
            if let data = response as? Data  {
                let lotsResponse = try? JSONDecoder().decode(LotsResponse.self, from: data)
                
                if lotsResponse != nil {
                    self.presenter?.receiveBookmarkedLots(data: data)
                } else {
                    print("get_bookmarked_lot_error")
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func addLotToFavorite(lotID: String) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.lot_add_to_favourite + lotID + "/", params: nil, success: { (response) in
            
            if let data = response as? Data {
                let favoriteResponse = try? JSONDecoder().decode(FavoriteResponse.self, from: data)
                if favoriteResponse?.status == true {
                    self.presenter?.changeLotStatus(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func removeLotToFavorite(lotID: String) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.lot_remove_from_favourite + lotID + "/", params: nil, success: { (response) in
            
            if let data = response as? Data {
                let favoriteResponse = try? JSONDecoder().decode(FavoriteResponse.self, from: data)
                if favoriteResponse?.status == true {
                    self.presenter?.changeLotStatus(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
