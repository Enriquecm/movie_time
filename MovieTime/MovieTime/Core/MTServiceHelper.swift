//
//  MTServiceHelper.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

protocol MTServiceHelperProtocol {
    func buildURL(for baseURL: URL?, pathComponent: String, and parameters: MTParameters?...) -> URL?
}

struct MTServiceHelper: MTServiceHelperProtocol {

    func buildURL(for baseURL: URL?, pathComponent: String, and parameters: MTParameters?...) -> URL? {
        guard let url = baseURL?.appendingPathComponent(pathComponent) else { return nil }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)

        if !parameters.isEmpty {
            var queryItems: [URLQueryItem] = components?.queryItems ??  []
            for params in parameters {
                queryItems.append(contentsOf: buildQueryItems(parameters: params))
            }
            components?.queryItems = queryItems
        }
        return components?.url
    }

    private func buildQueryItems(parameters: MTParameters?) -> [URLQueryItem] {
        guard let parameters = parameters else { return [] }

        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {

            let queryName = String(describing: key)
            var queryValue = ""

            if let array = value as? [Any] {

                // For array objects
                for (_, arrayValue) in array.enumerated() {
                    let queryArrayValue = String(describing: arrayValue)
                    queryItems.append(URLQueryItem(name: queryName, value: queryArrayValue))
                }
            } else if !(value is NSNull) {

                // For any objects
                queryValue = String(describing: value)
                queryItems.append(URLQueryItem(name: queryName, value: queryValue))
            }
        }
        return queryItems
    }
}
