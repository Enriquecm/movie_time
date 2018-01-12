//
//  MTMovieCellViewModel.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

final class MTMovieViewModel: MTViewModel {

    // MARK: Reactors
    var onInformationLoaded: ((MTModelMovieDBMovie) -> Void)?
    var onInformationFailed: ((String?) -> Void)?

    // MARK: Properties
    var title: String {
        let date = releaseDate?.shortDateFormat() ?? "--/--/----"
        return movieName + " (" + date + ")"
    }

    var movieName: String {
        return movie.title ?? "--"
    }

    var posterPath: String? {
        return movie.poster_path
    }

    var backdropPath: String? {
        return movie.backdrop_path
    }

    var releaseDate: Date? {
        return movie.release_date
    }

    var movieScore: String {
        guard let score = movie.vote_average else { return "-" }
        return String(format: "%.1f", score)
    }

    var movieLanguage: String? {
        return movie.original_language?.uppercased()
    }

    var movieDuration: String? {
        guard let runtime = movie.runtime else { return "--:--" }
        return "\(runtime) min"
    }

    var movieOverview: String? {
        return movie.overview
    }

    private var movie: MTModelMovieDBMovie {
        didSet {
            onInformationLoaded?(movie)
        }
    }
    private let service: MTMovieDBServiceProtocol
    private(set) var genreList: [String] = []

    init(movie: MTModelMovieDBMovie, service: MTMovieDBServiceProtocol) {
        self.movie = movie
        self.service = service
        super.init()

        self.genreList = genreList(for: movie.genre_ids)
    }

    func loadMoreInformation() {
        guard let movieId = movie.id else {
            onInformationFailed?("Missing information!")
            return
        }
        service.requestMovieDetail(forId: movieId) { [weak self] (data, error) in
            guard let data = data, error == nil else {
                self?.onInformationFailed?(error?.message)
                return
            }

            // Parse Configuration
            let movieParser = MTParser<MTModelMovieDBMovie>()
            let movieLoaded = try? movieParser.parse(from: data, with: movieParser.dateDecodingStrategy())
            if let movieLoaded = movieLoaded {
                self?.movie = movieLoaded
            } else {
                self?.onInformationFailed?(MTNetworkError.parseError().message)
            }
        }
    }

    func genres(shrinkAt: Int = 0, separator: String = ", ", finalSeparator: String = " and ") -> String {
        return format(list: genreList, shrinkAt: shrinkAt, separator: separator, finalSeparator: finalSeparator)
    }

    private func genreList(for genresIds: [Int]?) -> [String] {
        var list = [String]()
        let savedGenres = MTApplicationCoordinator.shared.genresList?.genres
        for genreId in genresIds ?? [] {
            if let genreModel = savedGenres?.filter({ $0.id == genreId }).first,
                let name = genreModel.name {
                list.append(name)
            }
        }
        return list
    }

    private func format(list: [String], shrinkAt: Int = 0, separator: String = ", ", finalSeparator: String = " and ") -> String {

        var genresInformation = ""
        for (index, genre) in list.enumerated() {
            genresInformation += genre

            if shrinkAt > 0 && index == (shrinkAt - 1) && list.count > shrinkAt {
                genresInformation += "\(finalSeparator)"
                genresInformation += "+\(list.count - index)"
                break
            }

            if (index + 2) == list.count {
                genresInformation += " \(finalSeparator) "
            } else if (index + 1) != list.count {
                genresInformation += "\(separator)"
            }
        }
        return genresInformation
    }
}
