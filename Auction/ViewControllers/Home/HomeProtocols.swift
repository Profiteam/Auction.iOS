//
//  HomeProtocols.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol HomeWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol HomePresenterProtocol: class {

    var interactor: HomeInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol HomeInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol HomeInteractorInputProtocol: class {

    var presenter: HomeInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol HomeViewProtocol: class {

    var presenter: HomePresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
