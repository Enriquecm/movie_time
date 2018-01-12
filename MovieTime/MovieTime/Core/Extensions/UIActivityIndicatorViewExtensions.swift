//
//  UIActivityIndicatorViewExtensions.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 12/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView: MTLoadingProtocol {

    func startLoading() {
        startAnimating()
    }

    func stopLoading() {
        stopAnimating()
    }
}
