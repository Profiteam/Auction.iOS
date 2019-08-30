//
//  MyOrdersProtocols.swift
//  Auction
//
//  Created by Q on 03/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol MyOrdersWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol MyOrdersPresenterProtocol: class {

    var interactor: MyOrdersInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol MyOrdersInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveMyOrders(data: Data)
    func changeLotStatus(data: Data)
}

protocol MyOrdersInteractorInputProtocol: class {

    var presenter: MyOrdersInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getUserOrders()
    func addLotToFavorite(lotID: String)
    func removeLotToFavorite(lotID: String)
}

// MARK: ViewProtocol

protocol MyOrdersViewProtocol: class {

    var presenter: MyOrdersPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setMyOrders(data: Data)
    func updateLotStatus(data: Data)
}
