//
//  RecoveryPasswordPresenter.swift
//  Auction
//
//  Created by Иван Меликов on 19/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class RecoveryPasswordPresenter: RecoveryPasswordPresenterProtocol, RecoveryPasswordInteractorOutputProtocol {

    weak private var view: RecoveryPasswordViewProtocol?
    var interactor: RecoveryPasswordInteractorInputProtocol?
    private let router: RecoveryPasswordWireframeProtocol

    init(interface: RecoveryPasswordViewProtocol, interactor: RecoveryPasswordInteractorInputProtocol?, router: RecoveryPasswordWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func sendPhoneSuccess() {
        self.view?.showPhoneSuccess()
    }
    
    func sendPhoneError(message: String) {
        self.view?.showPhoneError(message: message)
    }
    
    func changePasswordSuccess() {
        self.view?.showChangePasswordSuccess()
    }
    
    func changePasswordError(message: String) {
        self.view?.showChangePasswordError(message: message)
    }
}
