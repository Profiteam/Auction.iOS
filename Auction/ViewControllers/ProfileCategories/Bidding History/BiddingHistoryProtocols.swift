//
//  BiddingHistoryProtocols.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol BiddingHistoryWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol BiddingHistoryPresenterProtocol: class {

    var interactor: BiddingHistoryInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol BiddingHistoryInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
}

protocol BiddingHistoryInteractorInputProtocol: class {

    var presenter: BiddingHistoryInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
}

// MARK: ViewProtocol

protocol BiddingHistoryViewProtocol: class {

    var presenter: BiddingHistoryPresenterProtocol? { get set }

    /** Presenter -> ViewController */
}
