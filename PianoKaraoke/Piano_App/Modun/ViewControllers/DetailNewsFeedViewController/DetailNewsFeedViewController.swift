//
//  DetailNewsFeedViewController.swift
//  Piano_App
//
//  Created by Azibai on 31/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit
import AVFoundation
import FDWaveformView
import ModernAVPlayer
import RxSwift
import RxCocoa

@available(iOS 13.0, *)
class DetailNewsFeedViewController: AziBaseViewController {
    
    var isPlay: Bool = false
    var isActiveAnimation: Bool = false
    var newsModel: NewsFeedModel?
    
    var lastConstraint: CGFloat = 0
    var startPanLocationY: CGFloat = 0
    @IBOutlet weak private var timingLabel: UILabel!
    @IBOutlet weak private var durationLabel: UILabel!

    //MARK: Outlets
    @IBOutlet weak var imgView: ImageViewRound!
    @IBOutlet weak var playView: ViewRound!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backgroundBlur: UIImageView!
    @IBOutlet weak var backgroundBlur2: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var viewBackgroundBlur: ViewRound!
    @IBOutlet weak var viewBottom: DetailNewsFeedViewBottom!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewBottomContainer: UIView!
    @IBOutlet weak var btnShowComment: UIButton!
    @IBOutlet weak var constraintViewComment: NSLayoutConstraint!
    @IBOutlet weak var topNavConst: NSLayoutConstraint!

    @IBOutlet weak var avataImg: ImageViewRound!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeNewsLbl: UILabel!
    @IBOutlet weak var bottomContrainView: NSLayoutConstraint!
    
    //Comment:
    @IBOutlet weak var marginRightViewBackgroundTextView: NSLayoutConstraint!
    @IBOutlet private weak var btnSendMess: UIButton!
    @IBOutlet private weak var viewBackgroundTextView: UIView!
    @IBOutlet private weak var uitextView: UITextView!
    @IBOutlet private weak var avtImg: ImageViewRound!
    
    @IBOutlet weak var playbackSlider: UISlider! {
        didSet {
            playbackSlider.setThumbImage(UIImage(named: "thumb_small"), for: .normal)
            playbackSlider.setThumbImage(UIImage(named: "thumb_large"), for: .highlighted)
            playbackSlider.addTarget(self, action: #selector(_handlePlayheadSliderValueChanged), for: .valueChanged)
            playbackSlider.addTarget(self, action: #selector(_handlePlayheadSliderTouchEnd), for: .touchUpInside)
        }
    }
    var MAX_HEIGHT: CGFloat {
        if viewContainer == nil || viewBottomContainer == nil { return 0 }
        return viewContainer.height - viewBottomContainer.height - 44
    }
    var MIN_HEIGHT: CGFloat = 0
    var MEDIUM_HEIGHT: CGFloat {
        return (MAX_HEIGHT + MIN_HEIGHT)/3
    }

    @IBAction func clickAvata(_ sender: Any?) {
        guard let uid = newsModel?.user?.uid else { return }
        AppRouter.shared.gotoUserWall(uidUSer: uid, viewController: self)
    }
    
    @IBAction func clickDisplayComment(_ sender: Any?) {
        if constraintViewComment.constant != 0 {
            bottomContrainView.constant = -MAX_HEIGHT
            constraintViewComment.constant = 0
            btnShowComment.tintColor = .lightGray
            viewBottom.updateViewAlpha(alpha: 1)
        } else {
            constraintViewComment.constant = 500
            btnShowComment.tintColor = .white
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .LoadMoreAndRefresh
    }
    
    override func getScrollView() -> UIScrollView? {
        return nil
    }
    
    override func panWithNormal(recognizer: UIPanGestureRecognizer) { }
    
    //MARK: Properties
    
    //MARK: Init
    init(newsModel: NewsFeedModel?) {
        self.newsModel = newsModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initUIVariable() {
        super.initUIVariable()
        self.hidesNavigationbar = true
        self.hidesToolbar = true
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initGesture()
        viewIsReady()
        guard let strUrl = newsModel?.media?.urlMp3 else { return }
        let media = ModernAVPlayerMedia(url:  URL(string: strUrl)!, type: .clip, metadata: ModernAVPlayerMediaMetadata(title: newsModel?.title, albumTitle: nil, artist: newsModel?.user?.name, image: nil, remoteImageUrl: URL(string: newsModel?.media?.urlImage ?? "")), assetOptions: nil)
        ManagerModernAVPlayer.shared.loadMedia(media, autostart: false)
        ManagerModernAVPlayer.shared.setDelegate(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animationViewDidAppear()
    }
    
    //MARK: Method
    func initGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickPlay))
        playView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandle(_:)))
        viewBottom.addGestureRecognizer(pan)
        viewBottom.isUserInteractionEnabled = true
    }
    
