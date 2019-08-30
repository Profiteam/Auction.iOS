//
//  NewAuctionsPresenter.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class NewAuctionsPresenter: NewAuctionsPresenterProtocol, NewAuctionsInteractorOutputProtocol {

    weak private var view: NewAuctionsViewProtocol?
    var interactor: NewAuctionsInteractorInputProtocol?
    private let router: NewAuctionsWireframeProtocol

    init(interface: NewAuctionsViewProtocol, interactor: NewAuctionsInteractorInputProtocol?, router: NewAuctionsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func receiveCurrencyRate(data: Data) {
        self.view?.setCurrencyRate(data: data)
    }

    func receiveNewLots(data: Data) {
        self.view?.updateNewLots(data: data)
    }
    
    func receiveStartedLots(data: Data) {
        self.view?.updateStartedLots(data: data)
    }
    
    func changeLotStatus(data: Data) {
        self.view?.updateLotStatus(data: data)
    }
    
    func receiveFoundLots(data: Data) {
        self.view?.updateFoundLots(data: data)
    }
}
