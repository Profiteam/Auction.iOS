//
//  ShippingAddressPresenter.swift
//  Auction
//
//  Created by Иван Меликов on 23/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class ShippingAddressPresenter: ShippingAddressPresenterProtocol, ShippingAddressInteractorOutputProtocol {

    weak private var view: ShippingAddressViewProtocol?
    var interactor: ShippingAddressInteractorInputProtocol?
    private let router: ShippingAddressWireframeProtocol

    init(interface: ShippingAddressViewProtocol, interactor: ShippingAddressInteractorInputProtocol?, router: ShippingAddressWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receivePaymentUrl(data: Data) {
        self.view?.setPaymentUrl(data: data)
    }
}
