//
//  ASVideoContainer.swift
//  Azibai
//
//  Created by ToanHT on 8/21/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import UIKit
import AVFoundation

class ASVideoContainer: Equatable {
    
    static func ==(lhs: ASVideoContainer, rhs: ASVideoContainer) -> Bool {
        return lhs.player == rhs.player && lhs.url == rhs.url
    }
//
//    static var globalPlayer: ASVideoContainer? {
//        didSet {
//            if oldValue != globalPlayer {
//                oldValue?.player.pause()
//            }
//        }
//    }
    
    var url: String
    var playOn: Bool {
        didSet {
            DispatchQueue.main.async {
                self.playerItem.canUseNetworkResourcesForLiveStreamingWhilePaused = false
                self.player.isMuted = self.isAlwaysMute ? true : ASVideoPlayerController.sharedVideoPlayer.mute
                if self.playOn && self.playerItem.status == .readyToPlay {
                    self.player.play()
                } else{
                    self.player.pause()
                }
            }
        }
    }
    
    let player: AVPlayer
    let playerItem: AVPlayerItem
    var isAlwaysMute: Bool
    init(player: AVPlayer, item: AVPlayerItem, url: String, isAlwaysMute : Bool = false, size: CGSize = .zero ) {
        self.player = player
        self.playerItem = item
        self.url = url
        self.isAlwaysMute = isAlwaysMute
        if #available(iOS 11.0, *) {
            self.playerItem.preferredMaximumResolution = size
        }
        playOn = false
    }
}
