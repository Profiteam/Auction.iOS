//
//  UnpaidWinsRouter.swift
//  Auction
//
//  Created by Q on 12/01/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class UnpaidWinsRouter: UnpaidWinsWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = UnpaidWinsViewController(nibName: nil, bundle: nil)
        let interactor = UnpaidWinsInteractor()
        let router = UnpaidWinsRouter()
        let presenter = UnpaidWinsPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
