//
//  MTModelMovieDBConfiguration.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

struct MTModelMovieDBConfiguration: Codable {

    var images: MTModelMovieDBConfigurationImages?
}

struct MTModelMovieDBConfigurationImages: Codable {

    var base_url: String?
    var secure_base_url: String?
    var backdrop_sizes: [String]?
    var logo_sizes: [String]?
    var poster_sizes: [String]?
    var profile_sizes: [String]?
    var still_sizes: [String]?
}

/*
{
    "images": {
        "base_url": "http://image.tmdb.org/t/p/",
        "secure_base_url": "https://image.tmdb.org/t/p/",
        "backdrop_sizes": [
            "w300",
            "w780",
            "w1280",
            "original"
        ],
        "logo_sizes": [...],
        "poster_sizes": [...],
        "profile_sizes": [...],
        "still_sizes": [...]
    },
    "change_keys": [...]
}
*/
