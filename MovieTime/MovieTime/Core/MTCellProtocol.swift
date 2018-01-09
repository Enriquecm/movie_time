//
//  MTCellProtocol.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 09/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

protocol MTCellProtocol: class {
    static var identifier: String { get }
}

extension MTCellProtocol where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension MTCellProtocol where Self: UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension MTCellProtocol where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

protocol MTSetupCellProtocol: MTCellProtocol {
    associatedtype ModelType

    func setup(with model: ModelType?)
}

protocol MTViewModelSetupCellProtocol: MTCellProtocol {
    associatedtype ViewModelType: MTViewModel

    func setup(withViewModel viewModel: ViewModelType?)
}
