//
//  FirebaseHelper.swift
//  Smart Music Dark
//
//  Created by Ky Nguyen on 2/13/19.
//  Copyright © 2019 Kristoff IBell. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct FirebaseHelper {
    func saveLoginStatus(didLogin: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
            .child("account")
            .child(uid)
        ref.setValue(["didLogin": didLogin])
    }

    func checkLoginStatus(completed: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
            .child("account")
            .child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let raw = snapshot.value as AnyObject? else { return }
            let didLogin = raw["didLogin"] as? Bool ?? false
            completed(didLogin)
        }
    }

}
