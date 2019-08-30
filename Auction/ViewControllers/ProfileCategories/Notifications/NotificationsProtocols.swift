//
//  NotificationsProtocols.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol NotificationsWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol NotificationsPresenterProtocol: class {

    var interactor: NotificationsInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol NotificationsInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol NotificationsInteractorInputProtocol: class {

    var presenter: NotificationsInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol NotificationsViewProtocol: class {

    var presenter: NotificationsPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
