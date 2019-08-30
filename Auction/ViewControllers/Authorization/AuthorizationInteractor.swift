//
//  AuthorizationInteractor.swift
//  Auction
//
//  Created by Q on 29/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class AuthorizationInteractor: AuthorizationInteractorInputProtocol {

    weak var presenter: AuthorizationInteractorOutputProtocol?

    func sighIn(params: [String: Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.sign_in, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let authorizationResponse = try? JSONDecoder().decode(AuthorizationResponse.self, from: data)
                if authorizationResponse?.status == true {
                    self.presenter?.sighInSuccess(data: data)
                } else {
                    self.presenter?.sighInError(message: "Invalid phone or password")
                }
            }
        })
        { (error) in
            print(error ?? "error")
            self.presenter?.sighInError(message: "Invalid phone or password")
        }
    }
}
