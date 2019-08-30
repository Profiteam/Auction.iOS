//
//  RegistrationProtocols.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol RegistrationWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol RegistrationPresenterProtocol: class {

    var interactor: RegistrationInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol RegistrationInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func signUpSuccess()
    func signUpError(message: String)
}

protocol RegistrationInteractorInputProtocol: class {

    var presenter: RegistrationInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func signUp(params: [String : Any])
}

// MARK: ViewProtocol

protocol RegistrationViewProtocol: class {

    var presenter: RegistrationPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func showSignUpSuccess()
    func showSignUpError(message: String)
}
