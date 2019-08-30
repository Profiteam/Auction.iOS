//
//  AddingCardProtocols.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol AddingCardWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol AddingCardPresenterProtocol: class {

    var interactor: AddingCardInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol AddingCardInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol AddingCardInteractorInputProtocol: class {

    var presenter: AddingCardInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol AddingCardViewProtocol: class {

    var presenter: AddingCardPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
