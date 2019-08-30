//
//  WalletBalancePresenter.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class WalletBalancePresenter: WalletBalancePresenterProtocol, WalletBalanceInteractorOutputProtocol {

    weak private var view: WalletBalanceViewProtocol?
    var interactor: WalletBalanceInteractorInputProtocol?
    private let router: WalletBalanceWireframeProtocol

    init(interface: WalletBalanceViewProtocol, interactor: WalletBalanceInteractorInputProtocol?, router: WalletBalanceWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveWallet(data: Data) {
        self.view?.setWallet(data: data)
    }
    
    func receiveWalletHistory(data: Data) {
        self.view?.setWalletHistory(data: data)
    }
}
