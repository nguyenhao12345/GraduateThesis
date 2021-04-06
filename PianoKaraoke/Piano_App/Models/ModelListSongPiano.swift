//
//  ModelListPiano.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 5/25/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
struct ListSongPiano: ModelHome {
    var heighthSize: Float? {
        return Float(LayoutListSongPiano.height.rawValue)
    }
    
    var widthSize: Float? {
        return Float(LayoutListSongPiano.width.rawValue)
    }
    let name: String
    init(name: String) {
        self.name = name
    }
}
