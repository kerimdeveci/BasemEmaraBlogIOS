//
//  AppConfiguration.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-21.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation
import SwiftyPress
import ZamzamCore

struct AppCore: SwiftyPressCore {
    
    private let environment: Environment = {
        #if DEBUG
        return .development
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }()
    
    func dependencyStore() -> ConstantsStore {
        ConstantsMemoryStore(
            environment: environment,
            itunesName: "basememara",
            itunesID: "1021806851",
            baseURL: {
                let string: String
                switch environment {
                case .development:
                    string = "https://basememara.com"
                case .staging:
                    string = "https://staging1.basememara.com"
                case .production:
                    string = "https://basememara.com"
                }
                
                guard let url = URL(string: string) else {
                    fatalError("Could not determine base URL of server.")
                }
                
                return url
            }(),
            baseREST: "wp-json/swiftypress/v5",
            wpREST: "wp-json/wp/v2",
            email: "contact@basememara.com",
            privacyURL: "https://basememara.com/privacy/?mobileembed=1",
            disclaimerURL: nil,
            styleSheet: "https://basememara.com/wp-content/themes/metro-pro/style.css",
            googleAnalyticsID: "UA-60131988-2",
            featuredCategoryID: 64,
            defaultFetchModifiedLimit: 25,
            taxonomies: ["category", "post_tag", "series"],
            postMetaKeys: ["_series_part"],
            minLogLevel: environment == .production ? .warning : .verbose
        )
    }
    
    func dependencyStore() -> PreferencesStore {
        PreferencesDefaultsStore(
            defaults: {
                UserDefaults(
                    suiteName: {
                        switch environment {
                        case .development:
                            return "group.io.zamzam.Basem-Emara-dev"
                        case .staging:
                            return "group.io.zamzam.Basem-Emara-staging"
                        case .production:
                            return "group.io.zamzam.Basem-Emara"
                        }
                    }()
                ) ?? .standard
            }()
        )
    }

    func dependency() -> SeedStore {
        SeedFileStore(
            forResource: "seed.json",
            inBundle: .main,
            jsonDecoder: dependency()
        )
    }
    
    func dependency() -> [LogStore] {
        let constants: ConstantsType = dependency()
        
        return [
            LogConsoleStore(
                minLevel: constants.environment == .production ? .none
                    : constants.minLogLevel
            ),
            LogOSStore(
                minLevel: constants.minLogLevel,
                subsystem: Bundle.main.bundleIdentifier ?? "BasemEmara",
                category: "Application"
            )
        ]
    }

    func dependency() -> Theme {
        AppTheme()
    }
}
