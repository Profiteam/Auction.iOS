//
//  BookmarkedPresenter.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BookmarkedPresenter: BookmarkedPresenterProtocol, BookmarkedInteractorOutputProtocol {

    weak private var view: BookmarkedViewProtocol?
    var interactor: BookmarkedInteractorInputProtocol?
    private let router: BookmarkedWireframeProtocol

    init(interface: BookmarkedViewProtocol, interactor: BookmarkedInteractorInputProtocol?, router: BookmarkedWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveCurrencyRate(data: Data) {
        self.view?.setCurrencyRate(data: data)
    }
    
    func receiveBookmarkedLots(data: Data) {
        self.view?.updateBookmarkedLots(data: data)
    }
    
    func changeLotStatus(data: Data) {
        self.view?.updateLotStatus(data: data)
    }
}
