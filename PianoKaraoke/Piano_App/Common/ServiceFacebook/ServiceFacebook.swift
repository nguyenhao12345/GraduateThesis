//
//  ServiceFacebook.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/20/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import FBSDKLoginKit
import UIKit
enum LoginResulFb {
    case error(message: String)
    case success(data: LoginManagerLoginResult)
}
class ServiceFacebook {
    static var share = ServiceFacebook()
    private let login = LoginManager()
    private let currentAccessToken = AccessToken.current
    func loginIn(withReadPermissions: [Any],from: UIViewController, completion: @escaping (LoginResulFb)->()) {
        if currentAccessToken?.appID != Settings.appID {
            ServiceFacebook.share.login.logOut()
        }
        login.logIn(permissions: withReadPermissions as! [String], from: from) { (result, error) in
            if let result = result {
                completion(LoginResulFb.success(data: result))
            }
            else {
                completion(LoginResulFb.error(message: error?.localizedDescription ?? ""))
            }
        }
    }
    func logOut() {
        login.logOut()
    }
    func dataUserFromFB(graphPath: String, parameters: Dictionary<String, Any>, httpMethod: HttpMethod.RawValue ,comletion: @escaping (_ data: Any?) -> ()) {
        let request: GraphRequest = GraphRequest(graphPath: graphPath, parameters: parameters, httpMethod: HTTPMethod(rawValue: httpMethod))
        request.start(completionHandler: { (connection, data, err) in
            guard let data = data else {
                DispatchQueue.main.async {
                    comletion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                comletion(data)
            }
            
        })
    }
}
enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    var result: String {
        return self.rawValue
    }
}
