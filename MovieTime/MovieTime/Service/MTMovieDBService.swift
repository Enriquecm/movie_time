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

    func requestConfiguration(completion: ((Data?, MTNetworkError?) -> Void)?)
    func requestGenresList(completion: ((Data?, MTNetworkError?) -> Void)?)
    func requestUpcomingMovies(forPage page: Int, completion: ((Data?, MTNetworkError?) -> Void)?)
    func requestMovieDetail(forId movieId: Int, completion: ((Data?, MTNetworkError?) -> Void)?)
}

final class MTMovieDBService: MTMovieDBServiceProtocol {

    private let urlServer = URL(string: "https://api.themoviedb.org/3")
    private let currentService: MTServiceProtocol
    private let serviceHelper: MTServiceHelperProtocol

    private let apiKey = "1f54bd990f1cdfb230adb312546d765d"
    private let language = "en-US"

    init(service: MTServiceProtocol = MTService(), helper: MTServiceHelperProtocol = MTServiceHelper()) {
        currentService = service
        serviceHelper = helper
    }

    func requestConfiguration(completion: ((Data?, MTNetworkError?) -> Void)?) {

        let endpoint = "/configuration"
        let parameters: MTParameters = ["api_key": apiKey,
                                        "language": language]
        let url = urlServer?.appendingPathComponent(endpoint)

        executeRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }

    func requestGenresList(completion: ((Data?, MTNetworkError?) -> Void)?) {

        let endpoint = "/genre/movie/list"
        let parameters: MTParameters = ["api_key": apiKey,
                                        "language": language]
        let url = urlServer?.appendingPathComponent(endpoint)

        executeRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }

    func requestUpcomingMovies(forPage page: Int = 1, completion: ((Data?, MTNetworkError?) -> Void)?) {

        let endpoint = "/movie/upcoming"
        let parameters: MTParameters = ["api_key": apiKey,
                                        "language": language,
                                        "page": page]
        let url = urlServer?.appendingPathComponent(endpoint)

        executeRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }

    func requestMovieDetail(forId movieId: Int, completion: ((Data?, MTNetworkError?) -> Void)?) {

        let endpoint = "/movie/\(movieId)"
        let parameters: MTParameters = ["api_key": apiKey,
                                        "language": language]
        let url = urlServer?.appendingPathComponent(endpoint)

        executeRequest(url: url, method: .get, parameters: parameters, completion: completion)
    }

    fileprivate func executeRequest(url: URL?, method: MTHTTPMethod, parameters: MTParameters? = nil, headers: MTHTTPHeaders? = nil, completion: ((Data?, MTNetworkError?) -> Void)?) {

        currentService.requestHttp(url: url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers) { response in

            guard let data = response.data, response.error == nil else {
                completion?(nil, response.error)
                return
            }

            completion?(data, nil)
        }
    }
}
