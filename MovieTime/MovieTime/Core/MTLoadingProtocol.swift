//
//  MTLoadingProtocol.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 12/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

protocol MTLoadingProtocol: class {

    func startLoading()
    func stopLoading()
    func loadingDidChanged(message: String)
}

extension MTLoadingProtocol {
    func loadingDidChanged(message: String) { }
}