    @objc func panGestureHandle(_ sender: UIPanGestureRecognizer) {
        let currentLocation = sender.location(in: self.view)
        switch sender.state {
        case .changed:
            self.viewBottom.collectionView.isScrollEnabled = false
            let a = Float(currentLocation.y)
            let b = Float(startPanLocationY)
            if a > b {
                let distance = a - b
                self.bottomContrainView.constant += CGFloat(distance)
                self.viewBottom.updateViewAlpha(alpha: bottomContrainView.constant / -MAX_HEIGHT)
            }
            else {
                if bottomContrainView.constant < MAX_HEIGHT {
                    let distance = b - a
                    self.bottomContrainView.constant -= CGFloat(distance)
                    self.viewBottom.updateViewAlpha(alpha: bottomContrainView.constant / -MAX_HEIGHT)
                }
            }
            self.startPanLocationY = currentLocation.y
            self.lastConstraint = bottomContrainView.constant
        case .began:
            startPanLocationY = currentLocation.y
        case .ended:
            self.viewBottom.collectionView.contentOffset = .zero
            if bottomContrainView.constant <= -MEDIUM_HEIGHT {
                self.bottomContrainView.constant = -MAX_HEIGHT
                self.viewBottom.collectionView.isScrollEnabled = true
                constraintViewComment.constant = 0
                btnShowComment.tintColor = .lightGray
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewBottom.updateViewAlpha(alpha: self.bottomContrainView.constant / -self.MAX_HEIGHT)
                    self.view.layoutIfNeeded()
                })
            }
            else {
                bottomContrainView.constant = MIN_HEIGHT
                self.viewBottom.collectionView.isScrollEnabled = false
                constraintViewComment.constant = 500
                btnShowComment.tintColor = .white
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewBottom.updateViewAlpha(alpha: self.bottomContrainView.constant / -self.MAX_HEIGHT)
                    self.view.layoutIfNeeded()
                })
            }
            startPanLocationY = 0
        default: break
        }
    }
    
    
    func viewIsReady() {
//        imgView.layoutIfNeeded()
        imgView.setImageURL(URL(string: newsModel?.media?.urlImage ?? ""), defaultImage: nil) { _ in
//            self.imgView.removePixel(to: self.imgView.center, lineWidth: 48)
//            self.backgroundBlur.globalFrame?.midX
        }
        backgroundBlur.setImageURL(URL(string: newsModel?.media?.urlImage ?? ""))
        backgroundBlur2.setImageURL(URL(string: newsModel?.media?.urlImage ?? ""))
        avataImg.setImageURL(URL(string: newsModel?.user?.avata ?? ""))
        userNameLbl.text = newsModel?.user?.name
        timeNewsLbl.text = newsModel?.timeAgoSinceNow
        avtImg.setImageURL(URL(string: AppAccount.shared.getUserLogin()?.avata ?? ""))
        autoAnimationHideButton()
        uitextView.text = Const.plahoderComment
        constraintViewComment.constant = 500
        btnShowComment.tintColor = .white
        navView.addShadow(location: .bottom)
        uitextView.delegate = self
        viewBottom.viewDidLoad(newsFeedModel: newsModel)
        bottomContrainView.constant = 300
        topNavConst.constant = -100
        viewBottom.updateViewAlpha(alpha: -0.3)
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.playView.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        
        viewBottom.roundCorners([.topLeft, .topRight], radius: 24)
    }
    
    let maxHeight: CGFloat = 160
    
    
    @objc func clickPlay() {
        
        if !isActiveAnimation {
            isActiveAnimation = true
            imgPlay.image = UIImage(systemName: "pause.fill")
            isPlay = true
            animationScaleEffect(view: viewBackgroundBlur)
            rotateView()
            ManagerModernAVPlayer.shared.play()
            return
        }
        
        if isPlay {
            imgPlay.image = UIImage(systemName: "play.fill")
            isPlay = false
            pauseLayer(layer: imgView.layer)
            pauseLayer(layer: viewBackgroundBlur.layer)
            ManagerModernAVPlayer.shared.pause()
        } else {
            imgPlay.image = UIImage(systemName: "pause.fill")
            isPlay = true
            resumeLayer(layer: imgView.layer)
            resumeLayer(layer: viewBackgroundBlur.layer)
            ManagerModernAVPlayer.shared.play()
        }
        
    }
    
    
    @IBAction func prevSeek(_ sender: Any?) {
        ManagerModernAVPlayer.shared.prevSeek()
    }

    @IBAction func nextSeek(_ sender: Any?) {
        ManagerModernAVPlayer.shared.nextSeek()
    }

    @IBOutlet weak var btnLoop: UIButton!
    
    @IBAction func loopPlayer(_ sender: Any?) {
        if btnLoop.tintColor == .white {
            btnLoop.tintColor = .lightGray
            ManagerModernAVPlayer.shared.setLoop(is: true)
        } else {
            btnLoop.tintColor = .white
            ManagerModernAVPlayer.shared.setLoop(is: false)
        }
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        ManagerModernAVPlayer.shared.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    var isHandlePlayheadSlider: Bool = false
    @objc private func _handlePlayheadSliderValueChanged(_ sender: UISlider) {
        isHandlePlayheadSlider = true
    }
    
    @objc private func _handlePlayheadSliderTouchEnd(_ sender: UISlider) {
        isHandlePlayheadSlider = false
        ManagerModernAVPlayer.shared.seek(position: TimeInterval(sender.value))
    }


    
    @IBAction func clickSendComment(_ sender: Any?) {
        guard let strCmt = uitextView.text,
            let news = newsModel else { return }
        let commentModel = BaseCommentModel(contentComment: strCmt)
        ServiceOnline.share.comment(at: news, commentModel: commentModel)
        autoAnimationHideButton()
        uitextView.text = Const.plahoderComment
        autoSizeFor(textView: uitextView)
        viewBottom.sendComment(comment: commentModel)
                uitextView.endEditing(true)
    }
}

