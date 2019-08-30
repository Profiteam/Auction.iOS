//
//  BadgesProtocols.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol BadgesWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol BadgesPresenterProtocol: class {

    var interactor: BadgesInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol BadgesInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveBadges(data: Data)
}

protocol BadgesInteractorInputProtocol: class {

    var presenter: BadgesInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getBadges()
}

// MARK: ViewProtocol

protocol BadgesViewProtocol: class {

    var presenter: BadgesPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setBadges(data: Data)
}
