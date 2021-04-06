//
//  ModelSongLocal.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 2/17/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import UIKit

struct SongsLocal: ModelHome {
    var heighthSize: Float? {
        return GetFramUIScreen.share.getHeightUIScreen()/4
    }
    
    var widthSize: Float? {
        return GetFramUIScreen.share.getWitdhUIScreen()
    }
    

    
    let arraySongs: [ModelDetailCellSongs]
    let title: String?
    init(title: String, arraySongs: [ModelDetailCellSongs]) {
        self.title = title
        self.arraySongs = arraySongs
    }
}

struct SongsLocalDetail: ModelDetailCellSongs {
    var heighthSize: Float? {
        return GetFramUIScreen.share.getHeightUIScreen()/3 - 50
    }
    
    var widthSize: Float? {
        return 0.6*GetFramUIScreen.share.getWitdhUIScreen()
    }
    var urlSong: String?
    private let image: UIImage?
    private let nameSong: String?
    private let content: String?
    init(image: String, nameSong: String, urlSong: String, content: String) {
        self.image = UIImage.init(named: image)
        self.nameSong = nameSong
        self.urlSong = urlSong
        self.content = content
    }
    
    func getContent() -> String? {
        return content
    }
    func getImageSong() -> UIImage? {
        return image
    }
    func getNameSong() -> String? {
        return nameSong
    }
}
