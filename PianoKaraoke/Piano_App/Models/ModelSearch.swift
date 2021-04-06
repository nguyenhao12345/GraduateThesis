//
//  ModelSearch.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/15/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
struct ModelSearch {
    var key: String
    var name: String
    init(data: [String: String]) {
        self.key = data["key"] ?? ""
        self.name = data["name"] ?? ""
    }
}
