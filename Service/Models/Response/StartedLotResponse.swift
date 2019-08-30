//
//  StartedLotResponse.swift
//  Auction
//
//  Created by Q on 29/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct StartedLotResponse: Codable {
    let id: Int
    let name, nameAr: String?
    let status: Int
    let descriptions, descriptionsAr: String?
    let startDate: String?
    let closeDate: String?
    let betsCount, currentBet: Int
    let winTimer: String?
    let betStep: Int
    let image1, image2, image3, image4: String?
    let category, startPrice, buyNowPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case status, descriptions
        case descriptionsAr = "descriptions_ar"
        case startDate = "start_date"
        case closeDate = "close_date"
        case betsCount = "bets_count"
        case currentBet = "current_bet"
        case winTimer = "win_timer"
        case betStep = "bet_step"
        case image1, image2, image3, image4, category
        case startPrice = "start_price"
        case buyNowPrice = "buy_now_price"
    }
}
