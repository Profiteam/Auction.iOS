//
//  SettingsResponse.swift
//  Auction
//
//  Created by Q on 31/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct SettingsResponse: Codable {
    let currency, language: String?
    let notify: Bool?
}
