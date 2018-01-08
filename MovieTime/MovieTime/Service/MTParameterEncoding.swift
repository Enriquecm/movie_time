//
//  MTParameterEncoding.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

public enum MTHTTPMethod: String {
    case get     = "GET"
    case put     = "PUT"
    case post    = "POST"
    case delete  = "DELETE"
    case options = "OPTIONS"
}

public typealias MTParameters = [String: Any]

public enum Customize {
    case none, reflection
}

public protocol MTParameterEncoding {

    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - returns: The encoded request.
    func encode(_ urlRequest: URLRequest, with parameters: MTParameters?) -> URLRequest

    /// Created a URL by encoding parameters given a method
    ///
    /// - parameter url: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - returns: The encoded url.
    func urlEncode(_ url: String, method: MTHTTPMethod, with parameters: MTParameters?) -> URL?
}

// MARK: - URLEncoding

public struct URLEncoding: MTParameterEncoding {

    // MARK: Properties

    /// Returns a default `URLEncoding` instance.
    public static var `default`: URLEncoding { return URLEncoding() }

    public static var customQueryString: URLEncoding { return URLEncoding(customize: .reflection) }

    public let customize: Customize

    public init(customize: Customize = .none) {
        self.customize = customize
    }

    // MARK: Encoding

    public func urlEncode(_ url: String, method: MTHTTPMethod, with parameters: MTParameters?) -> URL? {
        var url = url
        if customize == .reflection {
            // Encodes parameters in URL
            if method.encodesParametersInURL() {
                url = url.reflectionEncode(parameters: parameters)
            }
        }

        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? url
        return URL(string: encodedURL)
    }

    public func encode(_ urlRequest: URLRequest, with parameters: MTParameters?) -> URLRequest {
        var urlRequest = urlRequest
        guard let parameters = parameters else { return urlRequest }

        if let method = MTHTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), method.encodesParametersInURL() {
            guard let url = urlRequest.url else { return urlRequest }

            if customize != .reflection,
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
                !parameters.isEmpty {

                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }

        return urlRequest
    }

    /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    ///
    /// - parameter key:   The key of the query component.
    /// - parameter value: The value of the query component.
    ///
    /// - returns: The percent-escaped, URL encoded query string components.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }

        return components
    }

    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        var escaped = ""
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex

            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex

                let substring = string.substring(with: range)

                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring

                index = endIndex
            }
        }

        return escaped
    }

    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }

        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}

// MARK: - JSONEncoding

public struct JSONEncoding: MTParameterEncoding {

    // MARK: Properties

    /// Returns a `JSONEncoding` instance with default writing options.
    public static var `default`: JSONEncoding { return JSONEncoding() }

    public static var prettyPrinted: JSONEncoding { return JSONEncoding(options: .prettyPrinted) }

    public static var customQueryString: JSONEncoding { return JSONEncoding(customize: .reflection) }

    public let options: JSONSerialization.WritingOptions
    public let customize: Customize

    public init(customize: Customize = .none, options: JSONSerialization.WritingOptions = []) {
        self.options = options
        self.customize = customize
    }

    // MARK: Encoding

    public func urlEncode(_ url: String, method: MTHTTPMethod, with parameters: MTParameters?) -> URL? {
        var url = url
        if customize == .reflection {
            // Encodes parameters in URL
            if method.encodesParametersInURL() {
                url = url.reflectionEncode(parameters: parameters)
            }
        }
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return nil }

        return URL(string: encodedURL)
    }

    public func encode(_ urlRequest: URLRequest, with parameters: MTParameters?) -> URLRequest {
        var urlRequest = urlRequest

        guard let parameters = parameters else { return urlRequest }
        guard let method = MTHTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), !method.encodesParametersInURL() else {
            return urlRequest
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            return urlRequest
        }

        return urlRequest
    }
}

// MARK: - ArrayEncoding
private let MTArrayParametersKey = "MTArrayParametersKey"

public struct ArrayEncoding: MTParameterEncoding {

    // MARK: Properties

    /// Returns a `ArrayEncoding` instance with default writing options.
    public static var `default`: ArrayEncoding { return ArrayEncoding() }

    public static var prettyPrinted: ArrayEncoding { return ArrayEncoding(options: .prettyPrinted) }

    public static var customQueryString: ArrayEncoding { return ArrayEncoding(customize: .reflection) }

    public let options: JSONSerialization.WritingOptions
    public let customize: Customize

    public init(customize: Customize = .none, options: JSONSerialization.WritingOptions = []) {
        self.options = options
        self.customize = customize
    }

    public func urlEncode(_ url: String, method: MTHTTPMethod, with parameters: MTParameters?) -> URL? {
        var url = url
        if customize == .reflection {
            // Encodes parameters in URL
            if method.encodesParametersInURL() {
                url = url.reflectionEncode(parameters: parameters)
            }
        }
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return nil }

        return URL(string: encodedURL)
    }

    public func encode(_ urlRequest: URLRequest, with parameters: MTParameters?) -> URLRequest {
        var urlRequest = urlRequest

        guard let parameters = parameters, let array = parameters[MTArrayParametersKey] else {
            return urlRequest
        }
        guard let method = MTHTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), !method.encodesParametersInURL() else {
            return urlRequest
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            return urlRequest
        }

        return urlRequest
    }
}

// MARK: - Custom Extensions

/// Extension that allows an array be sent as a request parameters
extension Array {
    func asParameters() -> MTParameters {
        return [MTArrayParametersKey: self]
    }
}

extension NSArray {
    func asParameters() -> MTParameters {
        return [MTArrayParametersKey: self]
    }
}

extension String {

    func reflectionEncode(parameters: MTParameters?) -> String {
        guard let parameters = parameters else { return self }

        var strUrl = self

        for (key, value) in parameters {

            let strKey = String(describing: key)
            var strValue = ""

            if let array = value as? [Any] {

                // For array objects
                for (index, arrayValue) in array.enumerated() {

                    let currentValue = String(describing: arrayValue)
                    strValue = strValue.appendingFormat("%@=%@", strKey, currentValue)
                    if index != (array.count - 1) {
                        strValue = strValue.appending("&")
                    }
                }
            } else {

                // For any objects
                strValue = String(describing: value)
            }

            strUrl = strUrl.replacingOccurrences(of: "{" + strKey + "}", with: strValue)
        }

        return strUrl
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

extension MTHTTPMethod {
    fileprivate func encodesParametersInURL() -> Bool {
        switch self {
        case .get, .delete:
            return true
        default:
            return false
        }
    }
}
