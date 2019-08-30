//
//  RecoveryPasswordResponse.swift
//  Auction
//
//  Created by Иван Меликов on 19/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

struct RecoveryPasswordResponse: Codable {
    let message: String?
    let status: Bool
    let error: String?
}
