//
//  WalletBalanceProtocols.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol WalletBalanceWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol WalletBalancePresenterProtocol: class {

    var interactor: WalletBalanceInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol WalletBalanceInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveWallet(data: Data)
    func receiveWalletHistory(data: Data)
}

protocol WalletBalanceInteractorInputProtocol: class {

    var presenter: WalletBalanceInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getWallet()
    func getWalletHistory()
}

// MARK: ViewProtocol

protocol WalletBalanceViewProtocol: class {

    var presenter: WalletBalancePresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setWallet(data: Data)
    func setWalletHistory(data: Data)
}
