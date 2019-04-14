//
//  SongModel.swift
//  Smart Music Dark
//
//  Created by Lyheang IBell on 12/1/18.
//  Copyright © 2018 Kristoff IBell. All rights reserved.
//

import Foundation
import UIKit

class SMSong: NSObject {
    var id: Int?
    var title: String?
    var poster: String?
    var name: String?
    var duration: String?
    var url: String?
    var artistId: Int?
    
    override init() {
        super.init()
    }
    init(withDictionary dic: NSDictionary) {
        self.id = dic.value(forKey: "id") as? Int
        self.name = dic.value(forKey: "name") as? String ?? ""
        self.title = dic.value(forKey: "title") as? String ?? ""
        self.poster = dic.value(forKey: "thumbnail") as? String ?? ""
        self.duration = dic.value(forKey: "duration") as? String ?? ""
        self.url = dic.value(forKey: "url") as? String ?? ""
        self.artistId = dic.value(forKey: "artistId") as? Int
    }
}
