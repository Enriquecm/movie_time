//
//  MTSplashViewModel.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

class MTSplashViewModel: MTViewModel {

    // MARK: Reactors
    var onInformationLoaded: (() -> Void)?
    var onInformationFailed: ((String?) -> Void)?

    // MARK: Properties
    internal let movieDbService: MTMovieDBServiceProtocol

    init(service: MTMovieDBServiceProtocol = MTMovieDBService()) {
        self.movieDbService = service
    }

    func loadInformation() {
        if MTApplicationCoordinator.shared.hasInitialInformation {
            onInformationLoaded?()
        } else {
            loadConfiguration()
        }
    }

    private func loadConfiguration() {
        movieDbService.requestConfiguration { [weak self] (data, error) in
            guard let data = data, error == nil else {
                self?.onInformationFailed?(error?.message)
                return
            }

            // Parse Configuration
            let configParser = MTParser<MTModelMovieDBConfiguration>()
            let configuration = try? configParser.parse(from: data, with: configParser.dateDecodingStrategy())
            if configuration != nil {
                // Save Configuration
                MTApplicationCoordinator.shared.saveConfiguration(data: data)

                // Load Genres
                self?.loadGenres()
            } else {
                self?.onInformationFailed?(MTNetworkError.parseError().message)
            }
        }
    }

    private func loadGenres() {
        movieDbService.requestConfiguration { [weak self] (data, error) in
            guard let data = data, error == nil else {
                self?.onInformationFailed?(error?.message)
                return
            }

            // Parse Genres
            let genresParser = MTParser<MTModelMovieDBConfiguration>()
            let genres = try? genresParser.parse(from: data, with: genresParser.dateDecodingStrategy())
            if genres != nil {
                // Save Genres
                MTApplicationCoordinator.shared.saveGenres(data: data)

                // Information Loaded
                self?.onInformationLoaded?()
            } else {
                self?.onInformationFailed?(MTNetworkError.parseError().message)
            }
        }
    }
}
