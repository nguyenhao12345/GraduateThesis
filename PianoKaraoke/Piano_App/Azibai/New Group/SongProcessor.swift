//
//  SongProcessor.swift
//  SongProcessor
//
//  Created by Aurelius Prochazka, revision history on Githbub.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit
import AudioKit
import MediaPlayer

class SongProcessor: NSObject {

    static let sharedInstance = SongProcessor()
    var mic: AKMicrophone?
//    var iTunesFilePlayer: AKPlayer?
//    var variableDelay = AKDelay()  //Was AKVariableDelay, but it wasn't offline render friendly!
//    var delayMixer = AKDryWetMixer()
//    var moogLadder = AKMoogLadder()
//    var filterMixer = AKDryWetMixer()
//    var reverb = AKCostelloReverb()
//    var reverbMixer = AKDryWetMixer()
//    var pitchShifter = AKPitchShifter()
//    var pitchMixer = AKDryWetMixer()
//    var bitCrusher = AKBitCrusher()
//    var bitCrushMixer = AKDryWetMixer()
//    var playerBooster = AKBooster()
//    var playerMixer = AKMixer()
//    var isPlaying = false
    
    var filter: AKMoogLadder?
    var delay: AKVariableDelay?
    var delayMixer: AKDryWetMixer?
    var reverb: AKCostelloReverb?
    var reverbMixer: AKDryWetMixer?
    var booster: AKBooster?
    var tone: AKPitchShifter?
    
    fileprivate var docController: UIDocumentInteractionController?

    
 
    func initMic() {
        mic = AKMicrophone()
        filter = AKMoogLadder(mic!)

        delay = AKVariableDelay(filter!)
        delayMixer = AKDryWetMixer(filter!, delay!)

        reverb = AKCostelloReverb(delayMixer!)
        reverbMixer = AKDryWetMixer(delayMixer!, reverb!)

//        tone = AKPitchShifter(reverbMixer, shift: 0)

        
        booster = AKBooster(reverbMixer!)
        tone = AKPitchShifter(booster, shift: 0)
        AudioKit.output = tone

//        AudioKit.output = playerMixer

        // Allow the app to play in the background
        do {
            
            if #available(iOS 10.0, *) {
                try AKSettings.setSession(category: .playAndRecord , with: [.defaultToSpeaker])
                
                print("using A2DP")
            } else {
                try AKSettings.setSession(category: .playAndRecord, with: [.allowBluetooth, .mixWithOthers])
            }
            
        } catch {
            
            print("Could not set session category.")
            
        }
        
        if let input = AudioKit.inputDevice {
            try! mic?.setDevice(input)
        }

        AKSettings.playbackWhileMuted = true
        
        initParameters()
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        

    }

    override init() {
        super.init()

    }
    
    func updateEffectsChain(effects: [Effect]) {
//        do {
//            try AudioKit.stop()
//        } catch {
//            AKLog("AudioKit did not stop!")
//        }
//        var currentNode: AKInput = playerMixer
//        effects.forEach { effect in
//            currentNode.disconnectOutput()
//            currentNode >>> effect.node
//            currentNode = effect.node
//        }
//
//        let mixer = AKMixer()
//        currentNode >>> mixer
//
//        AudioKit.output = mixer

        
    }
    
    func initParameters() {

//        delayMixer.balance = 0
//        filterMixer.balance = 0
//        reverbMixer.balance = 0
//        pitchMixer.balance = 0
//
//        bitCrushMixer.balance = 0
//        bitCrusher.bitDepth = 16
//        bitCrusher.sampleRate = 3_333
//
//        //Booster for Volume
//        playerBooster.gain = 0.5
    }



    private class func twoRendersFromNow() -> AVAudioTime {
        let twoRenders = AVAudioTime.hostTime(forSeconds: AKSettings.bufferLength.duration * 2)
        return AVAudioTime(hostTime: mach_absolute_time() + twoRenders)
    }

    enum ShareTarget {
        case iTunes
        case loops
    }

   
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        docController = nil
        guard let url = controller.url else { return }
        if FileManager.default.fileExists(atPath: url.path) {
            do { try FileManager.default.removeItem(at: url) } catch {
                print(error)
            }
        }
    }
    
    var mixDownURL: URL = {
        let tempDir = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        return tempDir.appendingPathComponent("mixDown.m4a")
    }()
}
