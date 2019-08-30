//
//  ItemPagePaymentInteractor.swift
//  Auction
//
//  Created by Иван Меликов on 10/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

class ItemPagePaymentInteractor: ItemPagePaymentInteractorInputProtocol {

    weak var presenter: ItemPagePaymentInteractorOutputProtocol?

    func getFullLot(lotId: String) {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.lot_get + lotId + "/", success: { (response) in
            
            if let data = response as? Data  {
                let shippingLotResponse = try? JSONDecoder().decode(FullLotResponse.self, from: data)
                
                if shippingLotResponse != nil {
                    self.presenter?.receiveFullLot(data: data)
                } else {
                    print("get_full_lot_error")
                }
            }
        } ) { (error) in
            print(error ?? "error")
        }
    }
}
