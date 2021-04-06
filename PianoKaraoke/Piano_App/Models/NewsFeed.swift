//
//  NewsFeed.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import DateToolsSwift

class NewsFeedModel: AziBaseModel {
    var user: UserModel?
    var title: String = ""
    var content: String = ""
    var likes: [String] = []
    var ID: Int = 0
    var isLike: Bool {
        guard let uidCurentUserLogin = AppAccount.shared.getUserLogin()?.uid else { return false }
        return likes.contains(uidCurentUserLogin)
    }
    var commentId: String = ""
    var media: MediaModel?
    var timeAgoSinceNow: String = ""
    var dateAgoSince: String?
    var firstComment: BaseCommentModel?
    init(data: [String: Any]) {
        if let dicUser = data["user"] as? [String : Any] {
            self.user = UserModel(data: dicUser)
        }
        title = data["title"] as? String  ?? ""
        content = data["content"] as? String  ?? ""
        if let jslikes = data["likes"] as? [String: String] {
            likes = jslikes.map({ $0.value })
        }
        commentId = data["comments"] as? String  ?? ""
        ID = data["ID"] as? Int  ?? 0
        if let dicMedia = data["media"] as? [String : Any] {
            media = MediaModel(data: dicMedia)
        }
        if let dicfirstComment = data["firstComment"] as? [String : Any] {
            firstComment = BaseCommentModel(data: dicfirstComment)
        }
        super.init()
        initTimeAgoSinceNow()
    }
    
    public required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    func initTimeAgoSinceNow() {
        let data = Date(timeIntervalSince1970: TimeInterval(ID))
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

class MediaModel: AziBaseModel {
    var urlImage: String = ""
    var urlMp3: String = ""
    var urlVideo: String = ""
    init(data: [String: Any]) {
        self.urlImage = data["urlImage"] as? String ?? ""
        self.urlMp3 = data["urlMp3"] as? String ?? ""
        self.urlVideo = data["urlVideo"] as? String ?? ""
        super.init()
    }
    
    override init() {
        super.init()
    }
    public required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
}

public class BaseCommentModel: AziBaseModel, Codable {
    var ID: Int = 0
    var content: String = ""
    var user: UserModel?
    
    init(data: [String: Any]) {
        self.ID = data["ID"] as? Int ?? 0
        self.content = data["content"] as? String ?? ""
        self.user = UserModel(data: data["user"] as? [String : Any] ?? [:])
        super.init()
    }
    
    init(contentComment: String) {
        let timestamp = NSDate().timeIntervalSince1970
        self.ID = Int(timestamp)
        self.content = contentComment
        self.user = AppAccount.shared.getUserLogin()
        super.init()
    }
    
    public required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(decoder:) has not been implemented")
    }
}
