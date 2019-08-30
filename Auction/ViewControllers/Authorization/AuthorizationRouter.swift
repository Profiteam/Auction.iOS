//
//  AuthorizationRouter.swift
//  Auction
//
//  Created by Q on 29/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class AuthorizationRouter: AuthorizationWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = AuthorizationViewController(nibName: nil, bundle: nil)
        let interactor = AuthorizationInteractor()
        let router = AuthorizationRouter()
        let presenter = AuthorizationPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
