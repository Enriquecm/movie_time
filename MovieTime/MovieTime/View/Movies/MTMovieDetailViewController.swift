//
//  MTMovieDetailViewController.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 11/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

class MTMovieDetailViewController: MTViewController {

    // MARK: Outlets
    @IBOutlet weak var imageViewBackdrop: UIImageView!
    @IBOutlet weak var activityIndicatorBackdrop: UIActivityIndicatorView!
    @IBOutlet weak var imageViewPoster: UIImageView!

    @IBOutlet weak var labelMovieName: UILabel!
    @IBOutlet weak var labelMovieGenres: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!

    @IBOutlet weak var labelMovieDuration: UILabel!
    @IBOutlet weak var labelReleaseDate: UILabel!

    @IBOutlet weak var textViewOverview: UITextView!

    // MARK: Properties
    override class var storyboardName: String {
        return MTIdentifiers.Storyboard.Movie.name
    }

    fileprivate var viewModel: MTMovieViewModel? {
        return baseViewModel as? MTMovieViewModel
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
    }

    private func setupUI() {
        // Images
        imageViewBackdrop.loadBackdropImage(filePath: viewModel?.backdropPath, loadingView: activityIndicatorBackdrop)
        imageViewPoster.loadPosterImage(filePath: viewModel?.posterPath)

        // Info
        labelMovieName.text = viewModel?.title
        labelMovieGenres.text = viewModel?.genres(separator: " | ", finalSeparator: " | ")
        labelScore.text = viewModel?.movieScore
        labelLanguage.text = viewModel?.movieLanguage
        labelMovieDuration.text = viewModel?.movieDuration
        labelReleaseDate.text = viewModel?.releaseDate?.shortDateFormat()

        textViewOverview.text = viewModel?.movieOverview
    }

    private func setupViewModel() {
        viewModel?.onInformationLoaded = { [weak self] _ in
            DispatchQueue.main.async {
                self?.setupUI()
            }
        }

        viewModel?.onInformationFailed = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                self?.showAlert(with: "Failed to load movie information.", message: errorMessage, action: action)
            }
        }
        viewModel?.loadMoreInformation()
    }

    // MARK: Actions
    @IBAction func buttonClosePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
