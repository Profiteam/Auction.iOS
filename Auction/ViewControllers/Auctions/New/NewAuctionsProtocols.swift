//
//  NewAuctionsProtocols.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol NewAuctionsWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol NewAuctionsPresenterProtocol: class {

    var interactor: NewAuctionsInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol NewAuctionsInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveCurrencyRate(data: Data)
    func receiveNewLots(data: Data)
    func receiveStartedLots(data: Data)
    func changeLotStatus(data: Data)
    func receiveFoundLots(data: Data)
}

protocol NewAuctionsInteractorInputProtocol: class {

    var presenter: NewAuctionsInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getCurrencyRate()
    
    func searchLot(searchText: String)
    
    func getNewLots(params: [String : Any])
    func getStartedLots(params: [String : Any])
    
    func addLotToFavorite(lotID: String)
    func removeLotToFavorite(lotID: String)
}

// MARK: ViewProtocol

protocol NewAuctionsViewProtocol: class {

    var presenter: NewAuctionsPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setCurrencyRate(data: Data)
    func updateFoundLots(data: Data)
    func updateNewLots(data: Data)
    func updateStartedLots(data: Data)
    func updateLotStatus(data: Data)
}
