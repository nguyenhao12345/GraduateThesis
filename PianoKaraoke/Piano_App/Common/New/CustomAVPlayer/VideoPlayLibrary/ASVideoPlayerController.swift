//
//  ASVideoPlayerController.swift
//  Azibai
//
//  Created by ToanHT on 8/21/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import UIKit
import AVFoundation
import IGListKit
/**
 Protocol that needs to be adopted by subclass of any UIView
 that wants to play video.
 */
protocol ASAutoPlayVideoLayerContainer {
    var videoURL: String? { get set }
    var videoLayer: AVPlayerLayer { get set }
    func visibleVideoFrame() -> CGRect
}

class ASVideoPlayerController: NSObject, NSCacheDelegate {
    
    static let assetKeysRequiredToPlay = [
        "playable"
    ]
    
    var colletionView: UICollectionView?
    
    //hieu todo
    var lastContentOffset:  CGFloat = 0
    
    var minimumLayerHeightToPlay: CGFloat = 60
    var minimumLayerWidthToPlay: CGFloat = 100
    // Mute unmute video
    var mute = false
    var preferredPeakBitRate: Double = .zero
    static private var playerViewControllerKVOContext = 0
    static let sharedVideoPlayer = ASVideoPlayerController()
    //video url for currently playing video
    private var videoURL: String?
    /**
     Stores video url as key and true as value when player item associated to the url
     is being observed for its status change.
     Helps in removing observers for player items that are not being played.
     */
    private var observingURLs = Dictionary<String, Bool>()
    // Cache of player and player item
    var videoCache = NSCache<NSString, ASVideoContainer>()
    // Current AVPlapyerLayer that is playing video
    private var currentLayer: AVPlayerLayer?
    
    private var _rateObserver: NSKeyValueObservation?
//    private var _statusObserver: NSKeyValueObservation?
    private var _audioQueueWaitingObserver: NSKeyValueObservation?
    private var audioQueueStallObserver: NSKeyValueObservation?
    
    var keepUpObservation: NSKeyValueObservation?
    var emptyObservation: NSKeyValueObservation?
    
    
    //    private var _periodicTimeObserver: Any?
    private var timeObserverToken: Any?
    
    private var _assetRequests : [String: AVURLAsset] = [:]
    private var _isAlwayMuteRequests : [String: Bool] = [:]
    private var maxCountQueue = 2
    private var queue = Queue()
    private var queueVideosPlaying = QueueVideosPlaying()
    
    lazy var loadingQueue: OperationQueue = {
           var queue = OperationQueue()
           queue.name = "Download queue"
           queue.maxConcurrentOperationCount = 1
           return queue
       }()
       
    lazy var loadingOperations = NSCache<NSString, ImageLoadOperation>()
    
    fileprivate enum ObservableKeyPaths: String {
        case status, rate, timeControlStatus, likelyToKeepUp
        static let allValues = [status, rate, timeControlStatus, likelyToKeepUp ]
    }
    
    var currentCustomAVPlayer: CustomAVPlayer?
    
    override init() {
        super.init()
        videoCache.delegate = self
        videoCache.totalCostLimit = 20
    }
    
    
    /**
     Download of an asset of url if corresponding videocontainer
     is not present.
     Uses the asset to create new playeritem.
     */
    
    func setUpVideoForLocal(customAVPlayer: CustomAVPlayer, setupAgain: Bool = false, isAlwaysMute: Bool = false) {
        guard let url = customAVPlayer.videoURL else {
            return
        }
    
        let player = AVPlayer(url: URL(fileURLWithPath: url))  // video path coming from above
        let videoContainer = ASVideoContainer(player: player, item: AVPlayerItem(asset: AVAsset(url: URL(fileURLWithPath: url))), url: url, isAlwaysMute: isAlwaysMute, size: customAVPlayer.currentSize)
        
        self.videoCache.setObject(videoContainer, forKey: url as NSString)
        videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
        /**
         Try to play video again in case when playvideo method was called and
         asset was not obtained, so, earlier video must have not run
         */
        if customAVPlayer.videoLayer == self.currentLayer, customAVPlayer.videoURL == url {
            self.playVideo(withCustomAVPlayer: customAVPlayer)
        }

    }
    
