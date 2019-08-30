//
//  WalletPresenter.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class WalletPresenter: WalletPresenterProtocol, WalletInteractorOutputProtocol {

    weak private var view: WalletViewProtocol?
    var interactor: WalletInteractorInputProtocol?
    private let router: WalletWireframeProtocol

    init(interface: WalletViewProtocol, interactor: WalletInteractorInputProtocol?, router: WalletWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
