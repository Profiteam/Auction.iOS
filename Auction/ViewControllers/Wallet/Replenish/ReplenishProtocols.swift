//
//  ReplenishProtocols.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol ReplenishWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol ReplenishPresenterProtocol: class {

    var interactor: ReplenishInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol ReplenishInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol ReplenishInteractorInputProtocol: class {

    var presenter: ReplenishInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol ReplenishViewProtocol: class {

    var presenter: ReplenishPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
