//
//  RegistrationRequest.swift
//  Auction
//
//  Created by Q on 29/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

struct RegistrationRequest: Codable {
    let phoneNumber, password, email: String?
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case password, email
    }
}
