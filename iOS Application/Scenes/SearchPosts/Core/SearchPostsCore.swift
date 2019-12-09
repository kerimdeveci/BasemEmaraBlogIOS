//
//  SearchPostsCore.swift
//  Basem Emara
//
//  Created by Basem Emara on 2019-09-21.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

struct SearchPostsCore: SearchPostsCoreType {
    private let core: SwiftyPressCore
    private let render: SceneRenderType
    
    init(core: SwiftyPressCore, render: SceneRenderType) {
        self.core = core
        self.render = render
    }
    
    func dependency(with viewController: SearchPostsDisplayable?) -> SearchPostsActionable {
        SearchPostsAction(
            presenter: dependency(with: viewController),
            postProvider: core.dependency(),
            mediaProvider: core.dependency()
        )
    }
    
    func dependency(with viewController: SearchPostsDisplayable?) -> SearchPostsPresentable {
        SearchPostsPresenter(viewController: viewController)
    }
    
    func dependency(with viewController: UIViewController?) -> SearchPostsRenderable {
        SearchPostsRender(
            render: render,
            viewController: viewController
        )
    }
    
    func dependency() -> ConstantsType {
        core.dependency()
    }
    
    func dependency() -> Theme {
        core.dependency()
    }
}