//
//  WalletCardProtocols.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol WalletCardWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol WalletCardPresenterProtocol: class {

    var interactor: WalletCardInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol WalletCardInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol WalletCardInteractorInputProtocol: class {

    var presenter: WalletCardInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol WalletCardViewProtocol: class {

    var presenter: WalletCardPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
