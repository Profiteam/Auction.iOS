//
//  FullLotResponse.swift
//  Auction
//
//  Created by Иван Меликов on 11/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct FullLotResponse: Codable {
    let image1, image2, image3, name: String?
    let nameAr: String?
    let price, shippingCost, salesTaxValue: Int
    let currency: String?
    let total, orderID, status: Int
    
    enum CodingKeys: String, CodingKey {
        case image1, image2, image3, name
        case nameAr = "name_ar"
        case price
        case shippingCost = "shipping_cost"
        case salesTaxValue = "sales_tax_value"
        case currency, total
        case orderID = "order_id"
        case status
    }
}