    func setupVideoFor(customAVPlayer: CustomAVPlayer, setupAgain: Bool = false, isAlwaysMute: Bool = false) {
        guard let url = customAVPlayer.videoURL else {
            return
        }
        if self.videoCache.object(forKey: url as NSString) != nil {
            return
        }
        guard let URL = URL(string: url) else {
            return
        }
        
        if queue.items.count > maxCountQueue {
            if let url = queue.dequeue() {
                if url != videoURL {
                    if let asset = _assetRequests.removeValue(forKey: url) {
                        asset.cancelLoading()
                    }
                }
            }
        }
        queue.enqueue(element: url)
        
        if setupAgain && _assetRequests[url] != nil {
            _assetRequests.forEach { (_, asset) in
                if asset.url.absoluteString != url {
                    asset.cancelLoading()
                }
            }
            return
        }
        print("ToanHT setupAgain \(setupAgain), url: \(url)")
        let asset = AVURLAsset(url: URL)
        _isAlwayMuteRequests[url] = isAlwaysMute
        _assetRequests[url] = asset
        asset.loadValuesAsynchronously(forKeys: ASVideoPlayerController.assetKeysRequiredToPlay) {
            DispatchQueue.main.async {
                if let _ = self._assetRequests.removeValue(forKey: asset.url.absoluteString) { }
                var error: NSError? = nil
                let status = asset.statusOfValue(forKey: "playable", error: &error)
                switch status {
                case .loaded:
                    break
                case .failed:
                    return
                case .cancelled:
                    return
                default:
                    return
                }
                let player = AVPlayer()
                let item = AVPlayerItem(asset: asset)
                player.automaticallyWaitsToMinimizeStalling = false
                item.preferredForwardBufferDuration = TimeInterval(1)
                let videoContainer = ASVideoContainer(player: player, item: item, url: asset.url.absoluteString, isAlwaysMute: isAlwaysMute, size: customAVPlayer.currentSize)
                self.videoCache.setObject(videoContainer, forKey: asset.url.absoluteString as NSString)
                videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
                /**
                 Try to play video again in case when playvideo method was called and
                 asset was not obtained, so, earlier video must have not run
                 */
                if self.videoURL == asset.url.absoluteString && customAVPlayer.videoLayer == self.currentLayer, customAVPlayer.videoURL == asset.url.absoluteString{
                        self.playVideo(withCustomAVPlayer: customAVPlayer)
                }
            }
        }
    }
    
    //ToanHT todo
    func cancelAssetRequest() {
//        self.asset?.cancelLoading()
    }
    
    func cancelAssetRequest(url: String) {
        if let asset = self._assetRequests.removeValue(forKey: url) {
            asset.cancelLoading()
        }
    }
        
    
    // Play video with the CustomAVPlayer provided
    func playVideo(withCustomAVPlayer customAVPlayer: CustomAVPlayer) {
            guard let url = customAVPlayer.videoURL else { return }
            videoURL = url
            currentLayer = customAVPlayer.videoLayer
            currentCustomAVPlayer = customAVPlayer
            customAVPlayer.configCurrentVideoState(state: .waiting)
            self.prepareForPlayNextVideo(withNextCustomAVPlayer: customAVPlayer)
            if let videoContainer = self.videoCache.object(forKey: url as NSString) {
                if customAVPlayer.videoLayer.player != videoContainer.player {
                    customAVPlayer.videoLayer.player = videoContainer.player
                }
                if videoContainer.player.currentItem != videoContainer.playerItem {
                    videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
                }
                videoContainer.playOn = true
                addObservers(url: url, videoContainer: videoContainer, customAVPlayer: customAVPlayer)
            } else {
                setupVideoFor(customAVPlayer: customAVPlayer, setupAgain: true)
            }
            // Give chance for current video player to be ready to play
    //        DispatchQueue.main.async { [weak self ] in
    //            guard let this = self else { return }
    //            if let videoContainer = this.videoCache.object(forKey: url as NSString),
    //                videoContainer.player.currentItem?.status == .readyToPlay {
    //                videoContainer.playOn = true
    //                customAVPlayer.configCurrentVideoState(state: .playing)
    //            }
    //        }
        }
    
