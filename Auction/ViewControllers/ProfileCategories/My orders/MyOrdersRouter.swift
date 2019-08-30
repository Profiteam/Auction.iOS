//
//  MyOrdersRouter.swift
//  Auction
//
//  Created by Q on 03/04/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class MyOrdersRouter: MyOrdersWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = MyOrdersViewController(nibName: nil, bundle: nil)
        let interactor = MyOrdersInteractor()
        let router = MyOrdersRouter()
        let presenter = MyOrdersPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
