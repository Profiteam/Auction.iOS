//
//  ChangePasswordRequest.swift
//  Auction
//
//  Created by Иван Меликов on 19/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct ChangePasswordRequest: Codable {
    let phoneNumber, code, password: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case code, password
    }
}
