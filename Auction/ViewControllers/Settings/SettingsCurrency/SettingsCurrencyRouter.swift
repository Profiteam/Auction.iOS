//
//  SettingsCurrencyRouter.swift
//  Auction
//
//  Created by Q on 25/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class SettingsCurrencyRouter: SettingsCurrencyWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = SettingsCurrencyViewController(nibName: nil, bundle: nil)
        let interactor = SettingsCurrencyInteractor()
        let router = SettingsCurrencyRouter()
        let presenter = SettingsCurrencyPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
