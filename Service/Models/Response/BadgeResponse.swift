//
//  BadgeResponse.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

typealias BadgeResponse = [BadgeData]

struct BadgeData: Codable {
    let id, badgeNumber: Int
    let date: String
    let user: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case badgeNumber = "badge_number"
        case date, user
    }
}
