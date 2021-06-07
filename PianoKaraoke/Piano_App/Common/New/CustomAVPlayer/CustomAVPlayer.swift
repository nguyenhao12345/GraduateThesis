//
//  CustomAVPlayer.swift
//  Azibai
//
//  Created by Tran Quoc Loc on 1/7/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import PINRemoteImage

protocol CustomAVPlayerDelegate: class {
    func customAVPlayerDidTap(view: CustomAVPlayer)
    func customAVPlayerPlayButtonTapped(isPlaying: Bool)
    func finishedPlayingVideo()
}

class CustomAVPlayer: UIView, ASAutoPlayVideoLayerContainer  {
    
    static var globalPlayer: CustomAVPlayer?
//    {
//        didSet {
//            if oldValue != globalPlayer {
//                oldValue?.pause()
//            }
//        }
//    }
    
    enum CurrentVideoState {
        case playing
        case pausing
        case waiting
        case none
    }
    
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.layer.zPosition = 997
        }
    }
    @IBOutlet weak var controlsContainerView: UIView! {
        didSet {
            controlsContainerView.layer.zPosition = 999
            controlsContainerView.isUserInteractionEnabled = true
            let _tap = UITapGestureRecognizer(target: self, action: #selector(_controlsContainerViewTapHandler(_:)))
            controlsContainerView.addGestureRecognizer(_tap)
        }
    }
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView! {
        didSet {
            indicatorView.layer.zPosition = 998
            indicatorView.startAnimating()
            indicatorView.isHidden = true
        }
    }
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var muteButton: UIButton! {
        didSet {
            muteButton.layer.zPosition = 1000
//            self.muteButton.setImage(ASVideoPlayerController.sharedVideoPlayer.mute ? UIImage(named: "mute") : UIImage(named: "unmute"), for: .normal)
            self.muteButton.setImage(UIImage(named: "unmute"), for: .normal)
            muteButton.isHidden = false
        }
    }
    @IBOutlet weak var volumeSlider: UISlider! {
        didSet {
            volumeSlider.minimumValue = 0
            volumeSlider.transform = volumeSlider.transform.rotated(by: CGFloat(-0.5 * Float.pi))

            volumeSlider.maximumValue = 1
            volumeSlider.value = 1
            volumeSlider.setThumbImage(UIImage(named: "thumb_small"), for: .normal)
            volumeSlider.setThumbImage(UIImage(named: "thumb_large"), for: .highlighted)
            volumeSlider.isHidden = true
            volumeSlider.addTarget(self, action: #selector(_handleVolumeheadSliderValueChanged), for: .valueChanged)
            volumeSlider.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd), for: .touchUpOutside)
            volumeSlider.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd), for: .touchCancel)

            volumeSlider.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd), for: .touchUpInside)
        }
    }
    @objc private func _handleVolumeheadSliderTouchEnd(_ sender: UISlider) {
        volumeSlider.isHidden = true
    }

    
    @objc private func _handleVolumeheadSliderValueChanged(_ sender: UISlider) {
        videoLayer.player?.volume = sender.value
        if sender.value == 0 {
            self.muteButton.setImage(UIImage(named: "mute"), for: .normal)
        } else {
            self.muteButton.setImage(UIImage(named: "unmute"), for: .normal)
        }
    }

    @IBOutlet weak var playbackSlider: UISlider! {
        didSet {
            playbackSlider.setThumbImage(UIImage(named: "thumb_small"), for: .normal)
            playbackSlider.setThumbImage(UIImage(named: "thumb_large"), for: .highlighted)
            playbackSlider.isHidden = true
            playbackSlider.addTarget(self, action: #selector(_handlePlayheadSliderTouchBegin), for: .touchDown)
            playbackSlider.addTarget(self, action: #selector(_handlePlayheadSliderTouchEnd), for: .touchUpInside)
            playbackSlider.addTarget(self, action: #selector(_handlePlayheadSliderTouchEnd), for: .touchUpOutside)
            playbackSlider.addTarget(self, action: #selector(_handlePlayheadSliderTouchEnd), for: .touchCancel)
            playbackSlider.addTarget(self, action: #selector(_handlePlayheadSliderValueChanged), for: .valueChanged)
        }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.isHidden = true
            timeLabel.text = "00:00:00"
        }
    }
    
    @IBOutlet weak var zoomButton: UIButton! {
        didSet {
            zoomButton.isHidden = true
        }
    }
    
    @IBAction func zoomButtonTapped(_ sender: Any) {
        NotificationCenter.default.addObserver(self, selector: #selector(dismissAVPlayerViewController), name: Constants.NotificationName.kAVPlayerViewControllerDismissingNotification, object: nil)
        if let parentVC = parentViewController {
            let playerController = AVPlayerViewController()
            playerController.player = self.videoLayer.player
            parentVC.present(playerController, animated: true) { [weak self] in
                guard let this = self else { return }
                playerController.player?.isMuted = this._isMuted
                this._isPlaying ? playerController.player?.play() : playerController.player?.pause()
            }
        }
    }
    
    @objc func dismissAVPlayerViewController() {
        NotificationCenter.default.removeObserver(self, name: Constants.NotificationName.kAVPlayerViewControllerDismissingNotification, object: nil)
        if let player = self.videoLayer.player {
            _isMuted = player.isMuted
            _isPlaying = player.isPlaying
        }
        
    }
    
    //MARK: ASAutoPlayVideoLayerContainer Protocol
    func visibleVideoFrame() -> CGRect {
        return visibleFramePlayVideo ?? (superview?.superview?.convert(self.frame, from: self) ?? frame)
    }
    var videoLayer: AVPlayerLayer = AVPlayerLayer()
    public internal(set) var videoURL: String?
    private var isLinkTimeLine: Bool = false
//    {
//        didSet {
//
//        }
//    }

    // MARK: - Properties
    var resizeMode: AVLayerVideoGravity = .resizeAspectFill
    weak var delegate: CustomAVPlayerDelegate?
    var visibleFramePlayVideo : CGRect?
    public private(set) var _currentVideoState : CurrentVideoState = .none
    private var _isPlaying = false {
        didSet {
            if _isPlaying {
                _startShowControlsTimer()
                ASVideoPlayerController.sharedVideoPlayer.playVideo(withCustomAVPlayer: self)
            }
            else {
                _stopShowControlsTimer()
                ASVideoPlayerController.sharedVideoPlayer.pauseVideo(withCustomAVPlayer: self)
            }
        }
    }
    public private(set) var _isMuted = ASVideoPlayerController.sharedVideoPlayer.mute {
        didSet {
            videoLayer.player?.isMuted = false
            DispatchQueue.main.async {
                self.muteButton.setImage(UIImage(named: "unmute"), for: .normal)
                self.volumeSlider.isHidden = !self.volumeSlider.isHidden

            }
        }
    }
    
    var isMutedRequestFromAnotherWay: Bool?
    
    private var _showControlsTimer: Timer?
    public var _needShowControls = false
    {
        didSet {
            guard playButton != nil, playbackSlider != nil, timeLabel != nil, zoomButton != nil,muteButton != nil else {
                return
            }

            self.playButton.isHidden = !_needShowControls
            self.playbackSlider.isHidden = isLinkTimeLine ? true : !_needShowControls
            self.timeLabel.isHidden = isLinkTimeLine ? true : !_needShowControls
            self.zoomButton.isHidden = isLinkTimeLine ? true : !_needShowControls
        
//            for _view in controlsContainerView.subviews {
//                _view.isHidden = !_needShowControls
//            }
            if _currentVideoState == .pausing && !_needShowControls {
                self.playButton.isHidden = false
            }
        }
    }
    private var _currentTimeInterval: TimeInterval = 0 {
        didSet {
            guard timeLabel != nil, playbackSlider != nil else { return }
            timeLabel.text = _stringFromTimeInterval(_currentTimeInterval)
            playbackSlider.value = Float(_currentTimeInterval)
        }
    }
    
    lazy var currentSize: CGSize = {
        return self.bounds.size
        //        let sizeImageView = self.bounds.size
        //        let scaleFactor = UIScreen.main.scale
        //        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        //        let sizeResult = sizeImageView.applying(scale)
        //        return sizeResult
        //        return CGSize(width: width * UIScreen.main.scale.double, height: height * UIScreen.main.scale.double)
    }()
    
    var didSetupPlayer: Bool {
        //ToanHT todo
        return false
//        return _avPlayerViewController != nil
    }
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    deinit {
        
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        backgroundImageView.clipsToBounds = true
//        videoLayer.backgroundColor = UIColor.clear.cgColor
//        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        backgroundImageView.layer.addSublayer(videoLayer)
    }
    
    var didLoad: Bool = false
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didLoad {
            didLoad = true
            videoLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        }
        
    }
    
    private func _commonInit() {
        
        let _className = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(String(describing: _className), owner: self, options: nil)

        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        backgroundImageView.clipsToBounds = true
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        videoLayer.player?.volume = 1
        backgroundImageView.layer.addSublayer(videoLayer)
    }
    
    func prepareForDisplay() {
        _currentTimeInterval = 0.0
        _needShowControls = false
        playButton.isHidden = false
        muteButton.isHidden = false
        isLinkTimeLine = false
        indicatorView.isHidden = true
        backgroundImageView.image = nil
        _isMuted = ASVideoPlayerController.sharedVideoPlayer.mute
        configCurrentVideoState(state: .pausing)
    }
    
    func configCurrentVideoState(state: CurrentVideoState) {
        _currentVideoState = state
        switch state {
        case .playing:
            self.playButton.setImage(UIImage(named: "news_video_pause"), for: .normal)
            playButton.isHidden = true
            return
        case .pausing:
            self.playButton.setImage(UIImage(named: "news_video_play"), for: .normal)
            return
        default:
            return
        }
    }
    
    func configCurrentTime(currentTime: Double) {
        self._currentTimeInterval = currentTime
    }
    
    func configTotalTime(value: Float) {
        guard playbackSlider != nil else { return }
        self.playbackSlider.maximumValue = value
    }
    
    func hiddenControl() {
//        muteButton.isHidden = true
        playbackSlider.isHidden = true
        zoomButton.isHidden = true
        timeLabel.isHidden = true
    }
    
    func configIndicatorView(value: Bool) {
        indicatorView.isHidden = value
        if value {
            if _needShowControls {
                playButton.isHidden = false
            }
        } else {
             playButton.isHidden = true
        }
        value ? indicatorView.stopAnimating() : indicatorView.startAnimating()
    }

    func configure(videoURLString: String?, backgroundImageURL: URL?, isAlwaysMute: Bool = false) {
        backgroundImageView.pin_setImage(from: backgroundImageURL)
        self.configure(videoURLString: videoURLString, isAlwaysMute: isAlwaysMute)
    }
    
    func configure(videoURLString: String?, backgroundImage: UIImage?, isAlwaysMute: Bool = false) {
        backgroundImageView.image = backgroundImage
        self.configure(videoURLString: videoURLString, isAlwaysMute: isAlwaysMute)
    }
    
    func config(localURL: String?, isAlwaysMute: Bool = false) {
        backgroundImageView.image = nil
        self.videoURL = localURL
        if videoURL != nil {
            ASVideoPlayerController.sharedVideoPlayer.setUpVideoForLocal(customAVPlayer: self, isAlwaysMute: isAlwaysMute)
        }
        videoLayer.isHidden = videoURL == nil
    }
    
    private func configure(videoURLString: String?, isAlwaysMute: Bool = false) {
        self.videoURL = videoURLString
        if videoURL != nil {
            ASVideoPlayerController.sharedVideoPlayer.setupVideoFor(customAVPlayer: self, isAlwaysMute: isAlwaysMute)
        }
        videoLayer.isHidden = videoURL == nil
    }
    
    func deactive() {
        ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(customAVPlayer: self)
    }
    
    func removeObjectCache() {
        ASVideoPlayerController.sharedVideoPlayer.removeObjectCache(url: self.videoURL)
    }
    
    @objc private func _controlsContainerViewTapHandler(_ gesture: UITapGestureRecognizer) {
        if _needShowControls {
            delegate?.customAVPlayerDidTap(view: self)
        }
        
        _needShowControls = !_needShowControls
        _startShowControlsTimer()
    }
    
    func tapControl(){
        if _needShowControls {
            delegate?.customAVPlayerDidTap(view: self)
        }
        _needShowControls = !_needShowControls
        _startShowControlsTimer()
    }
    
    func hidePlayButton(){
        playButton.isHidden = true
    }
    
    @objc private func _showControlsTimerHandler(_ timer: Timer) {
        _needShowControls = false
        
    }
    
    private func _startShowControlsTimer() {
        _showControlsTimer?.invalidate()
        _showControlsTimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(_showControlsTimerHandler(_:)), userInfo: nil, repeats: false)
    }
    
    private func _stopShowControlsTimer() {
        _showControlsTimer?.invalidate()
        _showControlsTimer = nil
        _needShowControls = true
    }
    
    private func _stringFromTimeInterval(_ interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    @objc private func _handlePlayheadSliderTouchBegin(_ sender: UISlider) {
        _isPlaying = false
        _stopShowControlsTimer()
    }
    
    @objc private func _handlePlayheadSliderValueChanged(_ sender: UISlider) {
        _currentTimeInterval = TimeInterval(sender.value)
    }
    
    @objc private func _handlePlayheadSliderTouchEnd(_ sender: UISlider) {
        let seekToTime: CMTime = CMTimeMakeWithSeconds(Float64(Int(sender.value)), preferredTimescale: 600)
        videoLayer.player?.seek(to: seekToTime)
        _isPlaying = true
        _startShowControlsTimer()
    }
    
    func getStatusPlaying() -> Bool {
        return _isPlaying
    }
    
    func play() {
        _isPlaying = true
    }
    
    func pause() {
        _isPlaying = false
    }
    
    // MARK: - Actions
    @IBAction func playButtonActionHandler(_ sender: Any?) {
        if let currentItem = videoLayer.player?.currentItem {
            if currentItem.currentTime().value == currentItem.asset.duration.value {
                videoLayer.player?.seek(to: .zero)
                videoLayer.player?.play()
            }
        }
        
        if _isPlaying {
            _stopShowControlsTimer()
        }
        else {
            _startShowControlsTimer()
        }
        _isPlaying = !_isPlaying
        delegate?.customAVPlayerPlayButtonTapped(isPlaying: _isPlaying)
    }
    
    @IBAction func muteButtonActionHandler(_ sender: Any) {
        _isMuted = !_isMuted
        ASVideoPlayerController.sharedVideoPlayer.mute = _isMuted
    }
    
    func showControlTop(isLinkTimeline: Bool = false){
        self.isLinkTimeLine = isLinkTimeline
        if isLinkTimeline {
            muteButton.translatesAutoresizingMaskIntoConstraints = false
            muteButton.bottomAnchor.constraint(equalTo: controlsContainerView.bottomAnchor, constant: 0).isActive = true
            muteButton.rightAnchor.constraint(equalTo: controlsContainerView.rightAnchor, constant: 0).isActive = true
            self.zoomButton.isHidden = true
            self.playbackSlider.isHidden = true
            self.timeLabel.isHidden = true
        } else {
            zoomButton.translatesAutoresizingMaskIntoConstraints = false
            muteButton.translatesAutoresizingMaskIntoConstraints = false
            playbackSlider.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            zoomButton.topAnchor.constraint(equalTo: controlsContainerView.topAnchor, constant: 15).isActive = true
            muteButton.topAnchor.constraint(equalTo: controlsContainerView.topAnchor, constant: 15).isActive = true
            playbackSlider.alpha = 0
            timeLabel.alpha = 0
        }
    }
}








extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
    
    var curent : Float{
        return Float(CMTimeGetSeconds(currentTime()))
    }
}

func generateThumbnail(url: URL) -> UIImage? {
    let asset: AVAsset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    do {
        let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1) , actualTime: nil)
        return UIImage(cgImage: thumbnailImage)
    } catch _ {
        return nil
    }
}
