//
//  ItemPageInteractor.swift
//  Auction
//
//  Created by Q on 19/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class ItemPageInteractor: ItemPageInteractorInputProtocol {

    weak var presenter: ItemPageInteractorOutputProtocol?

    func getStartedLot(lotId: String) {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.lot_full + lotId + "/", success: { (response) in
            
            if let data = response as? Data  {
                let startedLotResponse = try? JSONDecoder().decode(StartedLotResponse.self, from: data)
                
                if startedLotResponse != nil {
                    self.presenter?.receiveStartedLot(data: data)
                } else {
                    print("get_full_lot_error")
                }
            }
        } ) { (error) in
            print(error ?? "error")
        }
    }
    
    func getBets(lotId: String) {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.lot_get_bets + lotId + "/?page=1&size=10", success: { (response) in
            
            if let data = response as? Data  {
                let betsResponse = try? JSONDecoder().decode(BetsResponse.self, from: data)
                
                if betsResponse!.count > 0 {
                    self.presenter?.receiveBets(data: data)
                } else {
                    print("get_bets_error")
                }
            }
        } ) { (error) in
            print(error ?? "error")
        }
    }
}
