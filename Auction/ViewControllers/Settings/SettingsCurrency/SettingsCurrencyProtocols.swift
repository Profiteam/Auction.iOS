//
//  SettingsCurrencyProtocols.swift
//  Auction
//
//  Created by Q on 25/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol SettingsCurrencyWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol SettingsCurrencyPresenterProtocol: class {

    var interactor: SettingsCurrencyInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol SettingsCurrencyInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveCurrency(data: Data)
    func receiveCurrencyRate(data: Data)
    func currencyDidChange()
}

protocol SettingsCurrencyInteractorInputProtocol: class {

    var presenter: SettingsCurrencyInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getCurrency()
    func getCurrencyRate()
    func setUserCurrency(params: [String: Any])
}

// MARK: ViewProtocol

protocol SettingsCurrencyViewProtocol: class {

    var presenter: SettingsCurrencyPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setCurrency(data: Data)
    func setCurrencyRate(data: Data)
    func currencySelected()
}
