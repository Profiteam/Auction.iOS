//
//  SettingsInteractor.swift
//  Auction
//
//  Created by Q on 24/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class SettingsInteractor: SettingsInteractorInputProtocol {

    weak var presenter: SettingsInteractorOutputProtocol?

    func getUserSettings() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.user_settings, success: { (response) in
            
            if let data = response as? Data {
                let settingsResponse = try? JSONDecoder().decode(SettingsResponse.self, from: data)
                if settingsResponse != nil {
                    self.presenter?.receiveUserSettings(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func updateNotify(params: [String: Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.update_notify, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let statusResponse = try? JSONDecoder().decode(StatusResponse.self, from: data)
                if statusResponse?.status == true {
                    self.presenter?.notifyDidChange()
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
