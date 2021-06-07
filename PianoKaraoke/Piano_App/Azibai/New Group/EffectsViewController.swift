//
//  EffectsViewController.swift
//  SongProcessor
//
//  Created by Elizabeth Simonian, revision history on Githbub.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AudioKit
import AudioKitUI
import UIKit

class EffectsViewController: UIViewController {

    @IBOutlet private var volumeSlider: AKSlider!
    
    @IBOutlet private var Tone: AKSlider!
    @IBOutlet private var CutoffFrequency: AKSlider!
    @IBOutlet private var Resonance: AKSlider!
    @IBOutlet private var DelayTime: AKSlider!
    @IBOutlet private var DelayFeedback: AKSlider!
    @IBOutlet private var DelayMix: AKSlider!
    @IBOutlet private var ReverbFeedback: AKSlider!
    @IBOutlet private var ReverbMix: AKSlider!
    @IBOutlet private var OutputVolume: AKSlider!

    let songProcessor = SongProcessor.sharedInstance
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        AKStylist.sharedInstance.theme = .basic

//        volumeSlider.range = 0 ... 10.0

//        volumeSlider.value = songProcessor.playerMixer.volume
//        volumeSlider.callback = updateVolume
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateVolume(value: Double) {
//        songProcessor.playerMixer.volume = value
    }

    @IBAction func clickDellay(_ sender: Any?) {
        let vc = VariableDelayViewController()
        self.navigationController?.push(vc, animation: true)
    }
    
    @IBAction func clickMoog(_ sender: Any?) {
        let vc = MoogLadderViewController()
        self.navigationController?.push(vc, animation: true)
    }
    @IBAction func clickReverb(_ sender: Any?) {
        let vc = CostelloReverbViewController()
        self.navigationController?.push(vc, animation: true)
    }
    @IBAction func clickShift(_ sender: Any?) {
        let vc = PitchShifterViewController()
        self.navigationController?.push(vc, animation: true)
    }
    @IBAction func clickCrusher(_ sender: Any?) {
        let vc = BitCrusherViewController()
        self.navigationController?.push(vc, animation: true)
    }
    
    @IBOutlet weak var viewVideo: CustomAVPlayer!
    let arrBeat: [String] = LocalVideoManager.shared.getAllLocalSongYoutube().map({ $0.snippet.title })
    var curentBeat: Int? = nil
    
    @IBAction func clickThu(_ sender: Any?) {
        songProcessor.initMic()
        
        Tone.value = songProcessor.tone!.shift
        Tone.range = -15...15
        Tone.callback = { (value) in
            self.songProcessor.tone!.shift = Double(value).round(nearest: 0.5)
            self.Tone.value = Double(value).round(nearest: 0.5)
        }

        
        CutoffFrequency.value = songProcessor.filter!.cutoffFrequency
        CutoffFrequency.range = 1...2000
        CutoffFrequency.format = "%0.1f Hz"
        CutoffFrequency.callback = { (value) in
            self.songProcessor.filter!.cutoffFrequency = value
        }

        Resonance.value = songProcessor.filter!.resonance
        Resonance.range = 0...0.99
        Resonance.format = "%0.2f"
        Resonance.callback = { (value) in
            self.songProcessor.filter!.resonance = value
        }
        
        DelayTime.value = songProcessor.delay!.time
        DelayTime.range = 0...1
        DelayTime.format = "%0.2f s"
        DelayTime.callback = { (value) in
            self.songProcessor.delay!.time = value
        }
        
        DelayFeedback.value = songProcessor.delay!.feedback
        DelayFeedback.range = 0...0.99
        DelayFeedback.format = "%0.2f"
        DelayFeedback.callback = { (value) in
            self.songProcessor.delay!.feedback = value
        }
        
        DelayMix.value = songProcessor.delayMixer!.balance
        DelayMix.range = 0...1
        DelayMix.format = "%0.2f"
        DelayMix.callback = { (value) in
            self.songProcessor.delayMixer!.balance = value
        }
        
        ReverbFeedback.value = songProcessor.reverb!.feedback
        ReverbFeedback.range = 0...0.99
        ReverbFeedback.format = "%0.2f"
        ReverbFeedback.callback = { (value) in
            self.songProcessor.reverb!.feedback = value
        }
        
        ReverbMix.value = songProcessor.reverbMixer!.balance
        ReverbMix.range = 0...1
        ReverbMix.format = "%0.2f"
        ReverbMix.callback = { (value) in
            self.songProcessor.reverbMixer!.balance = value
        }
        
        OutputVolume.value = songProcessor.booster!.gain
        OutputVolume.range = 0...20
        OutputVolume.format = "%0.2f"
        OutputVolume.callback = { (value) in
            self.songProcessor.booster!.gain = value
        }

    }
    
    @IBAction func clickBeat(_ sender: Any?) {
        self.showAlert(title: "Chọn Beat", message: nil, buttonTitles: self.arrBeat, highlightedButtonIndex: self.curentBeat) { (value) in
            self.curentBeat = value
            ASVideoPlayerController.sharedVideoPlayer.pauseRemoveLayer(customAVPlayer: self.viewVideo)
            self.viewVideo.config(localURL: LocalVideoManager.shared.getURLVideoLocal(key: self.arrBeat[value]))
            ASVideoPlayerController.sharedVideoPlayer.playVideo(withCustomAVPlayer: self.viewVideo)
        }
    }
   

}
