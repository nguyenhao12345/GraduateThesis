//
//  ManagerModernAVPlayer.swift
//  Piano_App
//
//  Created by Azibai on 05/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import ModernAVPlayer
import RxSwift
import RxCocoa

enum PositionRequest {
    case currentTime(time: Double?, duration: Double?)
    case seekTime(Double)
    case seekRatio(Float)
}

class ManagerModernAVPlayer: NSObject {
    static let shared: ManagerModernAVPlayer = ManagerModernAVPlayer()
    private let player = ModernAVPlayer(config: PlayerConfigurationExample.init(useDefaultRemoteCommand: true, allowsExternalPlayback: true),
                                        loggerDomains: [.state, .error, .unavailableCommand, .remoteCommand])
    override init() {
        
    }
    
    func config(url: URL) {
        
    }

    func seek(position: Double) {
        player.seek(position: position)
    }
        

    
    func loadMedia(_ media: PlayerMedia, autostart: Bool, position: Double? = nil) {
        player.loopMode = false
        player.load(media: media, autostart: autostart, position: position)
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
        
    private func isPlayerWorking(state: ModernAVPlayer.State) -> Bool {
        return state == .buffering || state == .loading || state == .waitingForNetwork
    }
    
    private func setDebugMessage(_ msg: String?) {
        //        debugMessage.text = msg
        //        debugMessage.alpha = 1.0
        //        UIView.animate(withDuration: 1.5) { self.debugMessage.alpha = 0 }
    }
    
    private func formatPosition(_ position: PositionRequest) -> String? {
        switch position {
        case .currentTime(let time, _):
            guard let t = time else { return nil }
            return String(format: "%.2f", t)
        case .seekRatio(let ratio):
            return "ratio:\(ratio)"
        case .seekTime(let time):
            return String(format: "%.2f", time)
        }
    }
    
    func prevSeek(offset: Double = -15) {
        player.seek(offset: offset)
    }
    
    func nextSeek(offset: Double = 15) {
        player.seek(offset: offset)
    }
    
//    func is


    
    private func createPositionRequest(state: ModernAVPlayer.State,
                                       currentTime: Double?,
                                       isSliderSeeking: Bool,
                                       sliderPosition: Float,
                                       optDuration: Double?) -> PositionRequest {
        
        guard isSliderSeeking || state == .buffering
            else { return .currentTime(time: currentTime, duration: optDuration) }
        
        guard let duration = optDuration else { return .seekRatio(sliderPosition) }
        
        return .seekTime(Double(sliderPosition) * duration)
    }
    
//    private func setSliderPosition(current: Double, duration: Double) -> Float {
//        return Float(current / duration)
//    }
    
//    private func setSeekPosition(from duration: Double) -> Double {
//        return Double(playbackSlider.value) * duration
//    }
    
    func setLoop(is loop: Bool) {
        player.loopMode = loop
    }
    
    func setSeek(offset: Double) {
        player.seek(offset: offset)
    }

    func setDelegate(delegate: ModernAVPlayerDelegate?) {
        self.player.delegate = delegate
    }
    
    func stop() {
        self.player.stop()
    }
}

func stringFromTimeInterval(_ interval: TimeInterval) -> String {
    let interval = Int(interval)
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
    let hours = (interval / 3600)
    if hours == 0 {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}
