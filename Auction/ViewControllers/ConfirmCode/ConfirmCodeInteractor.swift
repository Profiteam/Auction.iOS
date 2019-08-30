//
//  ConfirmCodeInteractor.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class ConfirmCodeInteractor: ConfirmCodeInteractorInputProtocol {

    weak var presenter: ConfirmCodeInteractorOutputProtocol?

    func confirmCode(params: [String: Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.confirm_phone, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let confirmCodeResponse = try? JSONDecoder().decode(ConfirmCodeResponse.self, from: data)
                if confirmCodeResponse?.status == true {
                    self.presenter?.confirmCodeSuccess(data: data)
                } else {
                    self.presenter?.confirmCodeError(message: confirmCodeResponse?.error ?? "")
                }
            }
        })
        { (error) in
            print(error ?? "error")
            self.presenter?.confirmCodeError(message: error ?? "")
        }
    }
}
