//
//  ProfileResponse.swift
//  Auction
//
//  Created by Q on 30/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct ProfileResponse: Codable {
    let username, firstName, avatar, lastName: String?
    let phoneNumber, email: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case avatar
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email
    }
}
