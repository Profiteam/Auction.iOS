//
//  ClosedAuctionsProtocols.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol ClosedAuctionsWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol ClosedAuctionsPresenterProtocol: class {

    var interactor: ClosedAuctionsInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol ClosedAuctionsInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveCurrencyRate(data: Data)
    func receiveClosedLots(data: Data)
    func changeLotStatus(data: Data)
}

protocol ClosedAuctionsInteractorInputProtocol: class {

    var presenter: ClosedAuctionsInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getCurrencyRate()
    func getClosedLots()
    func addLotToFavorite(lotID: String)
    func removeLotToFavorite(lotID: String)
}

// MARK: ViewProtocol

protocol ClosedAuctionsViewProtocol: class {

    var presenter: ClosedAuctionsPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setCurrencyRate(data: Data)
    func updateClosedLots(data: Data)
    func updateLotStatus(data: Data)
}
