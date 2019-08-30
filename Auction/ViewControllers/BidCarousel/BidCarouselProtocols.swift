//
//  BidCarouselProtocols.swift
//  Auction
//
//  Created by Q on 11/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol BidCarouselWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol BidCarouselPresenterProtocol: class {

    var interactor: BidCarouselInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol BidCarouselInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveCurrencyRate(data: Data)
    func receiveWallet(data: Data)
    func receiveBids(data: Data)
    func receiveBidPaymentUrl(data: Data)
}

protocol BidCarouselInteractorInputProtocol: class {

    var presenter: BidCarouselInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getCurrencyRate()
    func getWallet()
    func getBids()
    func getBidPaymentUrl(bidID: String)
}

// MARK: ViewProtocol

protocol BidCarouselViewProtocol: class {

    var presenter: BidCarouselPresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setCurrencyRate(data: Data)
    func setWallet(data: Data)
    func setBids(data: Data)
    func setBidPaymentUrl(data: Data)
}
