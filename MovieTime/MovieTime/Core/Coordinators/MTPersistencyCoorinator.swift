//
//  MTPersistencyCoorinator.swift
//  MovieTime
//
//  Created by Enrique Melgarejo on 10/01/18.
//  Copyright © 2018 Choynowski. All rights reserved.
//

import Foundation

class MTPersistencyCoorinator {

    // MARK: Get
    class func valueForKey(_ defaultName: String) -> Any? {
        let userDefaults = UserDefaults.standard
        return userDefaults.value(forKey: defaultName)
    }

    class func boolForKey(_ defaultName: String) -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey:defaultName)
    }

    // MARK: Set
    @discardableResult
    class func set(_ value: Any?, forKey defaultName: String) -> Bool {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultName)
        return userDefaults.synchronize()
    }

    @discardableResult
    class func setBool(_ value: Bool, forKey defaultName: String) -> Bool {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: defaultName)
        return userDefaults.synchronize()
    }

    // MARK: Remove
    @discardableResult
    class func removeObjectForKey(_ defaultName: String) -> Bool {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: defaultName)
        return userDefaults.synchronize()
    }
}
