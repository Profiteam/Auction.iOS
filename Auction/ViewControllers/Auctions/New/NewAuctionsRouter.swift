//
//  NewAuctionsRouter.swift
//  Auction
//
//  Created by Q on 21/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class NewAuctionsRouter: NewAuctionsWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = NewAuctionsViewController(nibName: nil, bundle: nil)
        let interactor = NewAuctionsInteractor()
        let router = NewAuctionsRouter()
        let presenter = NewAuctionsPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
