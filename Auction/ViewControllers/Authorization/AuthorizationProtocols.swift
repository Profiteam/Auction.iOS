//
//  AuthorizationProtocols.swift
//  Auction
//
//  Created by Q on 29/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol AuthorizationWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol AuthorizationPresenterProtocol: class {

    var interactor: AuthorizationInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol AuthorizationInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func sighInSuccess(data: Data)
    func sighInError(message: String)
}

protocol AuthorizationInteractorInputProtocol: class {

    var presenter: AuthorizationInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func sighIn(params: [String: Any])
}

// MARK: ViewProtocol

protocol AuthorizationViewProtocol: class {

    var presenter: AuthorizationPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func showSighInSuccess(data: Data)
    func showSighInError(message: String)
}
