//
//  MTParser.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 09/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

final class MTParser<T> where T: Decodable {

    func parse(from responseData: Data, with dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        let decoded = try decoder.decode(T.self, from: responseData)
        return decoded
    }

    func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return .formatted(dateFormatter)
    }
}
