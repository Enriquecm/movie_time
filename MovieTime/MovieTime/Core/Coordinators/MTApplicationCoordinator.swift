//
//  MTApplicationCoordinator.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

class MTApplicationCoordinator {

    static let shared = MTApplicationCoordinator()

    lazy var imageService: MTMovieDBServiceImageProtocol? = {
        guard let configuration: MTModelMovieDBConfiguration = loadSavedModel(forKey: MTIdentifiers.PersistencyKeys.configuration) else {
            return nil
        }

        let service = MTMovieDBImageService(config: configuration)
        return service
    }()

    var hasInitialInformation: Bool {
        let hasConfig = configuration != nil
        let hasGenres = genres != nil
        return hasConfig && hasGenres
    }

    var configuration: MTModelMovieDBConfiguration? {
        return loadSavedModel(forKey: MTIdentifiers.PersistencyKeys.configuration)
    }

    var genres: MTModelMovieDBGenresList? {
        return loadSavedModel(forKey: MTIdentifiers.PersistencyKeys.genres)
    }

    func saveConfiguration(data: Data) {
        MTPersistencyCoorinator.set(data, forKey: MTIdentifiers.PersistencyKeys.configuration)
    }

    func saveGenres(data: Data) {
        MTPersistencyCoorinator.set(data, forKey: MTIdentifiers.PersistencyKeys.genres)
    }

    private func loadSavedModel<T>(forKey key: String) -> T? where T: Decodable {
        guard let data = MTPersistencyCoorinator.valueForKey(key) as? Data else {
            return nil
        }

        let parser = MTParser<T>()
        let model = try? parser.parse(from: data, with: parser.dateDecodingStrategy())
        return model
    }
}
