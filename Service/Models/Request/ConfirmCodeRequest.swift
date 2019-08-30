//
//  ConfirmCodeRequest.swift
//  Auction
//
//  Created by Q on 29/03/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

struct ConfirmCodeRequest: Codable {
    let phoneNumber, code, deviceID, registrationID, type: String?
    
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
        case code
        case deviceID = "device_id"
        case registrationID = "registration_id"
        case type
    }
}

