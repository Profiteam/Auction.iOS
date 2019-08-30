//
//  CurrencyRequest.swift
//  Auction
//
//  Created by Иван Меликов on 06/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct CurrencyRequest: Codable {
    let currencyID: Int
    
    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
    }
}
