//
//  ShippingAddressRouter.swift
//  Auction
//
//  Created by Иван Меликов on 23/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class ShippingAddressRouter: ShippingAddressWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ShippingAddressViewController(nibName: nil, bundle: nil)
        let interactor = ShippingAddressInteractor()
        let router = ShippingAddressRouter()
        let presenter = ShippingAddressPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
