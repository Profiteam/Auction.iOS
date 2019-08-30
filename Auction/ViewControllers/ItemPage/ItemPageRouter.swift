//
//  ItemPageRouter.swift
//  Auction
//
//  Created by Q on 19/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class ItemPageRouter: ItemPageWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ItemPageViewController(nibName: nil, bundle: nil)
        let interactor = ItemPageInteractor()
        let router = ItemPageRouter()
        let presenter = ItemPagePresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
