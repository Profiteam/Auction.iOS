//
//  ProfilePresenter.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ProfilePresenter: ProfilePresenterProtocol, ProfileInteractorOutputProtocol {

    weak private var view: ProfileViewProtocol?
    var interactor: ProfileInteractorInputProtocol?
    private let router: ProfileWireframeProtocol

    init(interface: ProfileViewProtocol, interactor: ProfileInteractorInputProtocol?, router: ProfileWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func receiveProfile(data: Data) {
        self.view?.setProfile(data: data)
    }
}
