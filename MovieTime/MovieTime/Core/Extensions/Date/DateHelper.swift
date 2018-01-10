//
//  DateHelper.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

class DateHelper {

    static let shared = DateHelper()

    lazy var calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = Locale.current
        cal.timeZone = TimeZone.current
        return cal
    }()

    lazy var serviceDateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.calendar = DateHelper.shared.calendar
        format.dateFormat = "yyyy-MM-dd"
        return format
    }()

    lazy var shortDateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.calendar = DateHelper.shared.calendar
        format.dateFormat = "dd/MM/yyyy"
        return format
    }()
}
