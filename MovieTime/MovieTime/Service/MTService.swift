//
//  MTService.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import UIKit

typealias MTHTTPHeaders = [String: String]
typealias MTRequestResponse = ((MTResponse) -> Void)?
typealias MTImageRequestResponse = ((UIImage?, MTNetworkError?) -> Void)?

protocol MTServiceProtocol: class {

    func requestHttp(url: MTURLConvertible?, method: MTHTTPMethod, parameters: MTParameters?, encoding: MTParameterEncoding, headers: MTHTTPHeaders?, completion: MTRequestResponse)
    func loadImage(baseURL: MTURLConvertible?, endpoint: String?, completion: MTImageRequestResponse)
}

final class MTService: MTServiceProtocol {

    func requestHttp(url: MTURLConvertible?, method: MTHTTPMethod = .get, parameters: MTParameters? = nil, encoding: MTParameterEncoding = URLEncoding.customQueryString, headers: MTHTTPHeaders? = nil, completion: MTRequestResponse) {

        MTLog(from: "REQUEST", title: "Endpoint: \(url ?? "NO URL")")
        MTLog(from: "REQUEST", title: "Method: \(method)")
        MTLog(from: "REQUEST", title: "Body: \(parameters?.description ?? "No parameters")")

        guard let strURL = url?.asString() else {
            let error = MTNetworkError(message: "Missing information.")
            let mtResponse = MTResponse(statusCode: 500, data: nil, error: error)
            MTLog(from: "REQ-ERROR", title: "\(error.message)")
            completion?(mtResponse)
            return
        }

        guard let req = self.req(url: strURL, method: method, parameters: parameters, encoding: encoding, headers: headers) else {
            let error = MTNetworkError.unexpectedError(message: "The service is unavailable.")
            let mtResponse = MTResponse(statusCode: 500, data: nil, error: error)

            MTLog(from: "REQ-ERROR", title: "\(error.message)")
            completion?(mtResponse)
            return
        }

        perform(request: req, completion: completion)
    }

    private func req(url: String, method: MTHTTPMethod = .get, parameters: MTParameters? = nil, encoding: MTParameterEncoding, headers: MTHTTPHeaders? = nil) -> URLRequest? {

        guard let url = encoding.urlEncode(url, method: method, with: parameters) else { return nil }

        // URL
        var originalRequest = URLRequest(url: url)

        // Method
        originalRequest.httpMethod = method.rawValue

        // Headers
        for (key, value) in (headers ?? [:]) {
            originalRequest.addValue(value, forHTTPHeaderField: key)
        }

        // Encoding
        let encodedURLRequest = encoding.encode(originalRequest, with: parameters)

        return encodedURLRequest
    }

    private func perform(request: URLRequest, completion: MTRequestResponse) {
        MTLog(from: "REQUEST", title: "URL: \(request.url?.absoluteString ?? "NO URL!")")

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in

            let parsedError = self.parseError(data, response, error)

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            let mtResponse = MTResponse(statusCode: statusCode, data: data, error: parsedError, request: request, response: response)

            if let data = mtResponse.data {
                MTLog(from: "RESPONSE", title: "Data: \(String(data: data, encoding: .utf8) ?? "")")
            }

            if let error = mtResponse.error {
                MTLog(from: "REQ-ERROR", title: "\(error.message)")
            }
            completion?(mtResponse)
            }.resume()
    }

    private func parseError(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> MTNetworkError? {
        if let error = errorFrom(error) {
            return error
        }
        if let responseError = errorFrom(response, data) {
            return responseError
        }

        return nil
    }

    private func errorFrom(_ error: Error?) -> MTNetworkError? {
        guard let nsError = error as NSError? else {
            return nil
        }

        let systemErrors = [NSURLErrorNotConnectedToInternet,
                            NSURLErrorUnknown]

        if systemErrors.contains(nsError.code) {
            return MTNetworkError.noConnection()
        } else if NSURLErrorTimedOut == nsError.code {
            return MTNetworkError.timedOut()
        } else {
            return MTNetworkError.unexpectedError(message: nsError.localizedDescription)
        }
    }

    private func errorFrom(_ response: URLResponse?, _ data: Data?) -> MTNetworkError? {
        let range: ClosedRange<Int> = 200...299
        guard let response = response as? HTTPURLResponse,
            !range.contains(response.statusCode) else {
                return nil
        }

        if let error = errorFrom(data) {
            return error
        } else {
            return MTNetworkError.unexpectedError(message: "A service error happened.")
        }
    }

    private func errorFrom(_ data: Data?) -> MTNetworkError? {
        guard let data = data,
            let errorJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any],
            let responseSuccess = errorJSON?["success"] as? Bool,
            let errorMessage = errorJSON?["status_message"] as? String,
            let errorcode = errorJSON?["status_code"] as? Int else {
                return nil
        }

        guard responseSuccess else {
            return MTNetworkError(code: errorcode, message: errorMessage)
        }
        return nil
    }

    func loadImage(baseURL: MTURLConvertible?, endpoint: String? = nil, completion: MTImageRequestResponse) {
        MTLog(from: "REQUEST", title: "Image URL: \(baseURL ?? "No base URL")")

        guard var url = baseURL?.asString() else {
            let error = MTNetworkError(message: "Missing information.")
            MTLog(from: "REQ-ERROR", title: "\(error.message)")
            completion?(nil, error)
            return
        }
        if let endpoint = endpoint {
            url += endpoint
        }
        loadImage(url: url, completion: completion)
    }

    private func loadImage(url: String, completion: MTImageRequestResponse) {

        requestHttp(url: url, encoding: URLEncoding.default) { (response) in
            if let data = response.data, response.error == nil {
                let image = UIImage(data: data)
                completion?(image, nil)
            } else {
                completion?(nil, response.error)
            }
        }
    }
}

protocol MTURLConvertible {
    func asString() -> String
    func asURL() throws -> URL
}

extension String: MTURLConvertible {

    func asString() -> String {
        return self
    }

    func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw MTNetworkError.unexpectedError(message: "A service error happened.")
        }
        return url
    }
}

extension URL: MTURLConvertible {

    func asString() -> String {
        return self.absoluteString
    }

    func asURL() throws -> URL {
        return self
    }
}
