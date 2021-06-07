//
//  LocalVideoManager.swift
//  Piano_App
//
//  Created by Azibai on 15/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Toast_Swift
import SVProgressHUD
import YoutubeKit

protocol LocalVideoManagerDelegate: class {
    func doneRequest()
}
class LocalVideoManager: NSObject, URLSessionDownloadDelegate {
    
    weak var delegate: LocalVideoManagerDelegate?
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            if Int(progress*100) == 100 {
                SVProgressHUD.showSuccess(withStatus: "Hoàn tất")
            } else {
                SVProgressHUD.showProgress(progress, status: "Tải xuống \(Int(progress*100))%")
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = NSData(contentsOf: location) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let filePath="\(documentsPath)/\(currentNameSongRequest).mp4"
            DispatchQueue.main.async {
                data.write(toFile: filePath, atomically: true)
                SVProgressHUD.dismiss(withDelay: 2.0)
                self.delegate?.doneRequest()
                self.delegate = nil
                print("filePath \(filePath)")
            }
        }
    }
    
    func removeFileLocal(name: String) {
        let fileNameToDelete = "\(name).mp4"
        var filePath = ""

        // Fine documents directory on device
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        filePath = documentDirectory.appendingFormat("/" + fileNameToDelete)

        do {
            let fileManager = FileManager.default

            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }

        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    

    
    static let shared: LocalVideoManager = LocalVideoManager()
    let local: String = "Local"
    let localYoutube: String = "LocalYoutube"
    let keyLocalKeyWorkSearch: String = "Tìm kiếm gần đây"
    let VideoYoutube: String = "VideoYoutube"
    var currentNameSongRequest: String = ""
    func downLoadVideo(urlString: String, nameSong: String) {
        DispatchQueue.global(qos: .background).async {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            let downloadTask = session.downloadTask(with: URL(string: urlString)!)
            self.currentNameSongRequest = nameSong
            downloadTask.resume()
        }
    }
   
    func cacheLocalKeyWorkSearch(str: String) {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(keyLocalKeyWorkSearch)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
            dictionary.setValue(NSDate().timeIntervalSince1970.int, forKey: str)
            if dictionary.count >= 10,
                let dicMin = dictionary.min(by: { a, b in (a.value as? Int ?? 0) < (b.value as? Int ?? 0) }) {
                dictionary.removeObject(forKey: dicMin.key)
            }
            dictionary.write(to: url, atomically: true)
        } else {
            let dictionary = NSMutableDictionary(capacity: 0)
            dictionary.setValue(NSDate().timeIntervalSince1970.int, forKey: str)
            if dictionary.count >= 10,
                let dicMin = dictionary.min(by: { a, b in (a.value as? Int ?? 0) < (b.value as? Int ?? 0) }) {
                dictionary.removeObject(forKey: dicMin.key)
            }
            dictionary.write(to: url, atomically: true)
        }
    }
    
    func getCacheLocalSearch() -> [String] {
        var outPut: [String] = []
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(keyLocalKeyWorkSearch)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
           let dicSort = dictionary.sorted(by: { a, b in (a.value as? Int ?? 0) > (b.value as? Int ?? 0) })
            for i in dicSort {
                if let str = i.key as? String {
                    outPut.append(str)
                }
            }
        }
        return outPut
    }
    
    func cacheObjectLocal(data: NSDictionary, key: String, mp4: String) {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(local)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
            dictionary.setValue(data, forKey: key)
            if dictionary.write(to: url, atomically: true) {
                downLoadVideo(urlString: mp4, nameSong: key)
            }
        } else {
            let dictionary = NSMutableDictionary(capacity: 0)
            dictionary.setValue(data, forKey: key)
            if dictionary.write(to: url, atomically: true) {
                downLoadVideo(urlString: mp4, nameSong: key)
            }
        }
        print("write: ", url)
    }
    
    func cacheObjectYoutubeLocal(data: NSDictionary, key: String, mp4: String) {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(localYoutube)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
            dictionary.setValue(data, forKey: key)
            if dictionary.write(to: url, atomically: true) {
                downLoadVideo(urlString: mp4, nameSong: key)
            }
        } else {
            let dictionary = NSMutableDictionary(capacity: 0)
            dictionary.setValue(data, forKey: key)
            if dictionary.write(to: url, atomically: true) {
                downLoadVideo(urlString: mp4, nameSong: key)
            }
        }
        print("write: ", url)
    }
    
    func removeObjectYoutube(object: SearchResult) {
        let key = object.snippet.title
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(localYoutube)
        let path = getURLVideoLocal(key: key)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
            dictionary.removeObject(forKey: key)
            
            if dictionary.write(to: url, atomically: true) {
                if FileManager.default.fileExists(atPath: path) {
                    // Delete file
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                        print("File k xoa dc")
                    }
                } else {
                    print("File does not exist")
                }
            }
        }
    }
    
    func removeAllLocalFile() {
        
    }
    
    func remove(object: DetailInfoSong) {
        let key = object.nameSong
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(local)
        let path = getURLVideoLocal(key: key)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
            dictionary.removeObject(forKey: key)
            
            if dictionary.write(to: url, atomically: true) {
                if FileManager.default.fileExists(atPath: path) {
                    // Delete file
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                        print("File k xoa dc")
                    }
                } else {
                    print("File does not exist")
                }
            }
        }
    }
    
    func getCacheLocalSong(key: String) -> DetailInfoSong? {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(local)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
            if let obj = dictionary[key] as? NSDictionary {
                return DetailInfoSong(data: obj as? [String : Any] ?? [:])
            }
        }
        return nil
    }
    
    func getURLVideoLocal(key: String, file: String = "mp4") -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = "\(documentsPath)/\(key).\(file)"
        return filePath
    }
    
    func getAllLocalSongs() -> [DetailInfoSong] {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(local)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
            var outs: [DetailInfoSong] = []
            for obj in dictionary {
                outs.append(DetailInfoSong(data: obj.value as? [String : Any] ?? [:]))
            }
            return outs
        }
        return []
    }
    
    func getAllLocalSongYoutube() -> [SearchResult] {
        let url = FileManager.getDocumentsDirectory().appendingPathComponent(localYoutube)
        if let dictionary = NSMutableDictionary(contentsOf: url) {
            var outs: [SearchResult] = []
            for obj in dictionary {
                let obj = obj.value as? [String: Any] ?? [:]
                guard let data = try? JSONSerialization.data(withJSONObject: obj) else { return [] }

                let decoder = JSONDecoder()
                guard let searchObject = try? decoder.decode(SearchResult.self, from: data) else { return [] }
                outs.append(searchObject)
            }
            return outs
        }
        return []
    }

}

