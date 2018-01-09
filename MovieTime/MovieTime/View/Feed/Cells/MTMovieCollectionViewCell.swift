//
//  MTMovieCollectionViewCell.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

class MTMovieCollectionViewCell: UICollectionViewCell, MTViewModelSetupCellProtocol {

    // MARK: Static Properties
    static let informationHeight: CGFloat = 50.0

    // MARK: Outlets
    @IBOutlet weak var viewBackground: UIView!

    // MARK: Image outlets
    @IBOutlet weak var viewImageBackground: UIView!
    @IBOutlet weak var imageViewFrame: UIImageView!
    @IBOutlet weak var imageViewMovie: UIImageView!

    // MARK: Info outlets
    @IBOutlet weak var viewInfoBackground: UIView!
    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var imageViewInfoFrame: UIImageView!
    @IBOutlet weak var labelMovieGenres: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        viewBackground.layer.shadowRadius = 1.0
        viewBackground.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewBackground.layer.shadowOpacity = 0.7
    }

    func setup(withViewModel viewModel: MTMovieCellViewModel?) {
        // TODO: 
    }
}
