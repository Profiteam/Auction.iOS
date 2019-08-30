//
//  UnpaidWinsProtocols.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol UnpaidWinsWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol UnpaidWinsPresenterProtocol: class {

    var interactor: UnpaidWinsInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol UnpaidWinsInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveUnpaidWins(data: Data)
    func receiveUnpaidWinsError()
    func changeLotStatus(data: Data)
    
}

protocol UnpaidWinsInteractorInputProtocol: class {

    var presenter: UnpaidWinsInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getUnpaidWins()
    func addLotToFavorite(lotID: String)
    func removeLotToFavorite(lotID: String)
}

// MARK: ViewProtocol

protocol UnpaidWinsViewProtocol: class {

    var presenter: UnpaidWinsPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setUnpaidWins(data: Data)
    func updateLotStatus(data: Data)
    func showError()
}
