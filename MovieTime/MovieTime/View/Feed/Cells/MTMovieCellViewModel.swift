//
//  MTMovieCellViewModel.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

final class MTMovieCellViewModel: MTViewModel {

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

    var genres: String? {
        return loadGenresInformation(for: movie.genre_ids)
    }

    private let movie: MTModelMovieDBMovie

    init(movie: MTModelMovieDBMovie) {
        self.movie = movie
    }

    private func loadGenresInformation(for genresIds: [Int]?) -> String? {
        guard let genresIds = genresIds else { return nil }

        var genresList = [String]()
        let savedGenres = MTApplicationCoordinator.shared.genresList?.genres
        for genreId in genresIds {
            if let genreModel = savedGenres?.filter({ $0.id == genreId }).first,
                let name = genreModel.name {
                genresList.append(name)
            }
        }

        var genresInformation = ""
        for (index, genre) in genresList.enumerated() {
            genresInformation += genre

            if index == 1 && genresList.count > 2 {
                genresInformation += " and "
                genresInformation += "+\(genresList.count - index)"
                break
            }

            if (index + 2) == genresList.count {
                genresInformation += " and "
            } else if (index + 1) != genresList.count {
                genresInformation += ", "
            }
        }
        return genresInformation
    }
}
