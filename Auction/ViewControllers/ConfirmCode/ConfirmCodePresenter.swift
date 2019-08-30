//
//  ConfirmCodePresenter.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ConfirmCodePresenter: ConfirmCodePresenterProtocol, ConfirmCodeInteractorOutputProtocol {

    weak private var view: ConfirmCodeViewProtocol?
    var interactor: ConfirmCodeInteractorInputProtocol?
    private let router: ConfirmCodeWireframeProtocol

    init(interface: ConfirmCodeViewProtocol, interactor: ConfirmCodeInteractorInputProtocol?, router: ConfirmCodeWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func confirmCodeSuccess(data: Data) {
        self.view?.showConfirmCodeSuccess(data: data)
    }
    
    func confirmCodeError(message: String) {
        self.view?.showConfirmCodeError(message: message)
    }
}
