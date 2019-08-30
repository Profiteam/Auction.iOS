//
//  LanguageRequest.swift
//  Auction
//
//  Created by Иван Меликов on 06/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct LanguageRequest: Codable {
    let languageID: Int
    
    enum CodingKeys: String, CodingKey {
        case languageID = "language_id"
    }
}
