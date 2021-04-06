////
////  ModelNhacTrungQuoc.swift
////  Piano_App
////
////  Created by Nguyen Hieu on 2/17/19.
////  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//struct NhacTrungQuoc: ModelHome {
//    var heighthSize: Float? {
//        return LayoutNhacTrungQuoc.heightTQ.rawValue
//    }
//
//    var widthSize: Float? {
//        return LayoutNhacTrungQuoc.widthTQ.rawValue
//    }
//
////    var viewController: UIViewController? {
////        return nil
////    }
////
////    var heighthSize: CGFloat? {
////        return CGFloat.init(LayoutNhacTrungQuoc.heightTQ.rawValue)
////    }
////
////    var widthSize: CGFloat? {
////        return CGFloat.init(LayoutNhacTrungQuoc.widthTQ.rawValue)
////    }
//
//    var background: UIColor? {
//        return .white
//    }
//
//    var arrayNhacTQ: [AraySongsNhacTrungQuoc] = []
//    let title: String?
//    init(data: [String: Any]) {
//        if let dic = data as? Dictionary<String, Any> {
//            self.title = dic["title"] as? String ?? ""
//            let dicSongs = dic["arraySongs"] as? [String: [String: Any]] ?? ["":["":""]]
//            self.arrayNhacTQ = dicSongs.map{AraySongsNhacTrungQuoc.init(object: $0.value)}
//        }
//        else {
//            self.arrayNhacTQ = [AraySongsNhacTrungQuoc]()
//            self.title = ""
//        }
//    }
//
//}
//
//struct AraySongsNhacTrungQuoc: ModelDetailCellSongs {
//    var heighthSize: Float? {
//        return LayoutNhacTrungQuoc.heightCellTQ.rawValue
//    }
//
//    var widthSize: Float? {
//        return LayoutNhacTrungQuoc.widthCellTQ.rawValue
//    }
//
//
//    var background: UIColor?
//
//    var nameSong: String
//    var imageSong: String
//    var urlMp4: String
//    var likes: Int
//    init(object:[String: Any]) {
//        if let dic = object as? Dictionary<String, Any> {
//            self.nameSong = dic["nameSong"] as?     String ?? ""
//            self.imageSong = dic["imageSong"] as?   String ?? ""
//            self.urlMp4 = dic["urlMp4"] as?         String ?? ""
//            self.likes = dic["likes"] as?           Int    ?? 0
//        }
//        else {
//            self.nameSong = ""
//            self.imageSong = ""
//            self.urlMp4 = ""
//            self.likes = 0
//        }
//    }
//}
