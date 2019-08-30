//
//  CurrencyResponse.swift
//  Auction
//
//  Created by Иван Меликов on 06/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

typealias CurrencyResposne = [CurrencyData]

struct CurrencyData: Codable {
    let id: Int
    let shortName, fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case shortName = "short_name"
        case fullName = "full_name"
    }
}
