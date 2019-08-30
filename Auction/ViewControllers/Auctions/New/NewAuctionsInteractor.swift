//
//  NewAuctionsInteractor.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class NewAuctionsInteractor: NewAuctionsInteractorInputProtocol {

    weak var presenter: NewAuctionsInteractorOutputProtocol?

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
    
    func getNewLots(params: [String : Any]) {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.lot_new, params: params, success: { (response) in
            
            if let data = response as? Data  {
                let lotsResponse = try? JSONDecoder().decode(LotsResponse.self, from: data)
                
                if lotsResponse != nil {
                    self.presenter?.receiveNewLots(data: data)
                } else {
                    print("get_new_lot_error")
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func getStartedLots(params: [String : Any]) {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.lot_started, params: params, success: { (response) in
            
            if let data = response as? Data  {
                let lotsResponse = try? JSONDecoder().decode(LotsResponse.self, from: data)
                
                if lotsResponse != nil {
                    self.presenter?.receiveStartedLots(data: data)
                } else {
                    print("get_started_lot_error")
                }
            }
        }) { (error) in
            print(error ?? "error")
        }
    }
    
    func searchLot(searchText: String) {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.lot_search + searchText, success: { (response) in
            
            if let data = response as? Data  {
                let lotsResponse = try? JSONDecoder().decode(LotsResponse.self, from: data)
                
                if lotsResponse != nil {
                    self.presenter?.receiveFoundLots(data: data)
                } else {
                    print("search_lot_error")
                }
            }
        } ) { (error) in
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
