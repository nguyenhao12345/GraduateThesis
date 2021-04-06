//
//  DataResponse+Exts.swift
//  Azibai
//
//  Created by ToanHT on 8/13/20.
//  Copyright © 2020 Azi IOS. All rights reserved.
//

import Foundation
import Alamofire

extension DataResponse {
    
    var messageString:String? {
        if let data = self.result.value as? [String:Any] {
            return data["msg"] as? String
        }
        return nil
    }
    
    
    var statusCode:Int {
        if let data = self.response {
            return data.statusCode
        }
        return 0
    }
    
    var azibaiData:[String:Any]? {
        
        if self.statusCode == 200 {
            return self.result.value as? [String:Any]
        }
        return nil
    }
    
}
