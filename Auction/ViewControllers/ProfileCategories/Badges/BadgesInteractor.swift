//
//  BadgesInteractor.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

class BadgesInteractor: BadgesInteractorInputProtocol {

    weak var presenter: BadgesInteractorOutputProtocol?

    func getBadges() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.badges + UserDefaults.standard.string(forKey: "user_id")! + "/", success: { (response) in
            
            if let data = response as? Data {
                let badgeResponse = try? JSONDecoder().decode(BadgeResponse.self, from: data)
                if badgeResponse != nil {
                    self.presenter?.receiveBadges(data: data)
                }
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }
}