    func pauseVideo(withCustomAVPlayer customAVPlayer: CustomAVPlayer) {
        guard let url = customAVPlayer.videoURL else { return }
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
            customAVPlayer.configCurrentVideoState(state: .pausing)
            customAVPlayer.configIndicatorView(value: true)
        }
    }
    
    func prepareForPlayNextVideo(withNextCustomAVPlayer nextCustomAVPlayer: CustomAVPlayer) {
        if let currentAV = queueVideosPlaying.getLastItem(), currentAV == nextCustomAVPlayer, currentAV.videoURL == nextCustomAVPlayer.videoURL {
            return
        }
        if let previousAVPlayer = queueVideosPlaying.dequeue() {
            previousAVPlayer.videoLayer.player = nil
            if let url = previousAVPlayer.videoURL{
                if let container = self.videoCache.object(forKey: url as NSString) {
                    container.playOn = false
                    container.player.replaceCurrentItem(with: nil)
                }
                removeObserverFor(url: url)
            }
            previousAVPlayer.indicatorView.isHidden = true
        }
        queueVideosPlaying.enqueue(element: nextCustomAVPlayer)
    }
    
    func removeLayerFor(customAVPlayer: CustomAVPlayer) {
        if let url = customAVPlayer.videoURL {
            cancelAssetRequest(url: url)
            removeFromSuperLayer(layer: customAVPlayer.videoLayer, url: url)
        }
    }
    
    private func removeFromSuperLayer(layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
            videoContainer.player.replaceCurrentItem(with: nil)
        }
        layer.player = nil
    }
    
    func removeObjectCache(url: String?){
        guard let url = url, let _ = self.videoCache.object(forKey: url as NSString)  else { return }
        self.videoCache.removeObject(forKey: url as NSString)
    }
    
    
    func pauseRemoveLayer(customAVPlayer: CustomAVPlayer) {
        pauseVideo(withCustomAVPlayer: customAVPlayer)
    }
    
    
    //ToanHT comment -- Turn off autoplay when video finnish
    // Play video again in case the current player has finished playing
    //    @objc func playerDidFinishPlaying(note: NSNotification) {
    //        guard let playerItem = note.object as? AVPlayerItem,
    //            let currentPlayer = currentVideoContainer()?.player else {
    //                return
    //        }
    //        if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
    //            currentPlayer.seek(to: CMTime.zero)
    //            currentPlayer.play()
    //        }
    //    }
    
    private func currentVideoContainer() -> ASVideoContainer? {
        if let currentVideoUrl = videoURL {
            if let videoContainer = videoCache.object(forKey: currentVideoUrl as NSString) {
                return videoContainer
            }
        }
        return nil
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        currentCustomAVPlayer?.delegate?.finishedPlayingVideo()
    }
    
    private func addObservers(url: String, videoContainer: ASVideoContainer, customAVPlayer: CustomAVPlayer) {
        if self.observingURLs[url] == false || self.observingURLs[url] == nil {
            videoContainer.player.currentItem?.addObserver(self,
                                                           forKeyPath: "status",
                                                           options: [.new, .initial],
                                                           context: &ASVideoPlayerController.playerViewControllerKVOContext)
                NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying(_:)),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoContainer.player)

            audioQueueStallObserver = videoContainer.player.observe(\.timeControlStatus) { (item, change) in
                switch item.timeControlStatus {
                case .paused:
                    customAVPlayer.configIndicatorView(value: true)
                    break
                case .playing:
                    customAVPlayer.configIndicatorView(value: true)
                    break
                case .waitingToPlayAtSpecifiedRate:
                    customAVPlayer.configIndicatorView(value: false)
                    break
                @unknown default:
                    break
                }
            }
            

            addPeriodicTimeObserver(player: videoContainer.player, customAVPlayer: customAVPlayer)
            _rateObserver = videoContainer.player.observe(\.rate, options:  [.new, .old], changeHandler: { [weak self] (player, change) in
                guard let this = self else { return }
                if player.rate == 1  {
                    customAVPlayer.configTotalTime(value: Float(player.currentItem!.asset.duration.seconds))
                    this._rateObserver?.invalidate()
                    this._rateObserver = nil
                }
            })

            self._audioQueueWaitingObserver = videoContainer.player.observe(\.reasonForWaitingToPlay, options: [.new, .old], changeHandler: {
                (playerItem, change) in
                if let _ = playerItem.reasonForWaitingToPlay?.rawValue {
                    customAVPlayer.configIndicatorView(value: false)
                } else {
                    customAVPlayer.configIndicatorView(value: true)
                }
            })
            self.observingURLs[url] = true
        }
    }
    
    private func removeObserverFor(url: String) {
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            if observingURLs[url] == true {
                if let currentItem = videoContainer.player.currentItem{
                    currentItem.removeObserver(self,
                                               forKeyPath: "status",
                                               context: &ASVideoPlayerController.playerViewControllerKVOContext)
                    NotificationCenter.default.removeObserver(self,
                                                              name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                              object: currentItem)

                }
//                //ToanHT todo add
                removePeriodicTimeObserver(player: videoContainer.player)

                _rateObserver?.invalidate()
                _rateObserver = nil
                _audioQueueWaitingObserver?.invalidate()
                self._audioQueueWaitingObserver = nil
                
                
//                keepUpObservation?.invalidate()
//                emptyObservation?.invalidate()
//                self.keepUpObservation = nil
//                self.emptyObservation = nil
                audioQueueStallObserver?.invalidate()
                self.audioQueueStallObserver = nil
                observingURLs[url] = false
            }
        }
    }
    
    // Set observing urls false when objects are removed from cache
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let videoObject = obj as? ASVideoContainer {
            observingURLs[videoObject.url] = false
        }
    }
    
    // Play video only when current videourl's player is ready to play
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        // Make sure the this KVO callback was intended for this view controller.
        guard context == &ASVideoPlayerController.playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        switch keyPath {
        case "status":
            /**
             Handle `NSNull` value for `NSKeyValueChangeNewKey`, i.e. when
             `player.currentItem` is nil.
             */
            let newStatus: AVPlayerItem.Status
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue)!
                if newStatus == .readyToPlay {
                    guard let item = object as? AVPlayerItem,
                        let currentItem = currentVideoContainer()?.player.currentItem else {
                            return
                    }
                    if item == currentItem && currentVideoContainer()?.playOn == true {
                        currentVideoContainer()?.playOn = true
                        if let layer = currentCustomAVPlayer {
                            layer.configCurrentVideoState(state: .playing)
                        }
                    }
                }
            }
            else {
                newStatus = .unknown
            }
            if newStatus == .failed {
                
            }
            break
