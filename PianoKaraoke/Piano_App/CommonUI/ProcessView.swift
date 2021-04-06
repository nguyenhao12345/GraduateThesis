//
//  ProcessView.swift
//  Piano_App
//
//  Created by Azibai on 15/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit


import SVProgressHUD

let LOADING_HELPER = LoadingHelper.shared

class LoadingHelper {
    
    //
    static let shared = LoadingHelper()
    
    //
    func show(callingFunctionName: String = #function, file: String = #file, line: Int = #line) {
        print("callingFunctionName: \(callingFunctionName), file: \(file), line: \(line)")
//        Globals.doBackground(delay: 0.2) {
//            if !SVProgressHUD.isVisible() {
        SVProgressHUD.show()
//        SVProgressHUD.showProgress(1.0, status: "Đang load")
//                SVProgressHUD.setDefaultMaskType(.gradient)
//            }
//        }
        
    }
    
    func dismiss() {
//        Globals.doBackground(delay: 0.2) {
//            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
//            }
//        }
    }
    
    func showWithStatus(message: String){
         SVProgressHUD.show(withStatus: message)
    }
    
    func showWithProgress(progress: Float, message: String? = nil){
        SVProgressHUD.showProgress(progress, status: message)
    }
}
