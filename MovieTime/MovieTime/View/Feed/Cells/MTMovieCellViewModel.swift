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
        return movieName + "(" + date + ")"
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
        return ""
    }

    private let movie: MTModelMovieDBMovie

    init(movie: MTModelMovieDBMovie) {
        self.movie = movie
    }
}
