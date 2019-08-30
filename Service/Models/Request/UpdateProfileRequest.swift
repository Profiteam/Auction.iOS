//
//  UpdateProfileRequest.swift
//  Auction
//
//  Created by Q on 30/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

struct UpdateProfileRequest: Codable {
    let username, firstName, lastName, phoneNumber: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case email
    }
}
