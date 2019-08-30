//
//  ShippingLotRequest.swift
//  Auction
//
//  Created by Иван Меликов on 11/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct ShippingLotRequest: Codable {
    let order, firstName, lastName, streetAddress: String
    let city, state, zipCode, phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case order
        case firstName = "first_name"
        case lastName = "last_name"
        case streetAddress = "street_address"
        case city, state
        case zipCode = "zip_code"
        case phoneNumber = "phone_number"
    }
}
