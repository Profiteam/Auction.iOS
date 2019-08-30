//
//  NotifyRequest.swift
//  Auction
//
//  Created by Иван Меликов on 06/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct NotifyRequest: Codable {
    let notify: Int
    
    enum CodingKeys: String, CodingKey {
        case notify = "notify"
    }
}
