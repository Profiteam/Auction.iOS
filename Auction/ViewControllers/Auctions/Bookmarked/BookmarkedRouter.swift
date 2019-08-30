//
//  BookmarkedRouter.swift
//  Auction
//
//  Created by Q on 22/05/2019.
//  Copyright © 2019 Oxbee. All rights reserved.
//

import UIKit

class BookmarkedRouter: BookmarkedWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = BookmarkedViewController(nibName: nil, bundle: nil)
        let interactor = BookmarkedInteractor()
        let router = BookmarkedRouter()
        let presenter = BookmarkedPresenter(interface: view,
                                                                interactor: interactor,
                                                                router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

}
