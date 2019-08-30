//
//  AuthorizationResponse.swift
//  Auction
//
//  Created by Q on 29/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct AuthorizationResponse: Codable {
    let token: String
    let userID: Int
    let status: Bool
    
    enum CodingKeys: String, CodingKey {
        case token
        case userID = "user_id"
        case status
    }
}

