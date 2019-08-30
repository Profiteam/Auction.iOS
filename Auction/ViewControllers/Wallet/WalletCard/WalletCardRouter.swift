//
//  WalletCardRouter.swift
//  Auction
//
//  Created by Q on 26/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class WalletCardRouter: WalletCardWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = WalletCardViewController(nibName: nil, bundle: nil)
        let interactor = WalletCardInteractor()
        let router = WalletCardRouter()
        let presenter = WalletCardPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
