//
//  VideoPlayableViewContainer.swift
//  Azibai
//
//  Created by ToanHT on 8/29/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//


import Foundation
import UIKit
import Foundation
import Kingfisher
import AVFoundation

protocol VideoPlayableViewContainer {
    
    var canPlay: Bool { get }
    
    var visibleVideoFrame: CGRect { get }
    
    func playVideo()
    
    func pauseVideo()
    
    func deactive()
    
    func setupVideo()
    
    var heightSizeViewContainer : CGFloat { get }
    
    var widthSizeViewContainer : CGFloat { get }
    
    var isAutoPlayVideo: Bool { get }
}

extension VideoPlayableViewContainer {
    var isAutoPlayVideo : Bool {
        return true
    }
    
    func setupVideo() {
    }
}


protocol CustomAVPlayerActionsDelegate: class {
    func customAVPlayerActionPlayTapped(cell: UITableViewCell, isPlaying: Bool)
    func customAVPlayerActionPlayTapped(cell: UICollectionViewCell, isPlaying: Bool)
}

extension CustomAVPlayerActionsDelegate {
    func customAVPlayerActionPlayTapped(cell: UITableViewCell, isPlaying: Bool) {
        
    }
    
    func customAVPlayerActionPlayTapped(cell: UICollectionViewCell, isPlaying: Bool) {
        
    }
}



typealias ImageLoadOperationCompletionHandlerType = (_ image: UIImage?) -> Void


class ManagerMediaLoader {
    
    private var completionHandler: ImageLoadOperationCompletionHandlerType?
    
    static let shared = ManagerMediaLoader()
    private init() {}
    
    lazy var loadingQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    lazy var loaddingVideoCache = [String:AVURLAsset?]()
    lazy var loadingOperations = NSCache<NSString, ImageLoadOperation>()
    lazy var loadingImageOperations  = [String:DownloadTask?]()
    func prefetchMedia(url: String, size: CGSize? = nil) {
        if let _ = loadingOperations.object(forKey: url as NSString)  {
            return
        }
        let imageLoader = ImageLoadOperation(url: url, size: size)
        loadingQueue.addOperation(imageLoader)
        loadingOperations.setObject(imageLoader, forKey: url as NSString)
    }
    
//    func prefetchNewsList(newsList: [News], completion: @escaping() -> ())  {
//        let group = DispatchGroup()
//        for news in newsList {
//            // case video
//            if let videoUrl = news.video?.videoURLString {
//                group.enter()
//                let imageLoader = ImageLoadOperation(url: videoUrl)
//                imageLoader.completionHandler = { _ in
//                    group.leave()
//                }
//                loadingQueue.addOperation(imageLoader)
//                loadingOperations.setObject(imageLoader, forKey: videoUrl as NSString)
//            }
//            //case link video
//            if news.customLinks.count > 0 &&  !news.customLinks[0].videoURLString.isEmpty {
//                group.enter()
//                let imageLoader = ImageLoadOperation(url: news.customLinks[0].videoURLString)
//                imageLoader.completionHandler = { _ in
//                    group.leave()
//                }
//                loadingQueue.addOperation(imageLoader)
//                loadingOperations.setObject(imageLoader, forKey: news.customLinks[0].videoURLString as NSString)
//            }
//        }
//        group.notify(queue: .main) {
//            self.loadingQueue.cancelAllOperations()
//            completion()
//        }
//    }
    
    func cancelPrefetchMedia(url: String) {
        
    }
    
    
    func loaderImage(url: String, completion: @escaping ImageLoadOperationCompletionHandlerType) {
        self.completionHandler = completion
    }
    
}

class ImageLoadOperation: Operation {
    var url: String
    var completionHandler: ImageLoadOperationCompletionHandlerType?
    var image: UIImage?
    var kingDownLoad : DownloadTask?
    var size : CGSize?
    
    
    private var indexPath: IndexPath?
    
