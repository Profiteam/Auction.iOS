//
//  ItemPagePaymentRouter.swift
//  Auction
//
//  Created by Иван Меликов on 10/06/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class ItemPagePaymentRouter: ItemPagePaymentWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ItemPagePaymentViewController(nibName: nil, bundle: nil)
        let interactor = ItemPagePaymentInteractor()
        let router = ItemPagePaymentRouter()
        let presenter = ItemPagePaymentPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
