//
//  SettingsLanguageRouter.swift
//  Auction
//
//  Created by Q on 25/10/2018.
//  Copyright © 2018 Oxbee. All rights reserved.
//

import UIKit

class SettingsLanguageRouter: SettingsLanguageWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = SettingsLanguageViewController(nibName: nil, bundle: nil)
        let interactor = SettingsLanguageInteractor()
        let router = SettingsLanguageRouter()
        let presenter = SettingsLanguagePresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
