//
//  BadgesPresenter.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BadgesPresenter: BadgesPresenterProtocol, BadgesInteractorOutputProtocol {

    weak private var view: BadgesViewProtocol?
    var interactor: BadgesInteractorInputProtocol?
    private let router: BadgesWireframeProtocol

    init(interface: BadgesViewProtocol, interactor: BadgesInteractorInputProtocol?, router: BadgesWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func receiveBadges(data: Data) {
        self.view?.setBadges(data: data)
    }
}
