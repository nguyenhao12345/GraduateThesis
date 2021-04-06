//
//  EditRecordViewController.swift
//  Piano_App
//
//  Created by Azibai on 31/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit
import AudioKit
import AVFoundation

class EditRecordViewController: AziBaseViewController {
    let conductor = Conductor.sharedInstance

    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = []

    //MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initUIVariable() {
        super.initUIVariable()
//        self.allowAutoPlay = true
//        self.hidesNavigationbar = true
//        self.hidesToolbar = true
//        self.addPansGesture = true
//        self.colorStatusBar = .black
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
    }
    
    @IBAction func clickPlay(_ sender: Any?) {
        do {
//            let player = try AKAudioPlayer(file: conductor.tape!)
//            do {
//                try player.reloadFile()
//            } catch {
//                AKLog("Couldn't reload file.")
//            }
            
            //            let player2 = AKPlayer(url: conductor.recorder?.audioFile.)
//            player2?.play()
            // If the tape is not empty, we can play it !...
//            if player.audioFile.duration ?? 0 > 0 {
//                player.play()
//
//            } else {
//            }

        } catch {
            
        }
//        let asset = conductor.recorder?.audioFile?.avAsset
//        let player = AVPlayer()
//        let item = AVPlayerItem(asset: asset)
//

//        conductor.recorder?.audioFile?.exportAsynchronously(name: "HieuExPort", baseDir: .documents, exportFormat: .wav, callback: { (file, error) in
//            guard let asset = file?.avAsset else { return }
//            do {
//                conductor.recorder?.audioFile?.url
//                var player: AVAudioPlayer?
//                player = try AVAudioPlayer(contentsOf: conductor.recorder?.audioFile?.url)
//                guard let _player = player else { return }
//
//                _player.prepareToPlay()
//                _player.play()
//
//            } catch let error as NSError {
//                print(error.description)
//            }
//
//        })
//        guard let url = conductor.recorder?.audioFile?.url else { return }
//        do {
//
//            var player: AVAudioPlayer?
//            player = try AVAudioPlayer(contentsOf: url)
//            guard let _player = player else { return }
//
//            _player.prepareToPlay()
//            _player.play()
//
//        } catch let error as NSError {
//            print(error.description)
//        }
        
//        guard let audioURL = conductor.recorder?.audioFile?.url else { return }
//
//        let fileMgr = FileManager.default
//
//        let dirPaths = fileMgr.urls(for: .documentDirectory,
//                                    in: .userDomainMask)
//
//        let outputUrl = dirPaths[0].appendingPathComponent("audiosound.mp4")
//
//        let asset = AVAsset.init(url: audioURL)
//
//        let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetHighestQuality)
//
//        // remove file if already exits
//        let fileManager = FileManager.default
//        do{
//            try? fileManager.removeItem(at: outputUrl)
//
//        } catch{
//            print("can't")
//        }
//
//
//        exportSession?.outputFileType = AVFileType.mp4
//
//        exportSession?.outputURL = outputUrl
//
//        exportSession?.metadata = asset.metadata
//
//        exportSession?.exportAsynchronously(completionHandler: {
//            if (exportSession?.status == .completed)
//            {
//                print("AV export succeeded.")
//                let play = AVPlayer(playerItem: AVPlayerItem(asset: AVAsset(url: outputUrl)))
//               // outputUrl to post Audio on server
//                play.seek(to: .zero)
//                play.volume = 1
//                play.isMuted = false
//                play.play()
//
//            }
//            else if (exportSession?.status == .cancelled)
//            {
//                print("AV export cancelled.")
//            }
//            else
//            {
//                print ("Error is \(String(describing: exportSession?.error))")
//
//            }
//        })
        video.config(localURL: LocalVideoManager.shared.getURLVideoLocal(key: "audioFile", file: "m4a"))
        ASVideoPlayerController.sharedVideoPlayer.playVideo(withCustomAVPlayer: video)
        
//        let recordingSession = AVAudioSession.sharedInstance()
//        do {
//            // Set the audio session category, mode, and options.
//            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
//            try recordingSession.setActive(true)
//        } catch {
//            print("Failed to set audio session category.")
//        }

    }
    
    @IBOutlet weak var video: CustomAVPlayer!
    //MARK: Method
    func viewIsReady() {
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
        adapter.scrollViewDelegate = self
        
//        if let file = conductor.recorder?.audioFile {
//            player = try? AKAudioPlayer(file: file)
//        }
//        player.looping = true
//        player.completionHandler = playingEnded

        



    }
    
    override func loadMore() {
        
    }
    
    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        
    }
    
    override func getScrollView() -> UIScrollView? {
        return collectionView
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .None
    }
    
}

//MARK: ListAdapterDataSource
extension EditRecordViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return sectionBuilder.getSection(object: object, presenter: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

//MARK: IGListAdapterDelegate
extension EditRecordViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}