//        case "timeControlStatus":
//            if let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int,
//                let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
//                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
//                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
//                if newStatus != oldStatus {
//                    DispatchQueue.main.async {[weak self] in
//                        if newStatus == .playing || newStatus == .paused {
////                            self?.currentCustomAVPlayer?.configIndicatorView(value: false)
//                        } else {
////                            self?.currentCustomAVPlayer?.configIndicatorView(value: true)
//                        }
//                    }
//                }
//            }
//            break
        default:
            break
        }
    }
    
    func clear() {
        observingURLs.removeAll()
        videoCache.removeAllObjects()
    }
    
    func pauseForceCurrent() {
        self.currentLayer?.player?.pause()
    }
    
    deinit {
        
    }
}


//ToanHT
extension ASVideoPlayerController {
    func addPeriodicTimeObserver(player: AVPlayer, customAVPlayer: CustomAVPlayer) {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 1, preferredTimescale: timeScale)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                           queue: .main) { time in
                                                            customAVPlayer.configCurrentTime(currentTime: time.seconds)
        }
    }
    
    func removePeriodicTimeObserver(player: AVPlayer) {
        guard player.isPlaying else {return}
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
}

extension ASVideoPlayerController {
   
}

extension ASVideoPlayerController {
    /**
     Play UITableViewCell's videoplayer that has max visible video layer height
     when the scroll stops.
     */
    
