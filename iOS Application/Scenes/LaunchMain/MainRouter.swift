//
//  MainSplitRouter.swift
//  BasemEmara iOS
//
//  Created by Basem Emara on 2019-12-08.
//

import UIKit
import ZamzamUI

struct MainRouter: MainRouterType {
    private let render: SceneRenderType
    
    init(render: SceneRenderType) {
        self.render = render
    }
}

extension MainRouter {
    
    func home() -> UIViewController {
        render.home()
    }
    
    func showPost(for id: Int) {
        guard let topViewController = UIWindow.current?.topViewController else {
            return
        }
        
        // Load post in place or show in new controller
        (topViewController as? ShowPostLoadable)?.loadData(for: id)
            ?? topViewController.show(render.showPost(for: id), dismiss: true)
    }
}
