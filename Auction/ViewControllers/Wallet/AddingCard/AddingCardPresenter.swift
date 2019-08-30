//
//  AddingCardPresenter.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class AddingCardPresenter: AddingCardPresenterProtocol, AddingCardInteractorOutputProtocol {

    weak private var view: AddingCardViewProtocol?
    var interactor: AddingCardInteractorInputProtocol?
    private let router: AddingCardWireframeProtocol

    init(interface: AddingCardViewProtocol, interactor: AddingCardInteractorInputProtocol?, router: AddingCardWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
