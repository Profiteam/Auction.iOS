//
//  PurchaseResponse.swift
//  Auction
//
//  Created by Q on 21/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

typealias PurchaseResponse = [PurchaseData]

struct PurchaseData: Codable {
    let id: Int
    let name, amount, currency, date: String
}
