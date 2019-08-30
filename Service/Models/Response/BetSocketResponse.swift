//
//  BetSocketResponse.swift
//  Auction
//
//  Created by Q on 01/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct BetSocketResponse: Codable {
    let type: String?
    let data: BetData?
    let status: Bool?
    let error: String?
}

struct BetData: Codable {
    let value: Int?
    let date, username, lotName: String?
    let avatar: String?
    let lotID, userID: String?
    let winUser: Int?
    
    enum CodingKeys: String, CodingKey {
        case value, date, avatar, username
        case lotName = "lot_name"
        case lotID = "lot_id"
        case userID = "user_id"
        case winUser = "win_user"
    }
}
