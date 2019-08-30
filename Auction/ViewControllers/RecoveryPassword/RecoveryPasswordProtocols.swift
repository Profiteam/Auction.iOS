//
//  RecoveryPasswordProtocols.swift
//  Auction
//
//  Created by Иван Меликов on 19/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol RecoveryPasswordWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol RecoveryPasswordPresenterProtocol: class {

    var interactor: RecoveryPasswordInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol RecoveryPasswordInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func sendPhoneSuccess()
    func sendPhoneError(message: String)
    func changePasswordSuccess()
    func changePasswordError(message: String)
}

protocol RecoveryPasswordInteractorInputProtocol: class {

    var presenter: RecoveryPasswordInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func sendPhone(params: [String : Any])
    func changePassword(params: [String : Any])
}

// MARK: ViewProtocol

protocol RecoveryPasswordViewProtocol: class {

    var presenter: RecoveryPasswordPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func showPhoneSuccess()
    func showPhoneError(message: String)
    func showChangePasswordSuccess()
    func showChangePasswordError(message: String)
}
