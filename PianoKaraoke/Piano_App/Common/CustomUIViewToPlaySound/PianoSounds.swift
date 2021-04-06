//
//  ViewController.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 10/13/18.
//  Copyright © 2018 com.nguyenhieu.demo. All rights reserved.
//
import Foundation
import AVFoundation
import UIKit
class PianoSounds {
    private var audioPlayers = [Tangent : AVAudioPlayer]()
    func setupAudioPlayerWithFile(file: String) -> AVAudioPlayer? {
        if let path = Bundle.main.path(forResource: file as String, ofType: "mp3"){
            let url = NSURL.fileURL(withPath: path)
            do {
                let audioPlayer = try
                    AVAudioPlayer(contentsOf: url )
                return audioPlayer
            } catch {
            }
        }
        return nil
    }
    func audioPlayer(tangent: Tangent) -> AVAudioPlayer? {
        if let audioPlayer = audioPlayers[tangent] {
            return audioPlayer
        }
        if let audioPlayer = setupAudioPlayerWithFile(file: tangent.rawValue) {
            audioPlayers[tangent] = audioPlayer
            return audioPlayer
        }
        return nil
    }
    
    func keyDown(tangent: Tangent) {
         audioPlayer(tangent: tangent)?.currentTime = 0
         audioPlayer(tangent: tangent)?.volume = 1.5
        audioPlayer(tangent: tangent)?.play()
//        audioPlayer(tangent: tangent)?.currentTime = 0
    }
    
    func keyUp(tangent: Tangent) {
//        audioPlayer(tangent: tangent)?.fadeToStop()
//        audioPlayer(tangent: tangent)?.volume = 0
//        audioPlayer(tangent: tangent)?.
        audioPlayer(tangent: tangent)?.volume = 0.3
        audioPlayer(tangent: tangent)?.stop()
//   
    }
}


extension AVAudioPlayer {
    private func delay(delay:Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when , execute: closure)
    }
    func fadeToStop() {}
}

//        self.volume = 0.5
//        delay(delay: 0.001) {
//            self.volume = 0.4
//            self.delay(delay: 0.002) {
//                self.volume = 0.3
//                self.delay(delay: 0.003) {
//                    self.volume = 0.2
//                    self.delay(delay: 0.004) {
//                        self.volume = 0.2
//                        self.delay(delay: 0.005) {
//                            self.volume = 0.1
//                            self.delay(delay: 0.006) {
//                                self.volume = 0.05
//                                self.delay(delay: 0.007) {
//                                    self.volume = 0.001
//                                    self.delay(delay: 0.008) {
//                                        self.volume = 0.0005
//                                        self.delay(delay: 0.009) {
//                                            self.volume = 0.00001
//                                            self.delay(delay: 0.0001) {
//                                                self.volume = 0
//                                                self.stop()
//                                                self.currentTime = 0.0
//                                                self.volume = 1
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }

