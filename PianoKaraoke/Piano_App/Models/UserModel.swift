//
//  UserModel.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import RealmSwift

public class UserModel: Object, Codable {
    @objc dynamic public var id: Int = 1
    @objc dynamic public var avata: String = "https://firebasestorage.googleapis.com/v0/b/pianoapp-48598.appspot.com/o/images%2Fhongkong-1.jpg?alt=media&token=638461be-609f-45fe-bef0-5efc0ea7de9f"
    @objc dynamic public var name: String = "hieu dai ca"
    @objc dynamic public var phone: String = "0359341128"
    @objc dynamic public var email: String = ""
    @objc dynamic public var address: String = ""
    @objc dynamic public var uid: String = ""
    @objc dynamic public var userName: String = ""
    @objc dynamic public var infoIntro: String = ""
    @objc dynamic public var job: String = ""
    @objc dynamic public var sex: Int = 1   // -1: nữ, 0: chưa biết, 1: nam
    @objc dynamic public var isHiddenPhoneMail: Int = 1 // 1: true, 0: false
    @objc dynamic public var interests: String = "" // 1: true, 0: false
    @objc dynamic public var homeTown: String = ""
    @objc dynamic public var education: String = ""
    @objc dynamic public var birth: String = ""
    @objc dynamic public var admin: Int = 0
    @objc dynamic public var keyYoutube: String = ""
    
    public convenience required init(data: [String: Any]) {
        self.init()
        self.name = data["name"] as? String ?? ""
        self.avata = data["avata"] as? String ?? ""
        self.phone = data["phone"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.uid = data["UID"] as? String ?? data["uid"] as? String ?? ""
        self.address = data["address"] as? String ?? ""
        self.infoIntro = data["infoIntro"] as? String ?? ""
        self.email = data["email"] as? String ?? ""

        self.birth = data["birth"] as? String ?? ""
        self.education = data["education"] as? String ?? ""
        self.homeTown = data["homeTown"] as? String ?? ""
        self.interests = data["interests"] as? String ?? ""
        self.isHiddenPhoneMail = data["isHiddenPhoneMail"] as? Int ?? 0
        self.sex = data["sex"] as? Int ?? 0
        self.job = data["job"] as? String ?? ""
        self.admin = data["isAdmin"] as? Int ?? 0
        self.keyYoutube = data["keyYoutube"] as? String ?? ""
    }
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
}
