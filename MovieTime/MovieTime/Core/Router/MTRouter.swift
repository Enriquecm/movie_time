//
//  MTRouter.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

enum MTAppState {
    case splashScreen
    case feed
}

final class MTRouter: NSObject {

    static let shared = MTRouter()

    private var currentState = MTAppState.splashScreen

    private func changeRootViewController(forIdentifier identifier: String, storyboardName: String) {

        guard let appDelegate = UIApplication.shared.delegate,
            let window = appDelegate.window else { return }

        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let desiredViewController = storyboard.instantiateViewController(withIdentifier: identifier)

        if let snapshot: UIView = (window?.snapshotView(afterScreenUpdates: true)) {

            desiredViewController.view.addSubview(snapshot)
            window?.rootViewController = desiredViewController

            UIView.animate(withDuration: 0.3, animations: {() in
                snapshot.layer.opacity = 0
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { (finished: Bool) in
                if finished {
                    snapshot.removeFromSuperview()
                }
            })
        }
    }

    func goToNextScreen() {
        switch currentState {
        case .splashScreen:
            MTLog(from: "ROUTER", title: "SplashScreen")
            goToState(.feed)
        case .feed:
            MTLog(from: "ROUTER", title: "FEED")
        }
    }

    func goToState(_ state: MTAppState) {
        currentState = state
        switch state {
        case .splashScreen:
            changeRootViewController(forIdentifier: MTIdentifiers.RootViewController.splash, storyboardName: MTIdentifiers.Storyboard.Main.name)
        case .feed:
            changeRootViewController(forIdentifier: MTIdentifiers.RootViewController.feedNavigation, storyboardName: MTIdentifiers.Storyboard.Main.name)
        }
    }
}
