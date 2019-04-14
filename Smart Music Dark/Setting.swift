//
//  Setting.swift
//  Smart Music Dark
//
//  Created by Lyheang IBell on 2/10/19.
//  Copyright © 2019 Kristoff IBell. All rights reserved.
//

import Foundation
import FirebaseAuth

class Setting {
    static let itcAccountSecret = "509fe6b14459494fafe25976dac0cc54"

    static var isPremium: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isPremium") }
        set { UserDefaults.standard.set(newValue, forKey: "isPremium") }
    }
    static var didLogin: Bool {
        return Auth.auth().currentUser != nil
    }
}
