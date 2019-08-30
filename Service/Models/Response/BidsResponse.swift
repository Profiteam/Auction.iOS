//
//  BidsResponse.swift
//  Auction
//
//  Created by Q on 17/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

typealias BidsResponse = [BidData]

struct BidData: Codable {
    let id, betsCount: Int?
    let price: String?
    let costPerBet: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case betsCount = "bets_count"
        case price
        case costPerBet = "cost_per_bet"
        case currency
    }
}

