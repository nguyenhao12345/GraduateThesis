//
//  AppColor.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//F28C8F
class AppColor: NSObject {
    static let shared = AppColor()
    var arrColor: [String] = ["8FDEEA", "D9718B" ,"F8BB7C", "F2E189", "C9D080", "FF9C9F"]
    var colorBackGround: BehaviorRelay<String> = BehaviorRelay(value: UserDefaults.standard.string(forKey: "colorBackGround") ?? "F28C8F")
    
    func getColor() -> String {
        let object = arrColor.removeFirst()
        arrColor.append(object)

        return object
    }
    
}

