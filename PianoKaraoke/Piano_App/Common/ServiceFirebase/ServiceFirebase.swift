//
//  ServiceFirebase.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 2/14/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import FirebaseAuth
import DateToolsSwift
import Mapper
import YoutubeKit

//ID news, ID Comment = timeTamp + UID user

class ServiceOnline {
    static var share = ServiceOnline()
    var ref = Database.database().reference()
    
    func pushDataSearch(text: String, key: String) {
        let dic = ["key": key, "name": text] as [String : Any]
        ref.child("Search").child(text).setValue(dic)
    }
    
    func deleteNews(news: NewsFeedModel, completion: @escaping (Bool)->()) {
        let storage = Storage.storage()
        guard let uidUser = AppAccount.shared.getUserLogin()?.uid,
        let url = news.media?.urlMp3 else { return }
        let storageRef = storage.reference(forURL: url)

        LOADING_HELPER.show()
        //Removes image from storage
        storageRef.delete { error in
            LOADING_HELPER.dismiss()
            if error != nil {
                completion(false)
            } else {
                // File deleted successfully
                self.ref.child("NewsFeed").child(news.commentId).removeValue()
                self.ref.child("UserWalls").child(uidUser).child(news.commentId).removeValue()
                self.ref.child("CommentNews").child(uidUser).child(news.commentId).removeValue()
//                self.ref.child("UserWalls").child(uidUser).child(idNews).setValue(dic)
                completion(true)
            }
        }

    }
    func createPostNews(title: String, content: String, urlMp3: String, youtubeModel: SearchResult?, detailSongModel: DetailInfoSong?) {
        
        let timestamp = NSDate().timeIntervalSince1970
        guard let uidUser = AppAccount.shared.getUserLogin()?.uid else { return }
        let idNews: String = "\(timestamp.int)-\(uidUser)"
        
        var urlImage: String = ""
        if let _youtubeModel = youtubeModel {
            urlImage = _youtubeModel.snippet.thumbnails.high.url ?? ""
        } else if let _detailSongModel = detailSongModel {
            urlImage = _detailSongModel.imageSong
        }
        
        
        let dic: [String : Any] = [
            "ID": timestamp.int,
            "comments": idNews,
            "media": ["urlImage": urlImage,
                      "urlMp3": urlMp3,
                      "urlVideo": urlMp3],
            "title": title,
            "content": content,
            "user": AppAccount.shared.getUserLogin().asDictionary() ?? [:]
        ]
//        let dicPost: [String : Any] = ["\(idNews)": dic]
//        ref.child("NewsFeed").setValue(dicPost)
        ref.child("NewsFeed").child(idNews).setValue(dic)
        ref.child("UserWalls").child(uidUser).child(idNews).setValue(dic)
    }

    
    func updateLikeNews(news: NewsFeedModel, isLike: Bool) {
        
        guard let meUID = AppAccount.shared.getUserLogin()?.uid,
            let uid = news.user?.uid else { return }
        if isLike {
            ref.child("NewsFeed").child(news.commentId).child("likes").child(meUID).setValue(meUID)
            ref.child("UserWalls").child(uid).child(news.commentId).child("likes").child(meUID).setValue(meUID)
        } else {
            ref.child("NewsFeed").child(news.commentId).child("likes").child(meUID).removeValue()
            ref.child("UserWalls").child(uid).child(news.commentId).child("likes").child(meUID).removeValue()
        }
    }
    
    func comment(at news: NewsFeedModel, commentModel: BaseCommentModel) {
        //CommentNews
        guard let uidOwnerNews = news.user?.uid,
            let uid = AppAccount.shared.getUserLogin()?.uid else { return }
        let idComment: String = "\(commentModel.ID)-\(uid)"
        ref.child("CommentNews").child(news.commentId).child(idComment).setValue(commentModel.asDictionary())
        ref.child("NewsFeed").child(news.commentId).child("firstComment").setValue(commentModel.asDictionary())
        ref.child("UserWalls").child(uidOwnerNews).child(news.commentId).child("firstComment")
            .setValue(commentModel.asDictionary())
        
    }
    
    func deleteComment(at news: NewsFeedModel, commentModel: BaseCommentModel, completionDeleCommentFirst: @escaping (Bool)->()) {
        guard let uidOwnerNews = news.user?.uid,
            let uid = AppAccount.shared.getUserLogin()?.uid else { return }
        let idComment: String = "\(commentModel.ID)-\(uid)"
        ref.child("CommentNews").child(news.commentId).child(idComment).removeValue()
        
        ref.child("NewsFeed").child(news.commentId).child("firstComment").observeSingleEvent(of: .value) { (snapShot) in
            guard let value = snapShot.value else {
                DispatchQueue.main.async {
                    completionDeleCommentFirst(false)
                }
                return
            }
            DispatchQueue.main.async {
                guard let data = value as? [String: Any] else {
                    completionDeleCommentFirst(false)
                    return }
                if let ID = data["ID"] as? Int {
                    if ID == commentModel.ID {
                        
                        self.ref.child("NewsFeed").child(news.commentId).child("firstComment").removeValue()
                        self.ref.child("UserWalls").child(uidOwnerNews).child(news.commentId).child("firstComment")
                            .removeValue()

                        completionDeleCommentFirst(true)
                    } else {
                        completionDeleCommentFirst(false)
                    }
                } else {
                    completionDeleCommentFirst(false)
                }
            }
        }
    }
    
