//
//  ItemPagePresenter.swift
//  Auction
//
//  Created by Q on 19/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ItemPagePresenter: ItemPagePresenterProtocol, ItemPageInteractorOutputProtocol {

    weak private var view: ItemPageViewProtocol?
    var interactor: ItemPageInteractorInputProtocol?
    private let router: ItemPageWireframeProtocol

    init(interface: ItemPageViewProtocol, interactor: ItemPageInteractorInputProtocol?, router: ItemPageWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveStartedLot(data: Data) {
        self.view?.setStartedLot(data: data)
    }
    
    func receiveBets(data: Data) {
        self.view?.setBets(data: data)
    }
}
