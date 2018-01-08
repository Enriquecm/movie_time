//
//  MTCoreUtils.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 08/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

func MTLog(from: String = "NONE", title: String, message: Any? = nil) {
    #if DEBUG
        print("[\(from)] - \(title)")
        if let message = message {
            print("[\(from)] - Message: \(String(describing: message))")
        }
    #endif
}
