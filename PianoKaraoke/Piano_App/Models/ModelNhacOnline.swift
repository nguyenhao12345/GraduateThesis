//
//  ModelDanhChoNguoiMoiBatDau.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 2/17/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//
import SwiftyJSON
import Mapper
import YoutubeKit
class MusicModel: AziBaseModel {
    var author: String?
    var content: String?
    var idDetail: String?
    var imageSong: String?
    var level: Int?
    var nameSong: String?
    var detailSong: DetailInfoSong?
    var youtubeModel: SearchResult?
    
    init(youtubeObject: SearchResult) {
        self.author = youtubeObject.snippet.channelTitle
        self.imageSong = youtubeObject.snippet.thumbnails.medium.url
        self.nameSong = youtubeObject.snippet.title
        self.youtubeModel = youtubeObject
        super.init()
    }
    
    init(json: JSON) {
        author = json["author"].string
        content = json["content"].string
        idDetail = json["idDetail"].string
        imageSong = json["imageSong"].string
        level = json["level"].int
        nameSong = json["nameSong"].string
        super.init()
    }
    
    public required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    init(obj: DetailInfoSong) {
        author = obj.author
        content = obj.contentKaraoke
        idDetail = nil
        imageSong = obj.imageSong
        level = obj.level
        nameSong = obj.nameSong
        detailSong = obj
        super.init()
    }
}

struct NhacOnline: ModelHome {
    
    enum Category: String {
        case newbiew = "Dành cho người mới bắt đầu"
        case chinaSong = "Nhạc Trung Quốc"
        case vietnameseSong = "Nhạc Việt"
        case unknown = ""
    }
    
    var heighthSize: Float? {
        return Float(LayoutDanhChoNguoiMoiBatDau.heightDanhChoNguoiMoiBatDau.rawValue)
    }
    
    var widthSize: Float? {
        return Float(LayoutDanhChoNguoiMoiBatDau.widthDanhChoNguoiMoiBatDau.rawValue)
    }
    
    var arrayNhacOnline: [ArrayNhacOnline] = []
    let category: Category
    var key: String = ""
    init(data: [String: Any]) {
        self.category = Category(rawValue: data["title"] as? String ?? "") ?? .unknown
        self.key = data["key"] as? String ?? ""
        let dicSongs = data["arraySongs"] as? [String: [String: Any]] ?? ["":["":""]]
        self.arrayNhacOnline = dicSongs.map{ArrayNhacOnline.init(object: $0.value)}
        var arrImp = [ArrayNhacOnline]()
        var tam = 0
        for i in dicSongs {
            if tam < 6 {
                arrImp.append(ArrayNhacOnline(object: i.value))
                tam = tam + 1
            }
        }
        self.arrayNhacOnline = arrImp
    }
}
struct ArrayNhacOnline: ModelDetailCellSongs {
    var heighthSize: Float? {
        return LayoutDanhChoNguoiMoiBatDau.heightCellDanhChoNguoiMoiBatDau.rawValue
    }
    
    var widthSize: Float? {
        return LayoutDanhChoNguoiMoiBatDau.widthCellDanhChoNguoiMoiBatDau.rawValue
    }
    
    var nameSong: String
    var imageSong: String
    var idDetail: String
    
    init(object:[String: Any]) {
        self.nameSong  = object["nameSong"]  as?   String ?? ""
        self.imageSong = object["imageSong"] as?   String ?? ""
        self.idDetail  = object["idDetail"]  as?   String ?? ""
    }
}
