//
//  MTModelMovieDBMovie.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 09/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

struct MTModelMovieDBMovie: Codable {

    var id: Int?
    var video: Bool?
    var vote_average: Float?
    var title: String?
    var popularity: Float?
    var poster_path: String?
    var original_language: String?
    var original_title: String?
    var genre_ids: [Int]?
    var backdrop_path: String?
    var release_date: Date?

    var overview: String?
    var runtime: Int?
}

// Sample Data
/*
{
    "vote_count": 400,
    "id": 0000,
    "video": false,
    "vote_average": 8.1,
    "title": "...",
    "popularity": 426.145609,
    "poster_path": "/....jpg",
    "original_language": "en",
    "original_title": "...",
    "genre_ids": [
        00,
        000,
        0000
    ],
    "backdrop_path": "/....jpg",
    "adult": false,
    "overview": "...",
    "release_date": "2017-12-20"
},
*/
