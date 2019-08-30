//
//  BidCarouselRouter.swift
//  Auction
//
//  Created by Q on 11/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BidCarouselRouter: BidCarouselWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = BidCarouselViewController(nibName: nil, bundle: nil)
        let interactor = BidCarouselInteractor()
        let router = BidCarouselRouter()
        let presenter = BidCarouselPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
