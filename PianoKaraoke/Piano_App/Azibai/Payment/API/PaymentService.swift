//
//  PaymentService.swift
//  Piano_App
//
//  Created by Azibai on 11/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Alamofire_SwiftyJSON
import Alamofire

class PaymentService: NSObject {
    static let shared: PaymentService = PaymentService()
    var banks: [BankModel] = []
    let header = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjE0MjQsImdyb3VwIjo0LCJ1c2VybmFtZSI6ImFkbWluaXN0cmF0b3IiLCJuYW1lIjoiQXppYmFpIEFkbWluIiwiaXNzIjoiaHR0cDpcL1wvYXBpLmF6aWJhaS5jb21cL2FwaVwvdjFcL2xvZ2luIiwiaWF0IjoxNTk0MDIxMTAyLCJleHAiOjE2MzAwMjExMDIsIm5iZiI6MTU5NDAyMTEwMiwianRpIjoiMTM2NDk5M2U5NGIzZmRhOTY0NTY1OGMyZTE4YzllNjMifQ.aO_E4p43Fp3MRMLe-q9EhwAUVUdeQdelJ4cKbOeDqss","Content-Type": "application/json"]
    
    func requestWithDrawalMoney(param: [String: Any]) {
        let url = "http://api.azibai.com/api/v1/app-admin/transfer/withdrawal"
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            switch response.result {
            case .success(let json):
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                let account_balance = json["data"]["account_balance"].doubleValue
            case .failure(let error): break
            }
        }

    }
    
    
    func getHistoryPayment(param: [String: Any]) {
        let url = "http://api.azibai.com/api/v1/app-admin/transfer/account-balance"
        //app-admin/transfer/histories?
    }
    
    func getSumMoneyReal(completion: @escaping (_ account_balance: Double)->()) {
        let url = "http://api.azibai.com/api/v1/app-admin/transfer/account-balance"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            switch response.result {
            case .success(let json):
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                let account_balance = json["data"]["account_balance"].doubleValue
                if status == 1 {
                    completion(account_balance)
                } else {
                    completion(0)
                }
            case .failure(let error):
                completion(0)
            }
        }
    }
    func deleteBank(id: Int, param: [String: Any], completion: @escaping (_ error: String?)->()) {
        let url = "http://api.azibai.com/api/v1/app-admin/bank-cards/\(id)"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .delete, parameters: param, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                if status == 0 {
                    completion(msg)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error.message)
            }
        }
    }
    
    func deleteWallet(id: Int, param: [String: Any], completion: @escaping (_ error: String?)->()) {
        let url = "http://api.azibai.com/api/v1/app-admin/wallet-accounts/\(id)"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .delete, parameters: param, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                if status == 0 {
                    completion(msg)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error.message)
            }
        }
    }
    
    func getWallets(page: Int, completion: @escaping ([WalletModel])->()) {
        let url = "http://api.azibai.com/api/v1/app-admin/bank-and-wallet-accounts?page=\(page)"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
                completion(json["data"].arrayValue.map({ WalletModel(json: $0) }))
            case .failure(_):
                completion([])
            }
        }
    }
    
    func updateAccountMomo(id: Int, param: [String: Any], completion: @escaping (_ error: String?)->()) {
        
        let url = "http://api.azibai.com/api/v1/app-admin/wallet-accounts/\(id)"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .patch, parameters: param, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                if status == 0 {
                    completion(msg)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error.message)
            }
        }
        
    }
    
    func updateAccountBank(id: Int, param: [String: Any], completion: @escaping (_ error: String?)->()) {
        
        let url = "http://api.azibai.com/api/v1/app-admin/bank-cards/\(id)"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .patch, parameters: param, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
                let status = json["status"].intValue
                let msg = json["msg"].stringValue
                if status == 0 {
                    completion(msg)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error.message)
            }
        }

    }
    
    
    func createMomo(param: [String: Any], completion: @escaping (_ error: String?)->()) {
        let url = "http://api.azibai.com/api/v1/app-admin/wallet-accounts"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
                let status = json["status"].intValue
                let msg = json["msg"].string
                if status == 0 {
                    completion(msg)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error.message)
            }
        }
    }
    
    func createBank(param: [String: Any], completion: @escaping (_ error: String?)->()) {
        let url = "http://api.azibai.com/api/v1/app-admin/bank-cards"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
                let status = json["status"].intValue
                let msg = json["msg"].string
                if status == 0 {
                    completion(msg)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                completion(error.message)
            }
        }
    }
    
    func getAllAccountMomo(completion: @escaping ([WalletModel])->()) {
        let url = "http://api.azibai.com/api/v1/app-admin/wallet-accounts"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON(completionHandler: { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
                let wallet = json["data"].array?.map({
                    WalletModel(json: $0)
                }) ?? []
                completion(wallet)
            case .failure(_):
                completion([])
            }
        })
        
    }
    
    func getBanks(completion: @escaping ([BankModel])->()) {
        if banks.isEmpty {
            let url = "http://api.azibai.com/api/v1/app-admin/banks"
            LOADING_HELPER.show()
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON(completionHandler: { [weak self] (response) in
                LOADING_HELPER.dismiss()
                switch response.result {
                case .success(let json):
                    self?.banks = json["data"].array?.map({
                        BankModel(json: $0)
                    }) ?? []
                    completion(self?.banks ?? [])
                case .failure(_):
                    completion([])
                }
            })
        } else {
            completion(banks)
        }
    }
    
    func removeAccountBank() {
        
    }
    
    func removeAccountMomo() {
        
    }
    
    func getDataManagerTabProvisional(completion: @escaping (_ notional_incom_total: Double,
        _ notional_shop_income: Double, _ notional_commission_ctv_azibai: Double, _ notional_commission_ctv_shop: Double,
        _ notional_consignment: Double)->()) {
        let url = "http://api.azibai.com/api/v1/app-admin/transfer/notional-shop-income-total"
        LOADING_HELPER.show()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseSwiftyJSON(completionHandler: { (response) in
            LOADING_HELPER.dismiss()
            switch response.result {
            case .success(let json):
               let notional_incom_total = json["data"]["notional_incom_total"].double ?? 0
               let notional_shop_income = json["data"]["notional_shop_income"].double ?? 0
               let notional_commission_ctv_azibai = json["data"]["notional_commission_ctv_azibai"].double ?? 0
               let notional_commission_ctv_shop = json["data"]["notional_commission_ctv_shop"].double ?? 0
               let notional_consignment = json["data"]["notional_consignment"].double ?? 0
               completion(notional_incom_total, notional_shop_income, notional_commission_ctv_azibai, notional_commission_ctv_shop, notional_consignment)
            case .failure(_):
                completion(0,0,0,0,0)
            }
        })
    }
    
}
