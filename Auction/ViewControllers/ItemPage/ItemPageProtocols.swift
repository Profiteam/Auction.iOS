//
//  ItemPageProtocols.swift
//  Auction
//
//  Created by Q on 19/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol ItemPageWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol ItemPagePresenterProtocol: class {

    var interactor: ItemPageInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol ItemPageInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveStartedLot(data: Data)
    func receiveBets(data: Data)
}

protocol ItemPageInteractorInputProtocol: class {

    var presenter: ItemPageInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getStartedLot(lotId: String)
    func getBets(lotId: String)
}

// MARK: ViewProtocol

protocol ItemPageViewProtocol: class {

    var presenter: ItemPagePresenterProtocol? { get set }

    /** Presenter -> ViewController */
     func setStartedLot(data: Data)
    func setBets(data: Data)
}
