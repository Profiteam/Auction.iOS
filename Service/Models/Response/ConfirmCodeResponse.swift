//
//  ConfirmCodeResponse.swift
//  Auction
//
//  Created by Q on 29/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct ConfirmCodeResponse: Codable {
    let status: Bool?
    let token, error: String?
    let userID: Int?
    
    enum CodingKeys: String, CodingKey {
        case status, token
        case userID = "user_id"
        case error
    }
}
