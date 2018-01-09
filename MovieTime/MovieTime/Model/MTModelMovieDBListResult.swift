//
//  MTModelMovieDBListResult.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 09/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

struct MTModelMovieDBListResult: Codable {

    var page: Int?
    var total_results: Int?
    var total_pages: Int?
    var results: [MTModelMovieDBMovie]?
}

// Sample data
/*
{
    "results": [...],
    "page": 1,
    "total_results": 238,
    "dates": {
        "maximum": "2018-02-03",
        "minimum": "2018-01-07"
    },
    "total_pages": 12
}
*/
