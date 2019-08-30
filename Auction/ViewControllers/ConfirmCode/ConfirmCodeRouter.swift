//
//  ConfirmCodeRouter.swift
//  Auction
//
//  Created by Q on 24/11/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ConfirmCodeRouter: ConfirmCodeWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ConfirmCodeViewController(nibName: nil, bundle: nil)
        let interactor = ConfirmCodeInteractor()
        let router = ConfirmCodeRouter()
        let presenter = ConfirmCodePresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
