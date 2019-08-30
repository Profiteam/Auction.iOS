//
//  WalletProtocols.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol WalletWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol WalletPresenterProtocol: class {

    var interactor: WalletInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol WalletInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol WalletInteractorInputProtocol: class {

    var presenter: WalletInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol WalletViewProtocol: class {

    var presenter: WalletPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
