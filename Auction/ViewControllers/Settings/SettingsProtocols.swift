//
//  SettingsProtocols.swift
//  Auction
//
//  Created by Q on 24/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol SettingsWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol SettingsPresenterProtocol: class {

    var interactor: SettingsInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol SettingsInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveUserSettings(data: Data)
    func notifyDidChange()
}

protocol SettingsInteractorInputProtocol: class {

    var presenter: SettingsInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getUserSettings()
    func updateNotify(params: [String : Any])
}

// MARK: ViewProtocol

protocol SettingsViewProtocol: class {

    var presenter: SettingsPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setUserSettings(data: Data)
    func notifyChanged()
}
