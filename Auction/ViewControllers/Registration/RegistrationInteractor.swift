//
//  RegistrationInteractor.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class RegistrationInteractor: RegistrationInteractorInputProtocol {

    weak var presenter: RegistrationInteractorOutputProtocol?

    func signUp(params: [String : Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.sign_up, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let registerationResponse = try? JSONDecoder().decode(RegisterationResponse.self, from: data)
                if registerationResponse?.message != nil {
                    self.presenter?.signUpSuccess()
                } else if registerationResponse?.error != nil {
                    self.presenter?.signUpError(message: registerationResponse?.error ?? "")
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
