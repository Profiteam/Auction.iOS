//
//  ShippingAddressProtocols.swift
//  Auction
//
//  Created by Иван Меликов on 23/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol ShippingAddressWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol ShippingAddressPresenterProtocol: class {

    var interactor: ShippingAddressInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol ShippingAddressInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receivePaymentUrl(data: Data)
}

protocol ShippingAddressInteractorInputProtocol: class {

    var presenter: ShippingAddressInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getPaymentUrl(params: [String : Any])
}

// MARK: ViewProtocol

protocol ShippingAddressViewProtocol: class {

    var presenter: ShippingAddressPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setPaymentUrl(data: Data)
}
