//
//  BiddingHistoryPresenter.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BiddingHistoryPresenter: BiddingHistoryPresenterProtocol, BiddingHistoryInteractorOutputProtocol {

    weak private var view: BiddingHistoryViewProtocol?
    var interactor: BiddingHistoryInteractorInputProtocol?
    private let router: BiddingHistoryWireframeProtocol

    init(interface: BiddingHistoryViewProtocol, interactor: BiddingHistoryInteractorInputProtocol?, router: BiddingHistoryWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
