//
//  LotsResponse.swift
//  Auction
//
//  Created by Q on 29/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

typealias LotsResponse = [LotData]

struct LotData: Codable {
    let id: Int
    let name, startPrice: String
    let nameAr, image1: String?
    let betsCount, status: Int
    let isFavorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case betsCount = "bets_count"
        case status, image1
        case startPrice = "start_price"
        case isFavorite = "is_favorite"
    }
}


