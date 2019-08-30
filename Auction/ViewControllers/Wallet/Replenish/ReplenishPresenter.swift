//
//  ReplenishPresenter.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ReplenishPresenter: ReplenishPresenterProtocol, ReplenishInteractorOutputProtocol {

    weak private var view: ReplenishViewProtocol?
    var interactor: ReplenishInteractorInputProtocol?
    private let router: ReplenishWireframeProtocol

    init(interface: ReplenishViewProtocol, interactor: ReplenishInteractorInputProtocol?, router: ReplenishWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
