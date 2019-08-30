//
//  HelpPresenter.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class HelpPresenter: HelpPresenterProtocol, HelpInteractorOutputProtocol {

    weak private var view: HelpViewProtocol?
    var interactor: HelpInteractorInputProtocol?
    private let router: HelpWireframeProtocol

    init(interface: HelpViewProtocol, interactor: HelpInteractorInputProtocol?, router: HelpWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
