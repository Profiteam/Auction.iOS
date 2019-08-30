//
//  ClosedAuctionsPresenter.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ClosedAuctionsPresenter: ClosedAuctionsPresenterProtocol, ClosedAuctionsInteractorOutputProtocol {

    weak private var view: ClosedAuctionsViewProtocol?
    var interactor: ClosedAuctionsInteractorInputProtocol?
    private let router: ClosedAuctionsWireframeProtocol

    init(interface: ClosedAuctionsViewProtocol, interactor: ClosedAuctionsInteractorInputProtocol?, router: ClosedAuctionsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func receiveCurrencyRate(data: Data) {
        self.view?.setCurrencyRate(data: data)
    }

    func receiveClosedLots(data: Data) {
        self.view?.updateClosedLots(data: data)
    }
    
    func changeLotStatus(data: Data) {
        self.view?.updateLotStatus(data: data)
    }
}
