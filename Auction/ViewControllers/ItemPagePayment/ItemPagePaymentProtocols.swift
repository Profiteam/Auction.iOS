//
//  ItemPagePaymentProtocols.swift
//  Auction
//
//  Created by Иван Меликов on 10/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol ItemPagePaymentWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol ItemPagePaymentPresenterProtocol: class {

    var interactor: ItemPagePaymentInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol ItemPagePaymentInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveFullLot(data: Data)
}

protocol ItemPagePaymentInteractorInputProtocol: class {

    var presenter: ItemPagePaymentInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getFullLot(lotId: String)
}

// MARK: ViewProtocol

protocol ItemPagePaymentViewProtocol: class {

    var presenter: ItemPagePaymentPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setFullLot(data: Data)
}