    override var isAsynchronous: Bool {
        get {
            return  true
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    
    var avURLAsset: AVURLAsset?
    init(url: String, size: CGSize? = nil, indexPath: IndexPath? = nil) {
        self.url = url
        self.size = size
        self.indexPath = indexPath
    }
    
    override func cancel() {

        super.cancel()
        if let downloadTask = kingDownLoad {
            downloadTask.cancel()
        } else if let asset = avURLAsset {
            asset.cancelLoading()
        }
    }
    
    
    override func main() {
        if isCancelled {
            finish(true)
            return
        }
        guard let url = URL(string: url) else {
            return
        }
        
        self.executing(true)
        if url.pathExtension == "mp4" {
            DispatchQueue.global().async {
                self.loadVideo(url: url)
            }
        } else {
            DispatchQueue.global().async {
                self.loadImage(url: url)
            }
        }
    }
    
    func loadVideo(url: URL) {
        if ASVideoPlayerController.sharedVideoPlayer.videoCache.object(forKey: url.absoluteString as NSString) != nil {
            self.finish(true)
            self.completionHandler?(nil)
            return
        }
        //6
        if isCancelled {
            self.finish(true)
            self.completionHandler?(nil)
            return
        }
        
        avURLAsset = AVURLAsset(url: url)
        guard let asset = avURLAsset else {
            self.completionHandler?(nil)
            return
        }
        let requestedKeys = ["playable"]
        asset.loadValuesAsynchronously(forKeys: requestedKeys) {
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                break
            case .failed:
                self.finish(true)
                self.executing(false)
                self.completionHandler?(nil)
                return
            case .cancelled:
                self.finish(true)
                self.executing(false)
                self.completionHandler?(nil)
                return
            default:
                self.finish(true)
                self.executing(false)
                self.completionHandler?(nil)
                return
            }
            let player = AVPlayer()
            let item = AVPlayerItem(asset: asset)
            player.automaticallyWaitsToMinimizeStalling = false
            item.preferredForwardBufferDuration = TimeInterval(5)
            DispatchQueue.main.async {
//                let videoContainer = ASVideoContainer(player: player, item: item, url: url.absoluteString)
//                ASVideoPlayerController.sharedVideoPlayer.videoCache.setObject(videoContainer, forKey: url.absoluteString as NSString)
//                videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
                self.finish(true)
                self.executing(false)
                self.completionHandler?(nil)
                /**
                 Try to play video again in case when playvideo method was called and
                 asset was not obtained, so, earlier video must have not run
                 */
            }
        }
    }
    
    func loadImage(url: URL) {
        if isCancelled {
            return
        }
        let downLoadTask = KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let value):
                let imageResult = value.image
//                if let size = self.size, let imageResize = self.resizedImage(img: value.image, for: size) {
//                    imageResult = imageResize
//                }
                if let size = self.size {
                    self.resizedImage(img: imageResult, for: size) { (image) in
                        self.image = image
                        self.completionHandler?(image)
                    }
                }
//                self.resizedImage(img: self.size, for: <#T##CGSize#>, completions: <#T##ImageLoadOperationCompletionHandlerType##ImageLoadOperationCompletionHandlerType##(UIImage?) -> Void#>)
//                self.image = imageResult
//                self.completionHandler?(imageResult)
                break
            case .failure:
                self.completionHandler?(nil)
                break
            }
        }
        self.kingDownLoad = downLoadTask
        
//
        
//        pinRemoteDownload = PINRemoteImageManager.shared().downloadImage(with: url) { [weak self] (result) in
//            guard let this = self,
//                !this.isCancelled,
//                let image = result.image else { return }
//            this.image = image
////            this.completionHandlerUrl?(image, url.absoluteString)
////            this.completionHandler?(image)
//        }
    }
    
    func resizedImage(img: UIImage?, for size: CGSize) -> UIImage? {
        guard let image = img else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    
    func resizedImage(img: UIImage?, for size: CGSize, completions: @escaping ImageLoadOperationCompletionHandlerType){
        guard let image = img else {
            completions(img)
            return
        }
        DispatchQueue.global().async {
            let renderer = UIGraphicsImageRenderer(size: size)
            let imageResize = renderer.image { (context) in
                image.draw(in: CGRect(origin: .zero, size: size))
            }
            completions(imageResize)
        }
    }
}
