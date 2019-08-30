//
//  ItemPagePaymentPresenter.swift
//  Auction
//
//  Created by Иван Меликов on 10/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class ItemPagePaymentPresenter: ItemPagePaymentPresenterProtocol, ItemPagePaymentInteractorOutputProtocol {

    weak private var view: ItemPagePaymentViewProtocol?
    var interactor: ItemPagePaymentInteractorInputProtocol?
    private let router: ItemPagePaymentWireframeProtocol

    init(interface: ItemPagePaymentViewProtocol, interactor: ItemPagePaymentInteractorInputProtocol?, router: ItemPagePaymentWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveFullLot(data: Data) {
        self.view?.setFullLot(data: data)
    }
}
