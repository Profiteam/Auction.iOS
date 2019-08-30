//
//  BuyItNowOffersProtocols.swift
//  Auction
//
//  Created by Q on 03/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol BuyItNowOffersWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol BuyItNowOffersPresenterProtocol: class {

    var interactor: BuyItNowOffersInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol BuyItNowOffersInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveBuyItNowOffers(data: Data)
    func changeLotStatus(data: Data)
}

protocol BuyItNowOffersInteractorInputProtocol: class {

    var presenter: BuyItNowOffersInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getBuyItNowOffers()
    func addLotToFavorite(lotID: String)
    func removeLotToFavorite(lotID: String)
}

// MARK: ViewProtocol

protocol BuyItNowOffersViewProtocol: class {

    var presenter: BuyItNowOffersPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setBuyItNowOffers(data: Data)
    func updateLotStatus(data: Data)
}
