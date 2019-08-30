//
//  SettingsLanguageInteractor.swift
//  Auction
//
//  Created by Q on 25/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class SettingsLanguageInteractor: SettingsLanguageInteractorInputProtocol {

    weak var presenter: SettingsLanguageInteractorOutputProtocol?

    func getLanguage() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.user_language, success: { (response) in
            
            if let data = response as? Data {
                let languageResponse = try? JSONDecoder().decode(LanguageResponse.self, from: data)
                if languageResponse != nil {
                    self.presenter?.receiveLanguage(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
    
    func setUserLanguage(params: [String: Any]) {
        let webService = AuctionWebService.init()
        webService.POSTQuery(endpoint: URLs.update_language, params: params as [String : Any], success: { (response) in
            
            if let data = response as? Data {
                let statusResponse = try? JSONDecoder().decode(StatusResponse.self, from: data)
                if statusResponse?.status == true {
                    self.presenter?.languageDidChange()
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
