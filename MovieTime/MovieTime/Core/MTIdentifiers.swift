//
//  MTIdentifiers.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

struct MTIdentifiers {

    struct Storyboard {
        struct Main {
            static let name = "Main"
        }

        struct Movie {
            static let name = "Movie"
        }

        struct Settings {
            static let name = "Settings"
        }
    }

    struct RootViewController {
        static let splash = "MTSplashViewController"
        static let feedNavigation = "MTMoviesFeedNavigationController"
    }

    struct PersistencyKeys {
        static let configuration = "MTConfigurationKey"
        static let genres = "MTGenresKey"
    }
}
