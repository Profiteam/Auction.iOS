//
//  ShippingAddressInteractor.swift
//  Auction
//
//  Created by Иван Меликов on 23/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

class ShippingAddressInteractor: ShippingAddressInteractorInputProtocol {

    weak var presenter: ShippingAddressInteractorOutputProtocol?

    func getPaymentUrl(params: [String : Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.lot_payment, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let shippingLotResponse = try? JSONDecoder().decode(ShippingLotResponse.self, from: data)
                if shippingLotResponse?.status == true {
                    self.presenter?.receivePaymentUrl(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
