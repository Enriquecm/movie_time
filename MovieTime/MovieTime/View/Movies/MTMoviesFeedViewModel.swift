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
    private var shouldLoadNextPage = false

    private var movies: [MTModelMovieDBMovie] = [] {
        didSet {
            var viewModels = [MTMovieViewModel]()
            movies.forEach({ viewModels.append(MTMovieViewModel(movie: $0, service: movieDbService)) })
            dataSource = viewModels
        }
    }

    private(set) var dataSource: [MTMovieViewModel] = [] {
        didSet {
            onDataSourceChanged?()
        }
    }

    private var currentPage = 1

    // MARK: Reactors
    var onDataSourceChanged: (() -> Void)?
    var onDataSourceFailed: ((String?) -> Void)?
    var onMovieSelected: ((MTMovieViewModel) -> Void)?

    internal let movieDbService: MTMovieDBServiceProtocol

    init(service: MTMovieDBServiceProtocol = MTMovieDBService()) {
        self.movieDbService = service
    }

    func loadFeed(forceRefresh: Bool = false) {
        movieDbService.requestUpcomingMovies(forPage: currentPage) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                self?.onDataSourceFailed?(error?.message)
                return
            }

            // Parse Movies
            let moviesParser = MTParser<MTModelMovieDBListResult>()
            let resultFeed = try? moviesParser.parse(from: data, with: moviesParser.dateDecodingStrategy())
            let moviesFeed = resultFeed?.results ?? []
            if forceRefresh {
                self?.movies = moviesFeed
            } else {
                self?.movies.append(contentsOf: moviesFeed)
            }

            if let page = resultFeed?.page, let totalPages = resultFeed?.total_pages {
                self?.shouldLoadNextPage = page < totalPages
            } else {
                self?.shouldLoadNextPage = false
            }
        }
    }

    func refreshFeed() {
        currentPage = 1
        loadFeed(forceRefresh: true)
    }

    func fetchNextPage() {
        currentPage += 1
        loadFeed()
    }

    func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldLoadNextPage else { return false }
        return indexPath.row == dataSource.count
    }

    // MARK: Data source methods
    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItemsInSection(for section: Int) -> Int {
        let items = dataSource.count
        return shouldLoadNextPage ? items + 1 : items
    }

    func identifier(for indexPath: IndexPath) -> String {
        if isLoadingIndexPath(indexPath) {
            return MTLoadingCollectionViewCell.identifier
        } else {
            return MTMovieCollectionViewCell.identifier
        }
    }

    func data(for indexPath: IndexPath) -> MTMovieViewModel? {
        guard !isLoadingIndexPath(indexPath) else { return nil }

        let row = indexPath.row
        guard row < dataSource.count else { return nil }
        return dataSource[row]
    }

    func didSelectItem(at indexPath: IndexPath) {
        guard !isLoadingIndexPath(indexPath) else { return }

        guard let movie = data(for: indexPath) else { return }
        onMovieSelected?(movie)
    }
}
