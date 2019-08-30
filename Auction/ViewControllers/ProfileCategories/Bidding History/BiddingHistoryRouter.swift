//
//  BiddingHistoryRouter.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BiddingHistoryRouter: BiddingHistoryWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = BiddingHistoryViewController(nibName: nil, bundle: nil)
        let interactor = BiddingHistoryInteractor()
        let router = BiddingHistoryRouter()
        let presenter = BiddingHistoryPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
