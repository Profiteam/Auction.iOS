//
//  UnpaidWinsInteractor.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

class UnpaidWinsInteractor: UnpaidWinsInteractorInputProtocol {

    weak var presenter: UnpaidWinsInteractorOutputProtocol?

    func getUnpaidWins() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.unpaid_wins, success: { (response) in
            
            if let data = response as? Data  {
                self.presenter?.receiveUnpaidWins(data: data)
            }
        } ) { (error) in
            print(error ?? "error")
            self.presenter?.receiveUnpaidWinsError()
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
