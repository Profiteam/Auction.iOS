//
//  AuthorizationRequest.swift
//  Auction
//
//  Created by Q on 29/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

struct AuthorizationRequest: Codable {
    let userInfo, password: String?
    
    enum CodingKeys: String, CodingKey {
        case userInfo = "user_info"
        case password
    }
}
