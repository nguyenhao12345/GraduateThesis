//
//  BankModel.swift
//  Piano_App
//
//  Created by Azibai on 11/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Mapper
import SwiftyJSON

class BankModel: AziBaseModel {
    var id: Int = 0
    var name: String = ""
    var short_name: String = ""
    var swift_code: String = ""
    var lang_code: String = ""
    var lang_id: Int?
    var is_root: Int = 0
    var cdn_logo: String = ""
    var logo: String = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.short_name = json["short_name"].stringValue
        self.swift_code = json["swift_code"].stringValue
        self.lang_code = json["lang_code"].stringValue
        self.lang_id = json["lang_id"].int
        self.is_root = json["is_root"].intValue
        self.cdn_logo = json["cdn_logo"].stringValue
        self.logo = json["logo"].stringValue
        super.init()
    }
    public required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
}



class WalletModel: AziBaseModel {
    var id: Int = 0
    var user_id: Int = 0
    var account_name: String = ""
    var bank_id: Int = 0
    var bank_name: String = ""
    var bank_short_name: String = ""
    var province_id: Int = 0
    var pre_name: String = ""
    var district_id: Int = 0
    var account_number: String = ""
    var phone_number: String = ""
    var digital_wallet_id: Int = 0
    var wallet_name: String = ""
    var email: String = ""
    var type: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    
    var _type: AccountPaymentSectionModel.TYPE {
        if type == "wallet" {
            return .Momo
        } else {
            return .Bank
        }
    }
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.user_id = json["user_id"].intValue
        self.account_name = json["account_name"].stringValue
        self.bank_id = json["bank_id"].intValue
        self.bank_name = json["bank_name"].stringValue
        self.bank_short_name = json["bank_short_name"].stringValue
        self.province_id = json["province_id"].intValue
        self.pre_name = json["pre_name"].stringValue
        self.district_id = json["district_id"].intValue
        self.account_number = json["account_number"].stringValue
        self.phone_number = json["phone_number"].stringValue
        self.digital_wallet_id = json["digital_wallet_id"].intValue
        self.wallet_name = json["wallet_name"].stringValue
        self.email = json["email"].stringValue
        self.wallet_name = json["wallet_name"].stringValue
        self.type = json["type"].stringValue
        self.created_at = json["created_at"].stringValue
        self.updated_at = json["updated_at"].stringValue
        super.init()
    }
    
    public required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
}
