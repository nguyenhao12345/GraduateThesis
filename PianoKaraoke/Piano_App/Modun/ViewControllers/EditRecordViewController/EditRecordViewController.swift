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
import Firebase
import YoutubeKit
import MobileCoreServices
import PryntTrimmerView
import FDWaveformView

class EditRecordViewController: AziBaseViewController {
    let conductor = Conductor.sharedInstance
    let storage = Storage.storage()

    //MARK: Outlets
    @IBOutlet weak var trimmerView: TrimmerView!
    @IBOutlet weak var waveform: FDWaveformView!
    var player: AVPlayer?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?

    //MARK: Properties
    var youtubeModel: SearchResult?
    var detailSongModel: DetailInfoSong?
    
    @IBAction func clickExport(_ sender: Any?) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let newVideoOutputURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("Bến thượng hải.mp4"))
        self.loadView(newVideoOutputURL: newVideoOutputURL)

//        cropVideo(sourceURL1: newVideoOutputURL, statTime: Float((trimmerView.startTime?.seconds ?? 0)), endTime: Float((trimmerView.endTime?.seconds ?? 0)))
    }
    
        func cropVideo(sourceURL1: URL, statTime:Float, endTime:Float) {
        let manager = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
        let mediaType = "mp4"
        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
            let asset = AVAsset(url: sourceURL1 as URL)
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            print("video length: \(length) seconds")
            let start = statTime
            let end = endTime
            var outputURL = documentDirectory.appendingPathComponent("WylerNewVideo2")
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                outputURL = outputURL.appendingPathComponent("\(UUID().uuidString).\(mediaType)")
            }catch let error {
                print(error)
            }
            
            //Remove existing file
            _ = try? manager.removeItem(at: outputURL)
            
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            let startTime = CMTime(seconds: Double(start ), preferredTimescale: asset.duration.timescale)
            let endTime = CMTime(seconds: Double(end ), preferredTimescale: asset.duration.timescale)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    
                    DispatchQueue.main.async {
                        self.loadView(newVideoOutputURL: outputURL)
                        print("exported at \(outputURL)")
                    }
                case .failed: break
                case .cancelled: break
                default: break
                }
            }
        }
    }

    //MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initUIVariable() {
        super.initUIVariable()
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor.orange
        trimmerView.positionBarColor = UIColor.white
        trimmerView.minDuration = 1
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let newVideoOutputURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("Bến thượng hải.mp4"))
        loadAsset(AVAsset(url: newVideoOutputURL))
        waveform.alpha = 1
        waveform.zoomSamples = 0 ..< waveform.totalSamples / 3
        waveform.doesAllowScrubbing = true
        waveform.doesAllowStretch = true
        waveform.doesAllowScroll = true
        waveform.audioURL = newVideoOutputURL
    }
    
    func loadView(newVideoOutputURL: URL) {
        trimmerView.asset = nil
        trimmerView.layoutIfNeeded()
        loadAsset(AVAsset(url: newVideoOutputURL))
        waveform.audioURL = newVideoOutputURL
    }
    
    func loadAsset(_ asset: AVAsset) {
        trimmerView.asset = asset
        trimmerView.delegate = self
        addVideoPlayer(with: asset)
    }

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTV: UITextView!

    @IBAction func clickPlay(_ sender: Any?) {

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let newVideoOutputURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("WylerNewVideo.mp4"))

        
        uploadTOFireBaseVideo(url: newVideoOutputURL, success: { (str) in
            self.showToast(string: str, duration: 2.0, position: .top)
        }) { _ in
            self.showToast(string: "Lỗi", duration: 2.0, position: .top)
        }

    }
    
    //MARK: Method
  
    func uploadTOFireBaseVideo(url: URL,
                                      success : @escaping (String) -> Void,
                                      failure : @escaping (Error) -> Void) {
        let timestamp = NSDate().timeIntervalSince1970

        let name = (AppAccount.shared.getUserLogin()?.uid ?? "") + "-\(timestamp.int)" + ".mp4"
        let path = NSTemporaryDirectory() + name

        let data = NSData(contentsOf: url as URL)

        do {

            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)

        } catch {

            print(error)
        }

        // Create file metadata including the content type
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"

        // Upload data and metadata
        
        let storageRef = Storage.storage().reference().child("Mp3").child(name)
        if let uploadData = data as Data? {
            storageRef.putData(uploadData, metadata: metadata
                , completion: { (metadata, error) in
                    if let error = error {
                        failure(error)
                    }else{
                        
                        // Fetch the download URL
                        
                        storageRef.downloadURL { url, error in
                          if let error = error {
                            // TODO
                          } else {
                            guard let url = url else { return }
                            ServiceOnline.share.createPostNews(title: self.titleTF.text ?? "", content: self.contentTV.text ?? "", urlMp3: url.absoluteString, youtubeModel: self.youtubeModel, detailSongModel: self.detailSongModel)
                            
//                            self.video.config(localURL: url.absoluteString)
//                            ASVideoPlayerController.sharedVideoPlayer.playVideo(withCustomAVPlayer: self.video)

                          }
                            success("Thành công")
                        }
                    }
            })
        }
    }
    //DetailSongSectionModel
    //SearchResult
    @IBAction func play(_ sender: Any) {

        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
        } else {
            player.pause()
            stopPlaybackTimeChecker()
        }
    }
    
    private func addVideoPlayer(with asset: AVAsset) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

    }

    @objc func itemDidFinishPlaying(_ notification: Notification) {
        if let startTime = trimmerView.startTime {
            player?.seek(to: startTime)
        }
    }
    
    func startPlaybackTimeChecker() {

        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
            #selector(onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }

    func stopPlaybackTimeChecker() {

        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }

    @objc func onPlaybackTimeChecker() {

        guard let startTime = trimmerView.startTime, let endTime = trimmerView.endTime, let player = player else {
            return
        }

        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            trimmerView.seek(to: startTime)
        }
    }
}
extension EditRecordViewController: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.play()
        startPlaybackTimeChecker()
        print("====> start:\((trimmerView.startTime?.seconds ?? 0)*1000/60) - end: \((trimmerView.endTime?.seconds ?? 0)*1000/60)")
    }

    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//        let duration = (trimmerView.endTime! - trimmerView.startTime!).seconds
        print("====> start:\((trimmerView.startTime?.seconds ?? 0)*1000/60) - end: \((trimmerView.endTime?.seconds ?? 0)*1000/60)")
    }
}
