//
//  MyOrdersPresenter.swift
//  Auction
//
//  Created by Q on 03/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class MyOrdersPresenter: MyOrdersPresenterProtocol, MyOrdersInteractorOutputProtocol {

    weak private var view: MyOrdersViewProtocol?
    var interactor: MyOrdersInteractorInputProtocol?
    private let router: MyOrdersWireframeProtocol

    init(interface: MyOrdersViewProtocol, interactor: MyOrdersInteractorInputProtocol?, router: MyOrdersWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveMyOrders(data: Data) {
        self.view?.setMyOrders(data: data)
    }
    
    func changeLotStatus(data: Data) {
        self.view?.updateLotStatus(data: data)
    }
}