    func pausePlayVideoVertical(collectionContext: ListCollectionContext, appEnteredFromBackground: Bool = false, listSectionController: ListSectionController) {
//        collectionContext.visibleCells(for: <#T##ListSectionController#>).compactMap { (<#UICollectionViewCell#>) -> ElementOfResult? in
//            <#code#>
//        }
        let playableVisisbleCells = collectionContext.visibleCells(for: listSectionController).sorted(by: { (cell1, cell2) -> Bool in
            cell1.frame.maxY < cell2.frame.maxY
        }).compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo
            })
        
        guard playableVisisbleCells.count > 0 else { return }
        var videoCellContainer: VideoPlayableViewContainer?
        var maxHeight: CGFloat = 0.0
        for cellView in playableVisisbleCells {
            let height = cellView.visibleVideoFrame.height
            if maxHeight < height {
                maxHeight = height
                videoCellContainer = cellView
            }
            cellView.pauseVideo()
        }
        guard let videoCell = videoCellContainer else {
            return
        }
        let minCellLayerHeight = videoCell.heightSizeViewContainer
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        if maxHeight >= minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                videoCell.setupVideo()
            }
//            CustomAVPlayer.globalPlayer?.videoLayer.player?.pause()
            videoCell.playVideo()
            print("PlayVideo: \(videoCell)")
        }
    }
    
    func pausePlayVideo(tableView: UITableView, appEnteredFromBackground: Bool = false, isRequestPlayFirstVideo: Bool = false) {
        let playableVisisbleCells = tableView.visibleCells.compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo })
        guard playableVisisbleCells.count > 0 else { return }
        var videoCellContainer: VideoPlayableViewContainer?
        var maxHeight: CGFloat = 0.0
        
        if isRequestPlayFirstVideo {
            var isHave = false
            for cellView in playableVisisbleCells {
                let height = cellView.visibleVideoFrame.height
                if maxHeight < height &&  !isHave{
                    maxHeight = height
                    videoCellContainer = cellView
                    isHave = true
                }
                cellView.pauseVideo()
            }
        } else {
            for cellView in playableVisisbleCells {
                let height = cellView.visibleVideoFrame.height
                if maxHeight < height{
                    maxHeight = height
                    videoCellContainer = cellView
                }
                if cellView.heightSizeViewContainer > height {
                    cellView.pauseVideo()
                }
            }
        }

        guard let videoCell = videoCellContainer else {
                return
        }
        let minCellLayerHeight = videoCell.heightSizeViewContainer
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        if maxHeight >= minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                videoCell.setupVideo()
            }
            videoCell.playVideo()
        }
    }
    func pausePlayVideoVertical2(collectionView: UICollectionView, appEnteredFromBackground: Bool = false) {
        let playableVisisbleCells = collectionView.visibleCells.compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo })
        guard playableVisisbleCells.count > 0 else { return }
        var videoCellContainer: VideoPlayableViewContainer?
        var maxHeight: CGFloat = 0.0
        for cellView in playableVisisbleCells {
            let height = cellView.visibleVideoFrame.height
            if maxHeight < height {
                maxHeight = height
                videoCellContainer = cellView
            }
            cellView.pauseVideo()
        }
        guard let videoCell = videoCellContainer else {
            return
        }//0x7fe709f06a10  //0x7fe703bb4f90
        let minCellLayerHeight = videoCell.heightSizeViewContainer
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        if maxHeight >= minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                videoCell.setupVideo()
            }
            videoCell.playVideo()
        }
    }
    func pausePlayVideo(collectionView: UICollectionView, appEnteredFromBackground: Bool = false) {
        let playableVisisbleCells = collectionView.visibleCells.compactMap({
            $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo })
        guard playableVisisbleCells.count > 0 else { return }
        var videoCellContainer: VideoPlayableViewContainer?
        var maxWidth: CGFloat = 0.0
        for cellView in playableVisisbleCells {
            let width = cellView.visibleVideoFrame.width
            if maxWidth < width {
                maxWidth = width
                videoCellContainer = cellView
            }
            cellView.pauseVideo()
            print("PAUSE =======>>> \(cellView)")
        }
        guard let videoCell = videoCellContainer else {
            return
        }
        let minCellLayerWidth = videoCell.widthSizeViewContainer
        let minimumVideoLayerVisibleWidth = max(minCellLayerWidth, minimumLayerWidthToPlay)
        if maxWidth >= minimumVideoLayerVisibleWidth {
            if appEnteredFromBackground {
                videoCell.setupVideo()
            }
            videoCell.playVideo()
            print("PLAY =======>>> \(videoCell)")

        }
    }
    
    func pausePlayVideoHorizon(collectionView: UICollectionView, appEnteredFromBackground: Bool = false) {
        let playableVisisbleCells = collectionView.visibleCells.sorted { (imp1, imp2) -> Bool in
            imp1.frame.maxX < imp2.frame.maxX
            }.compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo })
