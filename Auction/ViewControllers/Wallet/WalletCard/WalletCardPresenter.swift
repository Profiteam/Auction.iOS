//
//  WalletCardPresenter.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class WalletCardPresenter: WalletCardPresenterProtocol, WalletCardInteractorOutputProtocol {

    weak private var view: WalletCardViewProtocol?
    var interactor: WalletCardInteractorInputProtocol?
    private let router: WalletCardWireframeProtocol

    init(interface: WalletCardViewProtocol, interactor: WalletCardInteractorInputProtocol?, router: WalletCardWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
