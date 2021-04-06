//
//  PlayerConfigurationExample.swift
//  ModernAVPlayer_Example
//
//  Created by ankierman on 18/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import AVFoundation
import ModernAVPlayer

///
/// Documentation provided in PlayerConfiguration.swift
///

struct PlayerConfigurationExample: PlayerConfiguration {
    var audioSessionCategoryOptions: AVAudioSession.CategoryOptions = .init()
    
//    var audioSessionCategoryOptions: AVAudioSession.CategoryOptions? = nil
    

    // Buffering State
    var rateObservingTimeout: TimeInterval = 3
    var rateObservingTickTime: TimeInterval = 0.3

    // General Audio preferences
    var preferredTimescale = CMTimeScale(NSEC_PER_SEC)
    var periodicPlayingTime: CMTime
    var audioSessionCategory = AVAudioSession.Category.playback
//    var audioSessionCategoryOptions: AVAudioSession.CategoryOptions? = nil

    // Reachability Service
    var reachabilityURLSessionTimeout: TimeInterval = 3
    //swiftlint:disable:next force_unwrapping
    var reachabilityNetworkTestingURL = URL(string: "https://www.google.com")!
    var reachabilityNetworkTestingTickTime: TimeInterval = 3
    var reachabilityNetworkTestingIteration: UInt = 10

    // RemoteCommandExample is used for example
    var useDefaultRemoteCommand = false
    
    var allowsExternalPlayback = false

    // AVPlayerItem Init Service
    var itemLoadedAssetKeys = ["playable", "duration"]
    init() {
        periodicPlayingTime = CMTime(seconds: 0.1, preferredTimescale: preferredTimescale)
    }
    
    init(useDefaultRemoteCommand: Bool = false, allowsExternalPlayback: Bool = false) {
        self.useDefaultRemoteCommand = useDefaultRemoteCommand
        self.allowsExternalPlayback = allowsExternalPlayback
        periodicPlayingTime = CMTime(seconds: 0.1, preferredTimescale: preferredTimescale)
    }
}
