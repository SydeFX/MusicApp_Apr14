//
//  ArtistModel.swift
//  Smart Music Dark
//
//  Created by Lyheang IBell on 12/1/18.
//  Copyright © 2018 Kristoff IBell. All rights reserved.
//

import UIKit

class SMArtists: NSObject {
    
    var id: Int?
    var title: String?
    var poster: String?
    override init() {
        super.init()
    }
    init(withDictionary dic: NSDictionary) {
        self.id = dic.value(forKey: "id") as? Int
        self.title = dic.value(forKey: "title") as? String ?? ""
        self.poster = dic.value(forKey: "thumbnail") as? String ?? ""
    }
}
