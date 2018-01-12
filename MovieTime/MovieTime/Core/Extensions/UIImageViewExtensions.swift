//
//  UIImageViewExtensions.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

extension UIImageView {

    func loadBackdropImage(filePath: String?, placeholderImage: UIImage? = nil, loadingView: MTLoadingProtocol? = nil, completion: MTImageRequestResponse = nil) {
        guard let filePath = filePath, let service = MTApplicationCoordinator.shared.imageService else {
            // TODO: Handler this error
            completion?(nil, nil)
            return 
        }
        loadingView?.startLoading()
        service.loadBackdropImage(filePath: filePath) { [weak self] (data, error) in
            DispatchQueue.main.async {
                loadingView?.stopLoading()
                if let data = data, error == nil {
                    self?.image = UIImage(data: data)
                } else {
                    self?.image = nil
                }

                completion?(self?.image, error)
            }
        }
    }


    func loadLogoImage(filePath: String?, placeholderImage: UIImage? = nil, loadingView: MTLoadingProtocol? = nil, completion: MTImageRequestResponse = nil) {
        guard let filePath = filePath, let service = MTApplicationCoordinator.shared.imageService else {
            // TODO: Handler this error
            completion?(nil, nil)
            return
        }
        loadingView?.startLoading()
        service.loadLogoImage(filePath: filePath) { [weak self] (data, error) in
            DispatchQueue.main.async {
                loadingView?.stopLoading()
                if let data = data, error == nil {
                    self?.image = UIImage(data: data)
                } else {
                    self?.image = nil
                }

                completion?(self?.image, error)
            }
        }
    }

    func loadPosterImage(filePath: String?, placeholderImage: UIImage? = nil, loadingView: MTLoadingProtocol? = nil, completion: MTImageRequestResponse = nil) {
        guard let filePath = filePath, let service = MTApplicationCoordinator.shared.imageService else {
            // TODO: Handler this error
            completion?(nil, nil)
            return
        }
        loadingView?.startLoading()
        service.loadPosterImage(filePath: filePath) { [weak self] (data, error) in
            DispatchQueue.main.async {
                loadingView?.stopLoading()
                if let data = data, error == nil {
                    self?.image = UIImage(data: data)
                } else {
                    self?.image = nil
                }

                completion?(self?.image, error)
            }
        }
    }

    func loadProfileImage(filePath: String?, placeholderImage: UIImage? = nil, loadingView: MTLoadingProtocol? = nil, completion: MTImageRequestResponse = nil) {
        guard let filePath = filePath, let service = MTApplicationCoordinator.shared.imageService else {
            // TODO: Handler this error
            completion?(nil, nil)
            return
        }
        loadingView?.startLoading()
        service.loadProfileImage(filePath: filePath) { [weak self] (data, error) in
            DispatchQueue.main.async {
                loadingView?.stopLoading()
                if let data = data, error == nil {
                    self?.image = UIImage(data: data)
                } else {
                    self?.image = nil
                }

                completion?(self?.image, error)
            }
        }
    }
}
