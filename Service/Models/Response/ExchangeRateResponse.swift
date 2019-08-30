//
//  ExchangeRateResponse.swift
//  Auction
//
//  Created by Иван Меликов on 17/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct ExchangeRateResponse: Codable {
    let currency: String
    let rate: Double
}
