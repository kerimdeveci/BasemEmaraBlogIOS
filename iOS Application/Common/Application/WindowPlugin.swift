//
//  BootApplicationService.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-17.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import UIKit
import SwiftyPress
import ZamzamCore

final class WindowPlugin: ApplicationPlugin {
    
    // MARK: - Dependencies
    
    @Inject private var scenes: SceneModuleType
    
    // MARK: - State
    
    private var window: UIWindow?
    
    // MARK: - Lifecycle
    
    init(for window: UIWindow?) {
        self.window = window
    }
}

extension WindowPlugin {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Handled in `SceneDelegate` for iOS 13+
        if #available(iOS 13.0, *) {} else {
            window = UIWindow(frame: UIScreen.main.bounds).with {
                $0.rootViewController = scenes.startMain()
                $0.makeKeyAndVisible()
            }
        }
        
        return true
    }
}
