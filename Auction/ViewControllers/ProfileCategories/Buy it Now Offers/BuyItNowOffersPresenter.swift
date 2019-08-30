//
//  BuyItNowOffersPresenter.swift
//  Auction
//
//  Created by Q on 03/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BuyItNowOffersPresenter: BuyItNowOffersPresenterProtocol, BuyItNowOffersInteractorOutputProtocol {

    weak private var view: BuyItNowOffersViewProtocol?
    var interactor: BuyItNowOffersInteractorInputProtocol?
    private let router: BuyItNowOffersWireframeProtocol

    init(interface: BuyItNowOffersViewProtocol, interactor: BuyItNowOffersInteractorInputProtocol?, router: BuyItNowOffersWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveBuyItNowOffers(data: Data) {
        self.view?.setBuyItNowOffers(data: data)
    }
    
    func changeLotStatus(data: Data) {
        self.view?.updateLotStatus(data: data)
    }
}
