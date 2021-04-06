
//
//  AVVideoPlayerController.swift
//  NewsFeed
//
//  Created by ToanHT on 12/5/19.
//  Copyright © 2019 AzibaiNewFeed. All rights reserved.
//

import Foundation
import AVFoundation

//public typealias PlayerItemClosure = (_ playerItem: AVPlayerItem) -> ()

class AZVideoPlayerManager: NSObject {
    
    
    //MARK: Properties
    static let shared = AZVideoPlayerManager()
    static private var playerViewControllerKVOContext = 0
    
    // Attempt load and test these asset keys before playing.
//    static let assetKeysRequiredToPlay = [
//        "playable",
//        "hasProtectedContent"
//    ]
    
    
    //MARK: Life cycles
    
    override init() {
        super.init()
        
    }
}
