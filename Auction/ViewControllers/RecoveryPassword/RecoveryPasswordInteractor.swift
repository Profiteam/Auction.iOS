//
//  RecoveryPasswordInteractor.swift
//  Auction
//
//  Created by Иван Меликов on 19/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

class RecoveryPasswordInteractor: RecoveryPasswordInteractorInputProtocol {

    weak var presenter: RecoveryPasswordInteractorOutputProtocol?

    func sendPhone(params: [String : Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.reset_password, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let recoveryPasswordResponse = try? JSONDecoder().decode(RecoveryPasswordResponse.self, from: data)
                if recoveryPasswordResponse?.status == true {
                    self.presenter?.sendPhoneSuccess()
                } else {
                    self.presenter?.sendPhoneError(message: recoveryPasswordResponse?.error ?? "")
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func changePassword(params: [String : Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.change_password, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let changePasswordResponse = try? JSONDecoder().decode(ChangePasswordResponse.self, from: data)
                if changePasswordResponse?.status == true {
                    self.presenter?.changePasswordSuccess()
                } else {
                    self.presenter?.changePasswordError(message: changePasswordResponse?.error ?? "")
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
