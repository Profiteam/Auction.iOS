//
//  BetsResponnse.swift
//  Auction
//
//  Created by Иван Меликов on 09/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct BetsResponse: Codable {
    let count: Int
    let data: [BetsData]
}

struct BetsData: Codable {
    let value: Int?
    let date, avatar, username, lotName: String?
    let lotID, userID: String?
    
    enum CodingKeys: String, CodingKey {
        case value, date, avatar, username
        case lotName = "lot_name"
        case lotID = "lot_id"
        case userID = "user_id"
    }
}
