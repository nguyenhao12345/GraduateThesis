//
//  SmallCustomAVPlayer.swift
//  Azibai
//
//  Created by Azibai on 24/07/2020.
//  Copyright © 2020 Azi IOS. All rights reserved.
//
import UIKit
import AVFoundation
import AVKit


class SmallCustomAVPlayer: CustomAVPlayer {

    override var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.layer.zPosition = 0
        }
    }
    override func configCurrentVideoState(state: CurrentVideoState) {
        super.configCurrentVideoState(state: state)
        playButton.isHidden = false
        switch _currentVideoState {
        case .playing:
            self.playButton.setImage(UIImage(named: "news_video_pause"), for: .normal)
            return
        case .pausing:
            self.playButton.setImage(UIImage(named: "news_video_play"), for: .normal)
            return
        default:
            return
        }
    }
    
//    override func inited() {
//        super.inited()
//        guard playButton != nil else { return }
//        playButton.touchAreaEdgeInsets = UIEdgeInsets(top: -16, left: -4, bottom: -4, right: -16)
//    }
    
    override func configIndicatorView(value: Bool) {
        super.configIndicatorView(value: value)
        playButton.isHidden = false
        switch _currentVideoState {
        case .playing:
            self.playButton.setImage(UIImage(named: "news_video_pause"), for: .normal)
            return
        case .pausing:
            self.playButton.setImage(UIImage(named: "news_video_play"), for: .normal)
            return
        default:
            return
        }
    }
}