    func getDataUser(uid: String, comletion: @escaping (_ data: Any?) -> ()) {
        ref.child("User").child(uid).observeSingleEvent(of: .value) { (snapShot) in
            guard let value = snapShot.value else {
                DispatchQueue.main.async {
                    comletion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                comletion(value)
            }
        }
    }
    
//    func pushData(uid: String, data: AccountUserModel) {
//        ref.child("User").child(uid).setValue(["UID":data.uid, "avata": data.url, "name": data.name])
//    }
    
    func pushDataRegistUser(uid: String, data: UserModel) {
        ref.child("User").child(uid).setValue(["UID":data.uid,
                                               "avata": data.avata,
                                               "name": data.name,
                                               "phone": data.phone,
                                               "address": data.address])
    }
    
    func changeInfoUser(uid: String, data: UserModel) {
        ref.child("User").child(uid).setValue(["UID":data.uid,
                                               "address": data.address,
                                               "avata": data.avata,
                                               "birth": data.birth,
                                               "education": data.education,
                                               "email": data.email,
                                               "homeTown": data.homeTown,
                                               "infoIntro": data.infoIntro,
                                               "interests": data.interests,
                                               "job": data.job,
                                               "sex": data.sex,
                                               "userName": data.userName,
                                               "name": data.name,
                                               "phone": data.phone])
    }

    
    func registAccount(email: String, password: String, completion: @escaping (RegistResul) -> ()) {

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

            if let authResult = authResult {
                completion(RegistResul.success(data: authResult))
            }
            else {
                completion(RegistResul.error(message: error?.localizedDescription ?? ""))
            }

        }
    }
    
    func changePasswd(oldPass: String, newPasss: String, completion: @escaping (String) -> ()) {
        guard let email = AppAccount.shared.getUserLogin()?.userName else { return }
        checkLogin(email: email, pass: oldPass) { (result) in
            switch result {
            case .error(_):
                completion("Nhập lại mật khẩu không đúng")
            case .success(_):
                Auth.auth().currentUser?.updatePassword(to: newPasss) { (error) in
                    if let _error = error?.localizedDescription {
                        completion(_error)
                    } else {
                        completion("Thành công")
                    }
                }
            }
        }
        
    }
    
    func checkLogin(email: String, pass: String, completion: @escaping (LoginResul) -> ()) {
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if let user = user {
                completion(LoginResul.success(data: user))
            }
            else {
                completion(LoginResul.error(message: error?.localizedDescription ?? ""))
            }
        }
    }
    func getDataSearch(param: String, comletion: @escaping (_ data: Any?) -> ()) {
        ref.child(param).observe(.value) { (snapShot) in
            guard let value = snapShot.value else {
                DispatchQueue.main.async {
                    comletion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                comletion(value)
            }
        }
    }
    func getData(param: String, comletion: @escaping (_ data: Any?) -> ()) {
        ref.child("OverViewCategoryApp").child(param).observe(.value) { (snapShot) in
            guard let value = snapShot.value else {
                DispatchQueue.main.async {
                    comletion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                comletion(value)
            }
        }
    }
    func getDataListSongs(param: String, comletion: @escaping (_ data: Any?) -> ()) {
        ref.child("OverViewCategoryApp").child(param).child("arraySongs").observe(.value) { (snapShot) in
            guard let value = snapShot.value else {
                DispatchQueue.main.async {
                    comletion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                comletion(value)
            }
        }
    }
    func getDataInfoSong(param: String, comletion: @escaping (_ data: Any?) -> ()) {
        ref.child("DetailSong").child(param).observe(.value) { (snapShot) in
            guard let value = snapShot.value else {
                DispatchQueue.main.async {
                    comletion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                comletion(value)
            }
        }
    }
    
    func getDataComment(param: String, comletion: @escaping (_ data: Any?) -> ()) {
        ref.child("CommentSongs").child(param).observe(.value) { (snapShot) in
            guard let value = snapShot.value else {
                DispatchQueue.main.async {
                    comletion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                comletion(value)
            }
        }
    }
    
    func addComment(id: String, comment: String, comletion: @escaping (_ data: Any?) -> ()) {
        guard let user = AppAccount.shared.getUserLogin() else { return }
        let time = String(NSDate().timeIntervalSince1970.int)
        let dic: [String: Any] = [
            "comment": comment,
            "name": user.name,
            "uid": user.uid ?? "",
            "urlAvata": user.avata,
            "timetamp": time
        ]
        ref.child("CommentSongs").child(id).child(time).setValue(dic)
        
    }
}
