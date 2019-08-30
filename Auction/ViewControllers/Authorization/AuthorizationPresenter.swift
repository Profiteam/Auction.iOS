//
//  AuthorizationPresenter.swift
//  Auction
//
//  Created by Q on 29/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class AuthorizationPresenter: AuthorizationPresenterProtocol, AuthorizationInteractorOutputProtocol {

    weak private var view: AuthorizationViewProtocol?
    var interactor: AuthorizationInteractorInputProtocol?
    private let router: AuthorizationWireframeProtocol

    init(interface: AuthorizationViewProtocol, interactor: AuthorizationInteractorInputProtocol?, router: AuthorizationWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func sighInSuccess(data: Data) {
        self.view?.showSighInSuccess(data: data)
    }
    
    func sighInError(message: String) {
        self.view?.showSighInError(message: message)
    }
}
