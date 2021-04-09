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


class AppColor: NSObject {
    static let shared = AppColor()
    var arrColor: [String] = ["CEA69D", "C6C96B" ,"70C3C7", "7BBFBC", "F28C8F"]
    var colorBackGround: BehaviorRelay<String> = BehaviorRelay(value: "F28C8F")
    
    func getColor() -> String {
        let object = arrColor.removeFirst()
        arrColor.append(object)
        return object
    }
}
