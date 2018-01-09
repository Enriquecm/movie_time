//
//  MTMoviesFeedViewModel.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

final class MTMoviesFeedViewModel: MTViewModel {

    // MARK: Properties
    let title = "Upcoming Movies"
    var isDeviceLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }

    private var movies: [AnyObject]? {
        didSet {
            var viewModels = [MTMovieCellViewModel]()
            // TODO:
//            movies?.forEach({ viewModels.append(MTMoviesFeedViewModel(movie: $0)) })
            dataSource = viewModels
        }
    }

    private(set) var dataSource: [MTMovieCellViewModel] = [] {
        didSet {
            onDataSourceChanged?()
        }
    }

    private var currentPage = 1

    // MARK: Reactors
    var onDataSourceChanged: (() -> Void)?
    var onDataSourceFailed: ((Error?) -> Void)?
    var onMovieSelected: ((MTMovieCellViewModel) -> Void)?

    internal let movieDbService: MTMovieDBServiceProtocol

    init(service: MTMovieDBServiceProtocol = MTMovieDBService()) {
        self.movieDbService = service
    }

    func loadFeed() {
        // TODO:
    }

    // MARK: Data source methods
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItemsInSection(for section: Int) -> Int {
        return dataSource.count
    }

    func identifier(for indexPath: IndexPath) -> String {
        return MTMovieCollectionViewCell.identifier
    }

    func data(for indexPath: IndexPath) -> MTMovieCellViewModel? {
        let row = indexPath.row
        guard row < dataSource.count else { return nil }
        return dataSource[row]
    }

    func didSelectItem(at indexPath: IndexPath) {
        guard let movie = data(for: indexPath) else { return }
        onMovieSelected?(movie)
    }
}
