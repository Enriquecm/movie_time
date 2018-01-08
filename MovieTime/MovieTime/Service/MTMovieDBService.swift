//
//  MTMovieDBService.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

protocol MTMovieDBServiceProtocol: class {
    init(service: MTServiceProtocol, helper: MTServiceHelperProtocol)

    func requestUpcomingMovies(forPage page: Int, completion: ((Data?, MTNetworkError?) -> Void)?)
}

final class MTMovieDBService: MTMovieDBServiceProtocol {

    private let urlServer = URL(string: "https://api.themoviedb.org/3")
    private let currentService: MTServiceProtocol
    private let serviceHelper: MTServiceHelperProtocol

    init(service: MTServiceProtocol = MTService(), helper: MTServiceHelperProtocol = MTServiceHelper()) {
        currentService = service
        serviceHelper = helper
    }

    func requestUpcomingMovies(forPage page: Int = 1, completion: ((Data?, MTNetworkError?) -> Void)?) {
        let parameters: MTParameters = ["api_key": "1f54bd990f1cdfb230adb312546d765d",
                                        "language": "en-US",
                                        "page": page]
        let headers = ["Content-Type": "application/json"]
        let endpoint = "/movie/upcoming"
        let url = urlServer?.appendingPathComponent(endpoint)

        currentService.requestHttp(url: url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers) { response in

            guard let data = response.data, response.error == nil else {
                completion?(nil, response.error)
                return
            }

            completion?(data, nil)
        }
    }
}
