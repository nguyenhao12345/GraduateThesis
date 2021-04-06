//
//  User.swift
//  azibai
//
//  Created by Mac on 5/10/17.
//  Copyright © 2017 azibai. All rights reserved.
//

import UIKit

let Userdefaults = UserDefaults.standard

public class UserStore: NSObject {
//    public class func SetuserId(userId :Int) {
//        Userdefaults.set(userId, forKey: "userId")
//    }
//    public class func GetuserId() -> Int{
//        var userId = Userdefaults.object(forKey: "userId")
//        if userId == nil {
//            userId = 0
//        }
//        return (userId as? Int)!
//    }
    
//    public class func Settoken(token :String) {
//        Userdefaults.set(token, forKey: "token")
//    }
//    public class func Gettoken() -> String{
//        var token = Userdefaults.object(forKey: "token")
//        if token == nil {
//            token = ""
//        }
//        return (token as? String)!
//    }
    
//    public class func Setgroup(group :Int) {
//        Userdefaults.set(group, forKey: "group")
//    }
//    public class func Getgroup() -> Int{
//        var group = Userdefaults.object(forKey: "group")
//        if group == nil {
//            group = 0
//        }
//        return (group as? Int)!
//    }
    public class func SetreloadPostNews(group :Int) {
        Userdefaults.set(group, forKey: "reloadPostNews")
    }
    public class func GetreloadPostNews() -> Int{
        var group = Userdefaults.object(forKey: "reloadPostNews")
        if group == nil {
            group = 0
        }
        return (group as? Int)!
    }
    
    public class func SetReloadNewsDetails(group :Int) {
        Userdefaults.set(group, forKey: "ReloadNewsDetails")
    }
    public class func GetReloadNewsDetails() -> Int{
        var group = Userdefaults.object(forKey: "ReloadNewsDetails")
        if group == nil {
            group = 0
        }
        return (group as? Int)!
    }
    
    public class func SetReloadMenu(token: String) {
        Userdefaults.set(token, forKey: "reloadMenu")
    }
    public class func GetReloadMenu() -> String {
        var token = Userdefaults.object(forKey: "reloadMenu")
        if token == nil {
            token = ""
        }
        return (token as? String)!
    }
    
    public class func SetBackHome(BackHome: String) {
        Userdefaults.set(BackHome, forKey: "BackHome")
    }
    public class func GetBackHome() -> String {
        var BackHome = Userdefaults.object(forKey: "BackHome")
        if BackHome == nil {
            BackHome = ""
        }
        return (BackHome as? String)!
    }
    
    public class func Setaf_key(af_key :String) {
        Userdefaults.set(af_key, forKey: "af_key")
    }
    public class func Getaf_key() -> String{
        var af_key = Userdefaults.object(forKey: "af_key")
        if af_key == nil {
            af_key = ""
        }
        return (af_key as? String)!
    }
    
    public class func GetReloadUserBuyer() -> Int{
        var ReloadUserBuyer = Userdefaults.object(forKey: "ReloadUserBuyer")
        if ReloadUserBuyer == nil {
            ReloadUserBuyer = 0
        }
        return (ReloadUserBuyer as? Int)!
    }
    public class func SetReloadUserBuyer(ReloadUserBuyer :Int) {
        Userdefaults.set(ReloadUserBuyer, forKey: "ReloadUserBuyer")
    }
    
    public class func GetIsViewSearch() -> Int{
        var value = Userdefaults.object(forKey: "IsViewSearch")
        if value == nil {
            value = 0
        }
        return (value as? Int)!
    }
    public class func SetIsViewSearch(value :Int) {
        Userdefaults.set(value, forKey: "IsViewSearch")
    }
    
    //MARK: Chat
    public class func GetChangeBGChat() -> Int{
        var value = Userdefaults.object(forKey: "ChangeBGChat")
        if value == nil {
            value = 0
        }
        return (value as? Int)!
    }
    public class func SetChangeBGChat(value :Int) {
        Userdefaults.set(value, forKey: "ChangeBGChat")
    }
    