@available(iOS 13.0, *)
extension DetailNewsFeedViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            autoAnimationHideButton()
        } else {
            autoAnimationNotHideButton()
        }
        autoSizeFor(textView: textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if uitextView.text == Const.plahoderComment {
            uitextView.text = ""
            autoAnimationNotHideButton()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if uitextView.text == "" {
            uitextView.text = Const.plahoderComment
            autoAnimationHideButton()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}



//MARK: Animation
@available(iOS 13.0, *)
extension DetailNewsFeedViewController {
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func rotateView() {
        UIView.animate(withDuration: 3.0, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.imgView.transform = self.imgView.transform.rotated(by: .pi / 2)
        }) { (finished) -> Void in
            self.rotateView()
        }
    }
    
    func animationScaleEffect(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        },completion:{completion in
            UIView.animate(withDuration: 0.5, animations: {
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { _ in
                self.animationScaleEffect(view: view)
            }
        })
    }
    
    func animationViewDidAppear() {
        bottomContrainView.constant = MIN_HEIGHT
        viewBottom.updateViewAlpha(alpha: 0)
        topNavConst.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private func autoAnimationHideButton() {
        btnSendMess.isHidden = true
        marginRightViewBackgroundTextView.priority = UILayoutPriority(rawValue: 999.5)
    }
    
    private func autoAnimationNotHideButton() {
        btnSendMess.isHidden = false
        marginRightViewBackgroundTextView.priority = UILayoutPriority(rawValue: 998)
    }
    
    private func autoSizeFor(textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if textView.text == "" || textView.text == Const.plahoderComment {
                    constraint.constant = 38
                    return
                }
                constraint.constant = max(min(estimatedSize.height, maxHeight), 38)
            }
        }
    }

}

@available(iOS 13.0, *)
extension DetailNewsFeedViewController: ModernAVPlayerDelegate {
    func modernAVPlayer(_ player: ModernAVPlayer, didStateChange state: ModernAVPlayer.State) {
//        DispatchQueue.main.async { self.stateLabel.text = "State: " + state.description }
        switch state {

        case .loaded:
            guard let duration = player.player.currentItem?.asset.duration else { return }
            timingLabel.text = stringFromTimeInterval(duration.seconds)
            playbackSlider.maximumValue = Float(duration.seconds)
            clickPlay()
        default: break
        }
    }

    func modernAVPlayer(_ player: ModernAVPlayer, didCurrentTimeChange currentTime: Double) {
        DispatchQueue.main.async {
            if !self.isHandlePlayheadSlider {
                self.playbackSlider.value = Float(currentTime)
            }
            self.durationLabel.text = stringFromTimeInterval(currentTime)
        }
    }
    
    func modernAVPlayer(_ player: ModernAVPlayer, didItemPlayToEndTime endTime: Double) {
        if !player.loopMode {
            imgPlay.image = UIImage(systemName: "play.fill")
            isPlay = false
            pauseLayer(layer: imgView.layer)
            pauseLayer(layer: viewBackgroundBlur.layer)
            ManagerModernAVPlayer.shared.pause()
        }
    }
}
