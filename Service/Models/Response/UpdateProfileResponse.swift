//
//  UpdateProfileResponse.swift
//  Auction
//
//  Created by Q on 30/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct UpdateProfileResponse: Codable {
    let lastName, email, firstName, username: String?
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case email
        case firstName = "first_name"
        case username
    }
}
