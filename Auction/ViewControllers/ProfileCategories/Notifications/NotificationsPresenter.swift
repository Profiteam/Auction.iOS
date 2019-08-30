//
//  NotificationsPresenter.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class NotificationsPresenter: NotificationsPresenterProtocol, NotificationsInteractorOutputProtocol {

    weak private var view: NotificationsViewProtocol?
    var interactor: NotificationsInteractorInputProtocol?
    private let router: NotificationsWireframeProtocol

    init(interface: NotificationsViewProtocol, interactor: NotificationsInteractorInputProtocol?, router: NotificationsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
