//
//  PreferenceManager.swift
//  TestTabbed
//
//  Created by Chandra Welim on 7/13/17.
//  Copyright © 2017 Suitmedia. All rights reserved.
//

import UIKit

class PreferenceManager: NSObject {

    private static let MovieId = "MovieId"
    private static let ReferralId = "ReferralId"
    private static let SenderEmail = "Email"
    private static let XAuth = "X-Auth"
    private static let Tag = "String"
    private static let PageSize = "Int"
    private static let From = "String"
    private static let To = "String"
    
    static let instance = PreferenceManager()
    
    private let userDefaults: UserDefaults
    
    override init() {
        userDefaults = UserDefaults.standard
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    var xAuth: String? {
        get {
            return userDefaults.string(forKey: PreferenceManager.XAuth)
        }
        set(newValue) {
            if let value = newValue {
                userDefaults.set(value, forKey: PreferenceManager.XAuth)
            } else {
                userDefaults.removeObject(forKey: PreferenceManager.XAuth)
            }
        }
    }
    
    var senderEmail: String? {
        get {
            return userDefaults.string(forKey: PreferenceManager.SenderEmail)
        }
        set(newValue) {
            if let value = newValue {
                userDefaults.set(value, forKey: PreferenceManager.SenderEmail)
            } else {
                userDefaults.removeObject(forKey: PreferenceManager.SenderEmail)
            }
        }
    }
    
    var referralId: String? {
        get {
            return userDefaults.string(forKey: PreferenceManager.ReferralId)
        }
        set(newValue) {
            if let value = newValue {
                userDefaults.set(value, forKey: PreferenceManager.ReferralId)
            } else {
                userDefaults.removeObject(forKey: PreferenceManager.ReferralId)
            }
        }
    }
    
    var movieId: Int64? {
        get {
            if let number = userDefaults.object(forKey: PreferenceManager.MovieId) as? NSNumber {
                return number.int64Value
            }
            return 0
        }
        set(newUserId) {
            if let userId = newUserId {
                userDefaults.set(NSNumber(value: userId), forKey: PreferenceManager.MovieId)
            } else {
                userDefaults.removeObject(forKey: PreferenceManager.MovieId)
            }
        }
    }
    
}