//        let playableVisisbleCells = collectionView.visibleCells.compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo })
        guard playableVisisbleCells.count > 0 else { return }
        var videoCellContainer: VideoPlayableViewContainer?
        var maxWidth: CGFloat = 0.0
        for cellView in playableVisisbleCells {
            let width = cellView.visibleVideoFrame.width
            if maxWidth < width {
                maxWidth = width
                videoCellContainer = cellView
            }
            cellView.pauseVideo()
        }
        guard let videoCell = videoCellContainer else {
            return
        }
        let minCellLayerWidth = videoCell.widthSizeViewContainer
        let minimumVideoLayerVisibleWidth = max(minCellLayerWidth, minimumLayerWidthToPlay)
        if maxWidth >= minimumVideoLayerVisibleWidth {
            if appEnteredFromBackground {
                videoCell.setupVideo()
            }
            videoCell.playVideo()
        }
    }
    func pausePlayVideoVertical(collectionView: UICollectionView, appEnteredFromBackground: Bool = false) {
        if (self.lastContentOffset > collectionView.contentOffset.y) {
            // move up
            print("scroll tren xuong")
            let playableVisisbleCells = collectionView.visibleCells.sorted { (imp1, imp2) -> Bool in
                imp1.frame.maxY > imp2.frame.maxY
                }.compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo })
            guard playableVisisbleCells.count > 0 else { return }
            var videoCellContainer: VideoPlayableViewContainer?
            var maxHeight: CGFloat = 0.0
            for cellView in playableVisisbleCells {
                let height = cellView.visibleVideoFrame.height
                if maxHeight < height {
                    maxHeight = height
                    videoCellContainer = cellView
                }
                cellView.pauseVideo()
            }
            
            if collectionView.isAtTop {
                videoCellContainer = playableVisisbleCells[playableVisisbleCells.count-1]
            }
       
            
            guard let videoCell = videoCellContainer else { return }
            let minCellLayerHeight = videoCell.heightSizeViewContainer
            let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
            if maxHeight >= minimumVideoLayerVisibleHeight {
                if appEnteredFromBackground {
                    videoCell.setupVideo()
                }
                videoCell.playVideo()
            }
            
        }
        else if (self.lastContentOffset < collectionView.contentOffset.y) {
            // move down
            print("scroll duoi len")
            let playableVisisbleCells = collectionView.visibleCells.sorted { (imp1, imp2) -> Bool in
                imp1.frame.maxY < imp2.frame.maxY
                }.compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo })
            guard playableVisisbleCells.count > 0 else { return }
            var videoCellContainer: VideoPlayableViewContainer?
            var maxHeight: CGFloat = 0.0
            for cellView in playableVisisbleCells {
                let height = cellView.visibleVideoFrame.height
                if maxHeight < height {
                    maxHeight = height
                    videoCellContainer = cellView
                }
                cellView.pauseVideo()
            }
            
            if collectionView.isAtBottom {
                videoCellContainer = playableVisisbleCells[playableVisisbleCells.count-1]
            }

            guard let videoCell = videoCellContainer else { return }
            let minCellLayerHeight = videoCell.heightSizeViewContainer
            let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
            if maxHeight >= minimumVideoLayerVisibleHeight {
                if appEnteredFromBackground {
                    videoCell.setupVideo()
                }
                videoCell.playVideo()
            }
            
        }
        else {
            let playableVisisbleCells = collectionView.visibleCells.sorted { (imp1, imp2) -> Bool in
                imp1.frame.maxY < imp2.frame.maxY
                }.compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo })
            
            guard playableVisisbleCells.count > 0 else { return }
            var videoCellContainer: VideoPlayableViewContainer?
            var maxHeight: CGFloat = 0.0
            for cellView in playableVisisbleCells {
                let height = cellView.visibleVideoFrame.height
                if maxHeight < height {
                    maxHeight = height
                    videoCellContainer = cellView
                }
                cellView.pauseVideo()
            }
            
            if collectionView.isAtBottom {
                videoCellContainer = playableVisisbleCells[playableVisisbleCells.count-1]
            }
            
            guard let videoCell = videoCellContainer else { return }
            let minCellLayerHeight = videoCell.heightSizeViewContainer
            let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
            if maxHeight >= minimumVideoLayerVisibleHeight {
                if appEnteredFromBackground {
                    videoCell.setupVideo()
                }
                videoCell.playVideo()
            }
        }
        self.lastContentOffset = collectionView.contentOffset.y

    }
}

