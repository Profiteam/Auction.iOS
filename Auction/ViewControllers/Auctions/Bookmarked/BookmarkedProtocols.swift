//
//  BookmarkedProtocols.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol BookmarkedWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol BookmarkedPresenterProtocol: class {

    var interactor: BookmarkedInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol BookmarkedInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveCurrencyRate(data: Data)
    func receiveBookmarkedLots(data: Data)
    func changeLotStatus(data: Data)
}

protocol BookmarkedInteractorInputProtocol: class {

    var presenter: BookmarkedInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getCurrencyRate()
    func getBookmarkedLots()
    func addLotToFavorite(lotID: String)
    func removeLotToFavorite(lotID: String)
}

// MARK: ViewProtocol

protocol BookmarkedViewProtocol: class {

    var presenter: BookmarkedPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setCurrencyRate(data: Data)
    func updateBookmarkedLots(data: Data)
    func updateLotStatus(data: Data)
}
