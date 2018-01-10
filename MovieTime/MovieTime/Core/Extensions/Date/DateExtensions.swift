//
//  DateExtensions.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

extension Date {

    func shortDateFormat() -> String {
        let dateFormatter = DateHelper.shared.shortDateFormatter
        return dateFormatter.string(from: self)
    }
}
