//
//  WalletResponse.swift
//  Auction
//
//  Created by Q on 23/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct WalletResponse: Codable {
    let balance: Int?
    let transactions: Int?
}
