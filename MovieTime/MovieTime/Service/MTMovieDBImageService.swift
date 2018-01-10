//
//  MTMovieDBImageService.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

protocol MTMovieDBServiceImageProtocol: class {
    init(service: MTServiceProtocol, helper: MTServiceHelperProtocol, config: MTModelMovieDBConfiguration)

    func loadBackdropImage(filePath: String, completion: ((Data?, MTNetworkError?) -> Void)?)
    func loadLogoImage(filePath: String, completion: ((Data?, MTNetworkError?) -> Void)?)
    func loadPosterImage(filePath: String, completion: ((Data?, MTNetworkError?) -> Void)?)
    func loadProfileImage(filePath: String, completion: ((Data?, MTNetworkError?) -> Void)?)
}

final class MTMovieDBImageService: MTMovieDBServiceImageProtocol {

    private var configuration: MTModelMovieDBConfiguration
    private let currentService: MTServiceProtocol
    private let serviceHelper: MTServiceHelperProtocol

    private var urlImage: URL? {
        guard let baseImageURL = configuration.images?.base_url else { return nil }
        return URL(string: baseImageURL)
    }

    init(service: MTServiceProtocol = MTService(), helper: MTServiceHelperProtocol = MTServiceHelper(), config: MTModelMovieDBConfiguration) {
        currentService = service
        serviceHelper = helper
        configuration = config
    }

    func loadBackdropImage(filePath: String, completion: ((Data?, MTNetworkError?) -> Void)?) {
        let fileSize = configuration.images?.backdrop_sizes?.first ?? "original"
        let url = urlImage?.appendingPathComponent(fileSize).appendingPathComponent(filePath)

        executeRequest(url: url, method: .get, completion: completion)
    }

    func loadLogoImage(filePath: String, completion: ((Data?, MTNetworkError?) -> Void)?) {
        let fileSize = configuration.images?.logo_sizes?.first ?? "original"
        let url = urlImage?.appendingPathComponent(fileSize).appendingPathComponent(filePath)

        executeRequest(url: url, method: .get, completion: completion)
    }

    func loadPosterImage(filePath: String, completion: ((Data?, MTNetworkError?) -> Void)?) {
        let fileSize = configuration.images?.poster_sizes?.first ?? "original"
        let url = urlImage?.appendingPathComponent(fileSize).appendingPathComponent(filePath)

        executeRequest(url: url, method: .get, completion: completion)
    }

    func loadProfileImage(filePath: String, completion: ((Data?, MTNetworkError?) -> Void)?) {
        let fileSize = configuration.images?.profile_sizes?.first ?? "original"
        let url = urlImage?.appendingPathComponent(fileSize).appendingPathComponent(filePath)

        executeRequest(url: url, method: .get, completion: completion)
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
