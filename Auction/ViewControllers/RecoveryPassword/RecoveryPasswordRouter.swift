//
//  RecoveryPasswordRouter.swift
//  Auction
//
//  Created by Иван Меликов on 19/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class RecoveryPasswordRouter: RecoveryPasswordWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = RecoveryPasswordViewController(nibName: nil, bundle: nil)
        let interactor = RecoveryPasswordInteractor()
        let router = RecoveryPasswordRouter()
        let presenter = RecoveryPasswordPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
