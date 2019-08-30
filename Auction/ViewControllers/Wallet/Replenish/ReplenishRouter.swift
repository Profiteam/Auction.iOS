//
//  ReplenishRouter.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ReplenishRouter: ReplenishWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ReplenishViewController(nibName: nil, bundle: nil)
        let interactor = ReplenishInteractor()
        let router = ReplenishRouter()
        let presenter = ReplenishPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
