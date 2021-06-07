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
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var avataImg: ImageViewRound!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var trimmerView: TrimmerView!
    @IBOutlet weak var waveform: FDWaveformView!
    @IBOutlet weak var inputUrlImageTF: UITextField! {
        didSet {
            inputUrlImageTF.attributedPlaceholder = NSAttributedString(string: "Nhập URL hình",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundimageView: UIImageView!
    @IBOutlet weak var backgroundErhuimageView: UIImageView!

    @IBOutlet weak var viewInputURL: UIView!
    @IBAction func clickCancelURLInput(_ sender: Any?) {
        viewInputURL.isHidden = true
        self.view.endEditing(true)
    }
    
    @IBAction func clickAcceptChangeImgae(_ sender: Any?) {
        viewInputURL.isHidden = true
        imageView.setImageURL(URL(string: inputUrlImageTF.text ?? ""))
        backgroundimageView.setImageURL(URL(string: inputUrlImageTF.text ?? ""))
        backgroundErhuimageView.setImageURL(URL(string: inputUrlImageTF.text ?? ""))
    }
    
    @IBAction func clickChangeImage(_ sender: Any?) {
        PopupIGViewController.showAlert(viewController: self, title: "Sửa ảnh xem trước", dataSource: ["\tChọn từ thư viện", "\tNhập từ URL"], hightLight: "\tNhập từ URL", attributes: [NSAttributedString.Key.font : UIFont.HelveticaNeue16, NSAttributedString.Key.foregroundColor : UIColor.defaultText]) { (value, index) in
            if index == 1 {
                self.viewInputURL.isHidden = false
                self.inputUrlImageTF.becomeFirstResponder()
            }
        }
    }
    var player: AVPlayer?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?

    //MARK: Properties
    var youtubeModel: SearchResult?
    var detailSongModel: DetailInfoSong?
    
    func exportVideo(completion: @escaping ()->()) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let newVideoOutputURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("WylerNewVideo.mp4"))
        cropVideo(sourceURL1: newVideoOutputURL,
                  statTime: Float((trimmerView.startTime?.seconds ?? 0)),
                  endTime: Float((trimmerView.endTime?.seconds ?? 0))) {
                    completion()
        }
    }
    
    func cropVideo(sourceURL1: URL, statTime:Float, endTime:Float, completion: @escaping ()->()) {
        let manager = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
        let mediaType = "mp4"
        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
            let asset = AVAsset(url: sourceURL1 as URL)
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            print("video length: \(length) seconds")
            let start = statTime
            let end = endTime
            let outputURL = documentDirectory.appendingPathComponent("WylerNewVideo.mp4")

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
//                        self.loadView(newVideoOutputURL: outputURL)
                        completion()
                    }
                case .failed: break
                case .cancelled: break
                default: break
                }
            }
        }
    }


    
    override func initUIVariable() {
        super.initUIVariable()
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        player?.pause()
        self.dismiss()
    }
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userModel = AppAccount.shared.getUserLogin() else { return }
        avataImg.setImageURL(URL(string: userModel.avata))
        userNameLbl.text = userModel.name
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor(hexString: AppColor.shared.colorBackGround.value) ?? .white
        trimmerView.positionBarColor = UIColor.white
        trimmerView.minDuration = 1
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let newVideoOutputURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("WylerNewVideo.mp4"))
        loadAsset(AVAsset(url: newVideoOutputURL))
        waveform.alpha = 1
        waveform.doesAllowStretch = false
        waveform.doesAllowScroll = false
        waveform.progressColor = .lightGray
        waveform.audioURL = newVideoOutputURL
        waveform.wavesColor = .white
        adminButton.isHidden = userModel.admin != 1
        if let urlYoutube = youtubeModel?.snippet.thumbnails.high.url {
            imageView.setImageURL(URL(string: urlYoutube))
            backgroundimageView.setImageURL(URL(string: urlYoutube))
            backgroundErhuimageView.setImageURL(URL(string: urlYoutube))
        } else if let url = detailSongModel?.imageSong {
            imageView.setImageURL(URL(string: url))
            backgroundimageView.setImageURL(URL(string: url))
            backgroundErhuimageView.setImageURL(URL(string: url))
        }
        play(nil)
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

    @IBOutlet weak var titleTF: UITextField! {
        didSet {
            titleTF.attributedPlaceholder = NSAttributedString(string: "Tiêu đề",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        }
    }
    @IBOutlet weak var contentTV: UITextView!  {
           didSet {
               contentTV.delegate = self
           }
       }

    @IBAction func clickPostNews(_ sender: Any?) {
        self.view.endEditing(true)
        LOADING_HELPER.show()
        exportVideo {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let newVideoOutputURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("WylerNewVideo.mp4"))

            self.uploadTOFireBaseVideo(url: newVideoOutputURL, success: { (str) in
                LOADING_HELPER.dismiss()
                LocalVideoManager.shared.removeFileLocal(name: "WylerNewVideo")
                self.showToast(string: str, duration: 2.0, position: .top)
                AppRouter.shared.backToRoot(viewController: self)
            }) { _ in
                self.showToast(string: "Lỗi", duration: 2.0, position: .top)
            }
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
                            if error != nil {
                            // TODO
                          } else {
                            guard let url = url else { return }
                                var textContent: String = ""
                                if self.contentTV.text == "Mô tả" {
                                    textContent = ""
                                } else {
                                    textContent = self.contentTV.text ?? ""
                                }
                                ServiceOnline.share.createPostNews(title: self.titleTF.text ?? "", content: textContent, urlMp3: url.absoluteString, urlThumnail: self.inputUrlImageTF.text ?? "", youtubeModel: self.youtubeModel, detailSongModel: self.detailSongModel)
                            
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
    @IBAction func play(_ sender: Any?) {

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
        print("====> start:\((trimmerView.startTime?.seconds ?? 0)*1000/60) - end: \((trimmerView.endTime?.seconds ?? 0)*1000/60)")
    }
}


extension EditRecordViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
//        if textView.text == "" {
//            textView.text = "Mô tả"
//        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Mô tả" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Mô tả"
        }
    }
}

