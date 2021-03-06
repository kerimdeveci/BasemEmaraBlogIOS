//
//  ListTermsCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct ListTermsCore: ListTermsCoreType {
    private let root: SwiftyPressCore
    private let render: SceneRenderType
    
    init(root: SwiftyPressCore, render: SceneRenderType) {
        self.root = root
        self.render = render
    }
    
    func dependency(with viewController: ListTermsDisplayable?) -> ListTermsActionable {
        ListTermsAction(
            presenter: dependency(with: viewController),
            taxonomyProvider: root.dependency()
        )
    }
    
    func dependency(with viewController: ListTermsDisplayable?) -> ListTermsPresentable {
        ListTermsPresenter(viewController: viewController)
    }
    
    func dependency(with viewController: UIViewController?) -> ListTermsRouterable {
        ListTermsRouter(
            render: render,
            viewController: viewController
        )
    }
}
