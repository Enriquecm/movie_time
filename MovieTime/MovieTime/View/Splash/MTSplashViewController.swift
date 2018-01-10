//
//  MTSplashViewController.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

class MTSplashViewController: MTViewController {

    // MARK: Outlets
    @IBOutlet weak var viewIcon: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView! {
        didSet {
            rotateView(view: imageViewIcon)
        }
    }

    // MARK: Properties
    private lazy var viewModel: MTSplashViewModel = {
        return baseViewModel as? MTSplashViewModel ?? MTSplashViewModel()
    }()

    private let kRotationAnimationKey = "com.choynowski.kRotationAnimationKey"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }

    deinit {
        stopRotatingView(view: imageViewIcon)
    }

    private func setupUI() {

    }

    private func setupViewModel() {
        viewModel.onInformationLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.showMainViewController()
            }
        }
        viewModel.onInformationFailed = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showTryAgainMessage(withTitle: "Failed to load initial information.", message: errorMessage)
            }
        }
        viewModel.loadInformation()
    }

    private func showMainViewController() {
        MTRouter.shared.goToNextScreen()
    }

    private func showTryAgainMessage(withTitle title: String, message: String?) {
        let action = UIAlertAction(title: "Try again!", style: .default, handler: { [weak self] (alertAction) in
            self?.viewModel.loadInformation()
        })
        showAlert(with: title, message: message, action: action)
    }

    // MARK: Rotation methods
    private func rotateView(view: UIView, duration: Double = 1) {
        guard view.layer.animation(forKey: kRotationAnimationKey) == nil else { return }

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Float.pi * 2
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = Float.infinity

        view.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
    }

    func stopRotatingView(view: UIView) {
        guard view.layer.animation(forKey: kRotationAnimationKey) != nil else { return }
        view.layer.removeAnimation(forKey: kRotationAnimationKey)
    }
}
