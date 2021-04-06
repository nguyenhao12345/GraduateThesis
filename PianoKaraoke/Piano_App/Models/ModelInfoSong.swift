//
//  ModelInfoSong.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/2/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Mapper
import DateToolsSwift

struct DetailInfoSong {
    var likes: Int
    var urlMp4: String
    var urlMp4Local: String {
        return LocalVideoManager.shared.getURLVideoLocal(key: nameSong)
    }
    var contentKaraoke: String
    var nameSong: String
    var imageSong: String
    var category: String
    var author: String
    var level: Int
    var karaokeLyric: String
    init(data: [String: Any]) {
        self.likes = data["likes"] as? Int ?? 0
        self.urlMp4 = data["urlMp4"] as? String ?? ""
        self.contentKaraoke = data["contentKaraoke"] as? String ?? "Đang cập nhật..."
        self.nameSong = data["nameSong"] as? String ?? ""
        self.imageSong = data["imageSong"] as? String ?? ""
        self.category = data["kindMusic"] as? String ?? ""
        self.author = data["author"] as? String ?? "Chưa biết"
        self.level = data["level"] as? Int ?? 0
        self.karaokeLyric = data["karaokeLyric"] as? String ?? "Đang cập nhật..."
    }
}


class CommentModel: AziBaseModel {
    var comment: String = ""
    var nameUserComment: String = ""
    var urlAvata: String = ""
    var timetamp: String = ""
    var timeAgoSinceNow: String = ""
    var dateAgoSince: String?
    var baseComment: BaseCommentModel?
    init(data: [String: Any]) {
        super.init()
        self.comment = data["comment"] as? String ?? ""
        self.nameUserComment = data["name"] as? String ?? ""
        self.urlAvata = data["urlAvata"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.timetamp = data["timetamp"] as? String ?? ""
        initTimeAgoSinceNow()
    }
    
    init(baseComment: BaseCommentModel) {
        self.baseComment = baseComment
        comment = baseComment.content
        nameUserComment = baseComment.user?.name ?? ""
        urlAvata = baseComment.user?.avata ?? ""
        timetamp = "\(baseComment.ID)"
        super.init()
        initTimeAgoSinceNow()
    }
    
    public required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    func initTimeAgoSinceNow() {
//        let data = Date(dateString: timetamp, format: "yyyy-MM-dd HH:mm:ss")
        let data = Date(timeIntervalSince1970: TimeInterval(timetamp) as! TimeInterval)
        if data.daysAgo < 1 {   //Hôm nay
            if data.minutesAgo < 10 {  // n phút trước
                timeAgoSinceNow = "Vừa mới đây"
                return
            }
            if data.minutesAgo < 60 {  // n phút trước
                timeAgoSinceNow = "\(data.minutesAgo) phút trước"
                return
            }
            else if data.hoursAgo < 24 {    // n giờ trước
                timeAgoSinceNow =  "\(data.hoursAgo) giờ trước"
                return
            }
        }
        else {
            if data.daysAgo < 2 {   //Hôm qua
                timeAgoSinceNow = "Hôm qua " + data.hour.fillUp + ":" + data.minute.fillUp
                dateAgoSince = "Hôm qua"
            }
            else {
                if data.yearsAgo <= 1 {
                    timeAgoSinceNow = data.day.fillUp +  " th" + data.month.fillUp + " - " +  data.hour.fillUp + ":" +  data.minute.fillUp
                }
                else {
                    timeAgoSinceNow = "\(data.year.fillUp) " + data.day.fillUp + " th" + data.month.fillUp + " - " + data.hour.fillUp + ":" + data.minute.fillUp
                }
                dateAgoSince = data.day.fillUp + "-" + data.month.fillUp + "-" + data.year.fillUp
            }
        }

    }

}
