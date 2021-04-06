//
//  YoutubeService.swift
//  Piano_App
//
//  Created by Azibai on 31/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//


import UIKit
import Mapper
import YoutubeKit
import Alamofire
import Alamofire_SwiftyJSON

class YoutubeService: NSObject {
    static let shared: YoutubeService = YoutubeService()
    
    func downLoadVideoYoutubeToLocal(object: SearchResult, isSaveTmpLocal: Bool = false) {
        LOADING_HELPER.show()
        getIdY2Mate(object: object) { (key) in
            if key == "" { return }
            let url = "https://www.y2mate.com/mates/convert"
            var key2 = key
            key2.removeAll(where: { $0 == "\""})
            guard let idVideo = object.id.videoID else { return }
            let parameters = [
                "type": "youtube",
                "_id": key2,
                "v_id": idVideo,
                "token": "",
                "ftype": "mp4",
                "ajax": 1,
                "fquality": "720p"
                ] as [String : Any]
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                LOADING_HELPER.dismiss()
                switch response.result {
                case .success:
                    if let value = response.result.value as? [String: Any] {
                        guard let str = value["result"] as? String else { return }
                        let const = "href="
                        
                        var compare: String = ""
                        var out: String = ""
                        var isFind = false
                        var countDauNhay = 0
                        
                        for i in str {
                            if !isFind {
                                compare.append(i)
                            }
                            if compare.count == const.count {
                                if compare == const {
                                    //tìm thấy
                                    if i == "\"" {
                                        countDauNhay += 1
                                    }
                                    if countDauNhay >= 1 {
                                        out.append(i)
                                        if countDauNhay == 2 {
                                            print("Hieu Out \(out)")
                                            out.removeAll(where: { $0 == "\""})
                                            if isSaveTmpLocal {
                                                LocalVideoManager.shared.downLoadVideo(urlString: out, nameSong: LocalVideoManager.shared.VideoYoutube)
                                            } else {
                                                LocalVideoManager.shared.cacheObjectYoutubeLocal(data: object.dictionary! as NSDictionary, key: object.snippet.title, mp4: out)
                                            }

                                            return
                                        }
                                    }
                                    isFind = true
                                } else {
                                    compare.removeFirst()
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getIdY2Mate(object: SearchResult, completion: @escaping (String)->()) {
        let url = "https://www.y2mate.com/mates/analyze/ajax"

        guard let idVideo = object.id.videoID else { return }
        let parameters = [
            "url": "https://www.youtube.com/watch?v=\(idVideo)",
            "q_auto": 1,
            "ajax": 1
            ] as [String : Any]


        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                if let value = response.result.value as? [String: Any],
                    let str = value["result"] as? String {
                    let const = "k__id"
                    
                    var compare: String = ""
                    var out: String = ""
                    var isFind = false
                    var countDauNhay = 0
                    
                    for i in str {
                        if !isFind {
                            compare.append(i)
                        }
                        if compare.count == const.count {
                            if compare == const {
                                //tìm thấy
                                if i == "\"" {
                                    countDauNhay += 1
                                }
                                if countDauNhay >= 1 {
                                    out.append(i)
                                    if countDauNhay == 2 {
                                        completion(out)
                                        return
                                    }
                                }
                                isFind = true
                            } else {
                                compare.removeFirst()
                            }
                        }
                    }
                }
                completion("")
            case .failure( _):
                completion("")
            }
        }

    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