struct Queue{

    var items:[String] = []
    
    mutating func enqueue(element: String)
    {
        items.append(element)
    }
    
    mutating func dequeue() -> String?
    {
        
        if items.isEmpty {
            return nil
        }
        else{
            let tempElement = items.first
            items.remove(at: 0)
            return tempElement
        }
    }
    
}


struct QueueVideosPlaying{

    var items:[CustomAVPlayer] = []
    
    mutating func enqueue(element: CustomAVPlayer)
    {
        CustomAVPlayer.globalPlayer = element
        items.append(element)
    }
    
    mutating func dequeue() -> CustomAVPlayer?
    {
        
        if items.isEmpty {
            return nil
        }
        else{
            let tempElement = items.first
            items.remove(at: 0)
            return tempElement
        }
    }
    
    func getLastItem() -> CustomAVPlayer? {
        return items.last
    }

    func getFirstItem() -> CustomAVPlayer? {
        return items.first
    }

    
}

extension UIScrollView {
    
    var isAtTopCenter : Bool {
        
        return contentOffset.y == verticalOffsetForTop
        
    }
    
    var isAtTop : Bool {
        
        return contentOffset.y == verticalOffsetForTop
        
    }
    
    var isAtBottom : Bool {
        
        return contentOffset.y >= verticalOffsetForBottom
        
    }
    
    var isAtRight: Bool {
        return contentOffset.x == horizontalOffsetForRight
    }
    
    var verticalOffsetForTop : CGFloat {
        
        let topInset = contentInset.top
        return -topInset
        
    }
    
    var verticalOffsetForBottom : CGFloat {
        
        let scrollViewHeight = bounds.size.height
        let contentHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = contentHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
        
    }
    
    var horizontalOffsetForRight : CGFloat {
        
        let scrollViewWidth = bounds.size.width
        let contentWidth = contentSize.width
        let WidthInset = contentInset.right
        let scrollViewWidthOffset = contentWidth + WidthInset - scrollViewWidth
        return scrollViewWidthOffset
    }
    
}
