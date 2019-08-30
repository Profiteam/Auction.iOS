//
//  SettingsUpdateRequest.swift
//  Auction
//
//  Created by Q on 31/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

struct SettingsUpdateRequest: Codable {
    let currencyID, languageID: Int?
    let notify: Bool?
    
    enum CodingKeys: String, CodingKey {
        case currencyID = "currency_id"
        case languageID = "language_id"
        case notify
    }
}
