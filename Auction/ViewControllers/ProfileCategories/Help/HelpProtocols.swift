//
//  HelpProtocols.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol HelpWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol HelpPresenterProtocol: class {

    var interactor: HelpInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol HelpInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol HelpInteractorInputProtocol: class {

    var presenter: HelpInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol HelpViewProtocol: class {

    var presenter: HelpPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
