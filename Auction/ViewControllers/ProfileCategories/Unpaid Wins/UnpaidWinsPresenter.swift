//
//  UnpaidWinsPresenter.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class UnpaidWinsPresenter: UnpaidWinsPresenterProtocol, UnpaidWinsInteractorOutputProtocol {

    weak private var view: UnpaidWinsViewProtocol?
    var interactor: UnpaidWinsInteractorInputProtocol?
    private let router: UnpaidWinsWireframeProtocol

    init(interface: UnpaidWinsViewProtocol, interactor: UnpaidWinsInteractorInputProtocol?, router: UnpaidWinsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveUnpaidWins(data: Data) {
        self.view?.setUnpaidWins(data: data)
    }
    
    func changeLotStatus(data: Data) {
        self.view?.updateLotStatus(data: data)
    }
    
    func receiveUnpaidWinsError() {
        self.view?.showError()
    }
}