    public class func getReplyMessageInfoDetail() -> Int {
        var value = Userdefaults.object(forKey: "ReplyMessageInfoDetail")
        if value == nil {
            value = 0
        }
        return (value as? Int)!
    }
    public class func setReplyMessageInfoDetail(value: Int) {
        Userdefaults.set(value, forKey: "ReplyMessageInfoDetail")
    }
    
    public class func getReplyChatGroupType() -> Int {
        var value = Userdefaults.object(forKey: "ReplyChatGroupType")
        if value == nil {
            value = 1
        }
        return (value as? Int)!
    }
    public class func setReplyChatGroupType(value: Int) {
        Userdefaults.set(value, forKey: "ReplyChatGroupType")
    }
    
    public class func getAlarmNotification() -> Int {
        var value = Userdefaults.object(forKey: "AlarmNotification")
        if value == nil {
            value = 0
        }
        return (value as? Int)!
    }
    public class func SetAlarmNotification(value: Int) {
        Userdefaults.set(value, forKey: "AlarmNotification")
    }
    
    // Share product
    public class func getMessageShareProduct() -> Int {
        var value = Userdefaults.object(forKey: "MessageShareProduct")
        if value == nil {
            value = 0
        }
        return (value as? Int)!
    }
    public class func setMessageShareProduct(value: Int) {
        Userdefaults.set(value, forKey: "MessageShareProduct")
    }
    
    // Reply message
    public class func setReplyMessageDic(_ dictionary: [String: Any]?) {
        Userdefaults.set(dictionary, forKey: "ReplyMessage")
    }
    
    public class func getReplyMessageDic() -> [String: Any]? {
        if let dictionary = Userdefaults.value(forKey: "ReplyMessage") as? [String: Any] {
            return dictionary
        }
        return nil
    }
    
    /* Reply image in multi image */
    // Check condition
    public class func setReplyImageInMultiImage(_ value: Bool) {
        Userdefaults.set(value, forKey: "ReplyImageInMultiImage")
    }
    
    public class func getReplyImageInMultiImage() -> Bool {
        let value = Userdefaults.bool(forKey: "ReplyImageInMultiImage")
        return value
    }
    
    // Elements
    public class func setReplyMessageElementDic(_ dictionary: [String: Any]?) {
        Userdefaults.set(dictionary, forKey: "ReplyMessageElement")
    }
    
    public class func getReplyMessageElementDic() -> [String: Any]? {
        if let dictionary = Userdefaults.value(forKey: "ReplyMessageElement") as? [String: Any] {
            return dictionary
        }
        return nil
    }
    
    // GoBack ReviewImageInfo
    public class func setBackReviewInfoWeb(_ value: Bool) {
        Userdefaults.set(value, forKey: "BackReviewInfoWeb")
    }
    
    public class func GetBackReviewInfoWeb() -> Bool {
        let value = Userdefaults.bool(forKey: "BackReviewInfoWeb")
        return value
    }
    
    public class func setBackReviewInfoSendCamera(_ value: Bool) {
        Userdefaults.set(value, forKey: "BackReviewInfoSendCamera")
    }
    
    public class func GetBackReviewInfoSendCamera() -> Bool {
        let value = Userdefaults.bool(forKey: "BackReviewInfoSendCamera")
        return value
    }
    
    public class func setBackReviewInfoSendGallery(_ value: Bool) {
        Userdefaults.set(value, forKey: "BackReviewInfoSendGallery")
    }
    
    public class func GetBackReviewInfoSendGallery() -> Bool {
        let value = Userdefaults.bool(forKey: "BackReviewInfoSendGallery")
        return value
    }
    
    public class func setBackReviewInfoSendFile(_ value: Bool) {
        Userdefaults.set(value, forKey: "BackReviewInfoSendFile")
    }
    
    public class func GetBackReviewInfoSendFile() -> Bool {
        let value = Userdefaults.bool(forKey: "BackReviewInfoSendFile")
        return value
    }

    public class func setBackReviewInfoSendProduct(_ value: Bool) {
        Userdefaults.set(value, forKey: "BackReviewInfoSendProduct")
    }
    
    public class func GetBackReviewInfoSendProduct() -> Bool {
        let value = Userdefaults.bool(forKey: "BackReviewInfoSendProduct")
        return value
    }

