//
//  MyOrdersInteractor.swift
//  Auction
//
//  Created by Q on 03/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

class MyOrdersInteractor: MyOrdersInteractorInputProtocol {

    weak var presenter: MyOrdersInteractorOutputProtocol?

    func getUserOrders() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.my_orders, success: { (response) in
            
            if let data = response as? Data  {
                self.presenter?.receiveMyOrders(data: data)
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
