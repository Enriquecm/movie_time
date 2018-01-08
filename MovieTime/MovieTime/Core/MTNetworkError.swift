//
//  MTNetworkError.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

final class MTNetworkError: Error {
    var statusCode: Int
    var message: String

    init(code: Int = -1, message: String? = nil) {
        self.statusCode = code
        self.message = message ?? "An unknown error happened."
    }

    static func unknownError() -> MTNetworkError {
        return MTNetworkError()
    }

    static func parseError() -> MTNetworkError {
        return MTNetworkError(code: -1001, message: "Internal server error.")
    }

    static func noConnection() -> MTNetworkError {
        return MTNetworkError(code: -1001, message: "No internet connection.")
    }

    static func timedOut() -> MTNetworkError {
        return MTNetworkError(message: "Service timeout.")
    }

    static func unexpectedError(message: String?) -> MTNetworkError {
        return MTNetworkError(message: message)
    }
}