    public class func setBackReviewInfoGetMoreSticker(_ value: Bool) {
        Userdefaults.set(value, forKey: "BackReviewInfoGetMoreSticker")
    }
    
    public class func GetBackReviewInfoGetMoreSticker() -> Bool {
        let value = Userdefaults.bool(forKey: "BackReviewInfoGetMoreSticker")
        return value
    }
    
    public class func setBackReviewInfoGotoDetailListEmoji(_ value: Int) {
        Userdefaults.set(value, forKey: "BackReviewInfoGotoDetailListEmoji")
    }
    
    public class func GetBackReviewInfoGotoDetailListEmoji() -> Int {
        var value = Userdefaults.object(forKey: "BackReviewInfoGotoDetailListEmoji")
        if value == nil {
            value = 0
        }
        return (value as? Int)!
    }
    
    public class func setGotoMoreListUser(_ value: Bool) {
        Userdefaults.set(value, forKey: "GotoMoreListUser")
    }
    
    public class func GetGotoMoreListUser() -> Bool {
        let value = Userdefaults.bool(forKey: "GotoMoreListUser")
        return value
    }
    
    public class func GetBackReviewInfoReviewOneImage() -> Bool {
        let value = Userdefaults.bool(forKey: "BackReviewInfoReviewOneImage")
        return value
    }
    
    public class func setBackReviewInfoReviewOneImage(_ value: Bool) {
        Userdefaults.set(value, forKey: "BackReviewInfoReviewOneImage")
    }
    
    // message send Offline
    public class func setMessageOffline(dictionary: [String: Any]) {
        var listuser = self.getMessageOffline()
        listuser.append(dictionary)
        Userdefaults.set(listuser, forKey: "MessageOffline")
    }

    public class func getMessageOffline() -> [[String: Any]] {
        if let Arrdictionary = Userdefaults.value(forKey: "MessageOffline") as? [[String: Any]] {
            return Arrdictionary
        }
        return [[:]]
    }
    
//    public class func setMessageOffline_changeAtIndex(indexValue : Int, dictionary: [String: Any]) {
//        var listuser = self.getMessageOffline()
//        if listuser.count > indexValue{
//            let statusSend = dictionary["statusSend"] as! String
//            if(statusSend.caseInsensitiveCompare("Sended") == .orderedSame){
//                Log("remove at indexValue \(indexValue) with message text \(dictionary["text"]) with array count \(listuser.count)")
//                listuser.remove(at: indexValue)
//
//            }else{
//                listuser[indexValue] = dictionary
//            }
//            Userdefaults.set(listuser, forKey: "MessageOffline")
//        }
//    }
    public class func setMessageOffline_changeAtIndex(indexValue : Int, dictionary: [String: Any]) {
        var listuser = self.getMessageOffline()
        if listuser.count > indexValue{
            listuser[indexValue] = dictionary
            Userdefaults.set(listuser, forKey: "MessageOffline")
        }
    }
    
    public class func setMessageOffline_removeAtIndex(indexValue : Int) -> Bool{
        var listuser = self.getMessageOffline()
        if listuser.count > indexValue{
            listuser.remove(at: indexValue)
            Userdefaults.set(listuser, forKey: "MessageOffline")
            return true
        }
        return false
    }
    
    public class func setMessageOfflineEmpty() {
        let arr : [[String : Any]] = [[:]]
        Userdefaults.set(arr, forKey: "MessageOffline")
    }
    
    public class func setChangeStatusWifi(value : Bool) {
        Userdefaults.set(value, forKey: "ChangeStatusWifi")
    }
    
    public class func GetChangeStatusWifi() -> Bool {
        let value = Userdefaults.bool(forKey: "ChangeStatusWifi")
        return value
    }
    
    public class func setShouldGetHistoryListChat(value : Bool) {
        Userdefaults.set(value, forKey: "GetHistoryListChatComplete")
    }
    
    public class func getShouldGetHistoryListChat() -> Bool {
        let value = Userdefaults.bool(forKey: "GetHistoryListChatComplete")
        return value
    }
}
