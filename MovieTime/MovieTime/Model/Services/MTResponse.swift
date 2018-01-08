//
//  MTResponse.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

final class MTResponse: CustomDebugStringConvertible, Equatable {

    let statusCode: Int
    let data: Data?
    var error: MTNetworkError?
    let request: URLRequest?
    let response: URLResponse?

    public init(statusCode: Int, data: Data?, error: MTNetworkError?, request: URLRequest? = nil, response: URLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.error = error
        self.request = request
        self.response = response
    }

    public var description: String {
        return "Status Code: \(statusCode), Data Length: \(data?.count ?? 0))"
    }

    public var debugDescription: String {
        return description
    }
}

func == (lhs: MTResponse, rhs: MTResponse) -> Bool {
    return lhs.statusCode == rhs.statusCode
        && lhs.data == rhs.data
        && lhs.response == rhs.response
}
