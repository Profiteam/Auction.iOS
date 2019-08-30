//
//  ClosedAuctionsRouter.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ClosedAuctionsRouter: ClosedAuctionsWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ClosedAuctionsViewController(nibName: nil, bundle: nil)
        let interactor = ClosedAuctionsInteractor()
        let router = ClosedAuctionsRouter()
        let presenter = ClosedAuctionsPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
