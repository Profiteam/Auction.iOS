//
//  ProfileInteractor.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

class ProfileInteractor: ProfileInteractorInputProtocol {

    weak var presenter: ProfileInteractorOutputProtocol?

    func getProfile() {
        let webService = AuctionWebService.init()
        webService.GETQuery(endpoint: URLs.user_profile, success: { (response) in
            
            if let data = response as? Data {
                let profileResponse = try? JSONDecoder().decode(ProfileResponse.self, from: data)
                if profileResponse != nil {
                    self.presenter?.receiveProfile(data: data)
                } 
            }
        })
        { (error) in
            print(error ?? "error")
        }
    }

    func setProfile(photo: Data, params: [String: Any]) {
        let webService = AuctionWebService.init()
        webService.UPLOADQuery(endpoint: URLs.user_profile_update, file: photo, parameters: params, success: { (response) in
            
            if let data = response as? Data {
                let profileResponse = try? JSONDecoder().decode(ProfileResponse.self, from: data)
                if profileResponse != nil {
                    self.presenter?.receiveProfile(data: data)
                }
            }
        }) { (error) in
            print(error ?? "error")
        }
    }
}
