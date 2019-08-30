//
//  SettingsCurrencyPresenter.swift
//  Auction
//
//  Created by Q on 25/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class SettingsCurrencyPresenter: SettingsCurrencyPresenterProtocol, SettingsCurrencyInteractorOutputProtocol {

    weak private var view: SettingsCurrencyViewProtocol?
    var interactor: SettingsCurrencyInteractorInputProtocol?
    private let router: SettingsCurrencyWireframeProtocol

    init(interface: SettingsCurrencyViewProtocol, interactor: SettingsCurrencyInteractorInputProtocol?, router: SettingsCurrencyWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveCurrency(data: Data) {
        self.view?.setCurrency(data: data)
    }
    
    func currencyDidChange() {
        self.view?.currencySelected()
    }
    
    func receiveCurrencyRate(data: Data) {
        self.view?.setCurrencyRate(data: data)
    }
}
