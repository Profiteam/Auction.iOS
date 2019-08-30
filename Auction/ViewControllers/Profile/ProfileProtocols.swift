//
//  ProfileProtocols.swift
//  Auction
//
//  Created by Q on 18/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import Foundation

// MARK: WireFrameProtocol

protocol ProfileWireframeProtocol: class {

}

// MARK: PresenterProtocol

protocol ProfilePresenterProtocol: class {

    var interactor: ProfileInteractorInputProtocol? { get set }
}

// MARK: InteractorProtocol

protocol ProfileInteractorOutputProtocol: class {

    /** Interactor -> Presenter */
    func receiveProfile(data: Data)
}

protocol ProfileInteractorInputProtocol: class {

    var presenter: ProfileInteractorOutputProtocol? { get set }

    /** Presenter -> Interactor */
    func getProfile()
    func setProfile(photo: Data, params: [String: Any])
}

// MARK: ViewProtocol

protocol ProfileViewProtocol: class {

    var presenter: ProfilePresenterProtocol? { get set }

    /** Presenter -> ViewController */
    func setProfile(data: Data)
}
