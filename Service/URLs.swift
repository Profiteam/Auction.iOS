//
//  URLs.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

struct URLs {

    static var baseUrl = "https://testapp.pick2me.com/" 
    
    
    static let sign_up = baseUrl + "account/sign_up/"
    
    static let confirm_phone = baseUrl + "account/confirm_phone/"
    
    static let sign_in = baseUrl + "account/sign_in/"
    
    static let reset_password = baseUrl + "account/reset_password/"

    static let change_password = baseUrl + "account/change_password/"
    
    static let lot_search = baseUrl + "lot/?search="
    
    static let lot_new = baseUrl + "lot/new/?page=1&size=10"
    
    static let lot_started = baseUrl + "lot/started/?page=1&size=10"
    
    static let lot_closed = baseUrl + "lot/closed/?page=1&size=10"
    
    static let lot_full = baseUrl + "lot/full/"
    
    static let lot_bookmarked = baseUrl + "lot/get_favorite/?page=1&size=10"
    
    static let lot_add_to_favourite = baseUrl + "lot/add_favorite/"
    
    static let lot_remove_from_favourite = baseUrl + "lot/del_favorite/"
    
    static let lot_get_bets = baseUrl + "lot/get_bets/"
    
    static let lot_payment = baseUrl + "order/lot_payment/"
    
    static let lot_get = baseUrl + "order/lot_get/"
    
    
    static let user_profile = baseUrl + "user/profile/"
    
    static let user_profile_update = baseUrl + "user/profile/update/"
    
    static let user_settings = baseUrl + "user/settings/"
    
    static let user_language = baseUrl + "user/language/"
    
    static let user_currency = baseUrl + "user/currency/"
    
    static let exchange_rate = baseUrl + "user/exchange_rate/"
    
    static let update_language = baseUrl + "user/settings/update/language/"
    
    static let update_currency = baseUrl + "user/settings/update/currency/"
    
    static let update_notify = baseUrl + "user/settings/update/notify/"
    
    
    static let bid_get = baseUrl + "bets/get/"
    
    static let bid_buy = baseUrl + "order/buy_pack/"
    
    
    static let wallet = baseUrl + "wallet/"
    
    static let wallet_history = baseUrl + "order/user/"
    
    static let unpaid_wins = baseUrl + "order/get/?type=0"
    
    static let buy_it_now_offers = baseUrl + "order/get/?type=1"
    
    static let my_orders = baseUrl + "order/get/?type=2"
    
    static let badges = baseUrl + "user/badges/"
    
    static let shipping_lot = baseUrl + "order/lot_get?lot_id="
}
