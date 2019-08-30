//
//  AddingCardRouter.swift
//  Auction
//
//  Created by Q on 27/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class AddingCardRouter: AddingCardWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = AddingCardViewController(nibName: nil, bundle: nil)
        let interactor = AddingCardInteractor()
        let router = AddingCardRouter()
        let presenter = AddingCardPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
