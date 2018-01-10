//
//  ViewController.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 05/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

class MTViewController: UIViewController {

    // MARK: Properties
    private(set) var baseViewModel: MTViewModel?
    class var identifier: String {
        return String(describing: self)
    }

    class var storyboardName: String {
        return MTIdentifiers.Storyboard.Main.name
    }

    func showAlert(with title: String?, message: String?, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private class func initializeViewController() -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }

    class func initializeViewController(viewModel: MTViewModel, withNavigation: Bool = false) -> UIViewController {
        let vc = initializeViewController()

        if let vc = vc as? MTViewController {
            vc.baseViewModel = viewModel
        }

        if withNavigation {
            let navigation = UINavigationController(rootViewController: vc)
            return navigation
        } else {
            return vc
        }
    }

}
