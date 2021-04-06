//
//  ModelListSongs.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/5/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation

struct ModelListSongs {
    var nameSong: String
    var imageSong: String
    var idDetail: String
    var level: Int
    init(object:[String: Any]) {
        self.nameSong = object["nameSong"] as? String ?? "abc"
        self.imageSong = object["imageSong"] as? String ?? ""
        self.idDetail = object["idDetail"] as? String ?? ""
        self.level = object["level"] as? Int ?? 0
    }
}
