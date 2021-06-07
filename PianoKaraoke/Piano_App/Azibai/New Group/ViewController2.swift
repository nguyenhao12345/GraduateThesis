//
//  ViewController2.swift
//  Piano_App
//
//  Created by Azibai on 16/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import AudioKitUI
import AudioKit

class ViewController2: UIViewController {
    var voice: SongVol = SongVol()
    
    //Tone
    @IBOutlet weak var tone: RoundSlider!
    
    //Delay
    @IBOutlet weak var delayToggle: LedButton!
    @IBOutlet weak var delayTimeKnob: RoundSlider!
    @IBOutlet weak var delayFeedbackKnob: RoundSlider!
    @IBOutlet weak var delayMixKnob: RoundSlider!
    
    //Filter
    @IBOutlet weak var filterToggle: ToggleButton!
    @IBOutlet weak var freqKnob: RoundSlider!
    @IBOutlet weak var rezKnob: RoundSlider!
    @IBOutlet weak var lfoRateKnob: RoundSlider!
    @IBOutlet weak var lfoAmtKnob: RoundSlider!

    //Reverb
    @IBOutlet weak var reverbToggle: LedButton!
    @IBOutlet weak var reverbAmtKnob: RoundSlider!
    @IBOutlet weak var reverbMixKnob: RoundSlider!
    
    //AutoPan
    @IBOutlet weak var autoPanToggle: ToggleButton!
    @IBOutlet weak var fattenToggle: ToggleButton!
    @IBOutlet weak var autoPanRateKnob: RoundSlider!
    @IBOutlet weak var attackKnob: RoundSlider!
    @IBOutlet weak var releaseKnob: RoundSlider!

    //Vol
    @IBOutlet weak var vol1Knob: RoundSlider!
    @IBOutlet weak var masterVolume: RoundSlider!
    
    //Auditon
//    @IBOutlet weak var auditionPoly: RadioButton!
//    @IBOutlet weak var auditionLead: RadioButton!
//    @IBOutlet weak var auditionBass: RadioButton!

    //Distortion + Bit Crush
    @IBOutlet weak var distortionToggle: ToggleButton!
    @IBOutlet weak var distortKnob: RoundSlider!
    @IBOutlet weak var crushKnob: RoundSlider!

    @IBOutlet weak var viewVideo: CustomAVPlayer!
    let arrBeat: [String] = LocalVideoManager.shared.getAllLocalSongYoutube().map({ $0.snippet.title })
    var curentBeat: Int? = nil

    init() {
         super.init(nibName: nil, bundle: nil)
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

    @IBAction func clickBeat(_ sender: Any?) {
        self.showAlert(title: "Chọn Beat", message: nil, buttonTitles: self.arrBeat, highlightedButtonIndex: self.curentBeat) { (value) in
            self.curentBeat = value
            ASVideoPlayerController.sharedVideoPlayer.pauseRemoveLayer(customAVPlayer: self.viewVideo)
            self.viewVideo.config(localURL: LocalVideoManager.shared.getURLVideoLocal(key: self.arrBeat[value]))
            ASVideoPlayerController.sharedVideoPlayer.playVideo(withCustomAVPlayer: self.viewVideo)
        }
    }
    @IBAction func clickThu2(_ sender: Any?) {
        let mic = AKMicrophone()
        
        let micMixer = AKMixer(mic)

        let micBooster = AKBooster(micMixer)
        let pitchShifter = AKPitchShifter(micBooster, shift: 0)
        micBooster.gain = 1
        
        mic?.volume = 1.0
        vol1Knob.config(range: 0 ... 20.0, value: 1.0, labelName: "vol1Knob") { (value) in
            mic?.volume = value
        }
        tone.config(range: -15.0...15.0, value: 0, labelName: "Tone") { (value) in
            pitchShifter.shift = Double(value).round(nearest: 0.5)
        }

        AudioKit.output = pitchShifter
        
        
        AKSettings.sampleRate = 44100
        AKSettings.channelCount = 2
        
        do{
            try AudioKit.start()
        } catch {
            print("error occured")
        }
        
        
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

    }

    @IBAction func clickThu(_ sender: Any?) {
        AudioKit.output = voice.getOutPut()

        AKSettings.ioBufferDuration = 0 // Optional, set this to decrease latency
        
        
        // select input of device
        AKSettings.sampleRate = 44100
        AKSettings.channelCount = 2
        AKSettings.playbackWhileMuted = true
        AKSettings.enableRouteChangeHandling = false
        AKSettings.useBluetooth = false
        AKSettings.defaultToSpeaker = true
        AKSettings.audioInputEnabled = false
        
        do{
            try AudioKit.start()
        } catch {
            print("error occured")
        }
        
        
        do {
            
            if #available(iOS 10.0, *) {
                try AKSettings.setSession(category: .playAndRecord , with: [.allowBluetoothA2DP, .defaultToSpeaker, .allowAirPlay ])
                print("using A2DP")
            } else {
                try AKSettings.setSession(category: .playAndRecord, with: [.allowBluetooth, .mixWithOthers])
            }
            
        } catch {
            
            print("Could not set session category.")
            
        }
        
        if let input = AudioKit.inputDevice {
            try! voice.mic.setDevice(input)
        }
        //Tone
        tone.config(range: -15.0...15.0, value: 0, labelName: "Tone") { (value) in
            self.voice.pitchShifter.shift = Double(value).round(nearest: 0.5)
        }
        
        //Delay
        delayToggle.value = 1
        delayToggle.callback = { value in
            if value == 0 {
                self.voice.multiDelay.stop()
            } else {
                self.voice.multiDelay.start()
                self.voice.multiDelay.balance = self.delayMixKnob.slider.value
            }
        }
        voice.multiDelay.time = 0.85
        delayTimeKnob.config(range: 0 ... 1.0, value: 0.85, labelName: "delayTimeKnob") { (value) in
            self.voice.multiDelay.time = value
        }
        delayFeedbackKnob.config(range: 0 ... 1.0, value: 0.25, labelName: "delayFeedbackKnob") { (value) in
            self.voice.multiDelay.feedback = value
        }
        delayMixKnob.config(range: 0 ... 1.0, value: 0, labelName: "delayMixKnob") { (value) in
            guard self.delayToggle.value == 1 else { return }
            self.voice.multiDelay.balance = value
        }
        
        //Filter
        filterToggle.callback = { value in
            if value == 0 {
                self.voice.filterSection.output.stop()
            } else {
                self.voice.filterSection.output.start()
            }
        }
        freqKnob.slider.taper = 4
        voice.filterSection.cutoffFrequency = 1000
        freqKnob.config(range: 100 ... 16000, value: 1000, labelName: "freqKnob") { (value) in
            self.voice.filterSection.cutoffFrequency = value
            self.voice.filterSection.lfoAmplitude = Double(self.lfoAmtKnob.slider.knobValue) * value
        }
        voice.filterSection.resonance = 0.4
        rezKnob.config(range: 0 ... 0.98, value: 0.4, labelName: "rezKnob") { (value) in
            self.voice.filterSection.resonance = value
        }
        
        lfoRateKnob.slider.taper = 2.5
        voice.filterSection.lfoRate = 0.5
        lfoRateKnob.config(range: 0 ... 5, value: 0.5, labelName: "lfoRateKnob") { (value) in
            self.voice.filterSection.lfoRate = value
        }
        voice.filterSection.lfoAmplitude = 0.5
        lfoAmtKnob.config(range: 0 ... 1, value: 0.5, labelName: "lfoAmtKnob") { (value) in
            let lfoAmp = value * self.voice.filterSection.cutoffFrequency
            self.voice.filterSection.lfoAmplitude = lfoAmp
        }

        //Reverb
        reverbToggle.value = 1
        reverbToggle.callback = { value in
            if value == 0 {
                self.voice.reverbMixer.balance = 0.0
            } else {
                self.voice.reverbMixer.balance = self.reverbMixKnob.slider.value
            }
        }
        reverbAmtKnob.slider.knobValue = 0.7
        voice.reverb.feedback = 0.7
        reverbAmtKnob.config(range: 0 ... 1, value: 0.7, labelName: "reverbAmtKnob") { (value) in
            self.voice.reverb.feedback = value
        }
        
        reverbMixKnob.config(range: 0 ... 1, value: 0.3, labelName: "reverbMixKnob") { (value) in
            if self.reverbToggle.isOn { self.voice.reverbMixer.balance = value }
        }


        //AutoPan
        autoPanToggle.callback = { value in
            if value == 0 {
                self.voice.autoPanMixer.balance = 0
            } else {
                self.voice.autoPanMixer.balance = 1
            }
        }
        fattenToggle.callback = { value in
            if value == 0 {
                self.voice.fatten.dryWetMix.balance = 0
            } else {
                self.voice.fatten.dryWetMix.balance = 1
            }
        }
        autoPanRateKnob.slider.taper = 2
        autoPanRateKnob.config(range: 0 ... 5, value: 0, labelName: "autoPanRateKnob") { (value) in
            self.voice.autopan.freq = value
        }

        //Vol
        self.voice.mic.volume = 1.0
        vol1Knob.config(range: 0 ... 20.0, value: 1.0, labelName: "vol1Knob") { (value) in
            self.voice.mic.volume = value
        }
        
        voice.masterVolume.volume = 2.5
        masterVolume.config(range: 0 ... 5.0, value: 2.5, labelName: "masterVolume") { (value) in
            self.voice.masterVolume.volume = value
        }

        //Auditon
        //Distortion + Bit Crush
        distortionToggle.value = 0
        distortionToggle.callback = { value in
            if value == 0 {
                self.voice.decimator.mix = 0
            } else {
                self.voice.decimator.mix = 1
            }
        }
        voice.decimator.rounding = 0.0
        voice.decimator.mix = 0.0
        distortKnob.config(range: 0.6 ... 0.99, value: 0.6, labelName: "distortKnob") { (value) in
            self.voice.decimator.rounding = value
        }
        voice.decimator.decimation = 0
        crushKnob.slider.taper = 1.0
        crushKnob.config(range: 0 ... 0.06, value: 0.0, labelName: "crushKnob") { (value) in
            self.voice.decimator.decimation = value
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }


}


class SongVol: NSObject {
    var sequencer: AKAppleSequencer!
    var decimator: AKDecimator!
    var tremolo: AKTremolo!
    var fatten: Fatten!
    var filterSection: FilterSection!

    var autoPanMixer: AKDryWetMixer!
    var autopan: AutoPan!

    var multiDelay: PingPongDelay!
    var masterVolume = AKMixer()
    var reverb: AKCostelloReverb!
    var reverbMixer: AKDryWetMixer!
    var micMixer: AKMixer!
    var tracker: AKFrequencyTracker!
    var pitchShifter: AKPitchShifter!
    var micBooster: AKBooster!
    var mic: AKMicrophone!
    
    func getOutPut() -> AKNode {
        mic = AKMicrophone()
        micMixer = AKMixer(mic)
        tracker = AKFrequencyTracker.init(mic)
        micBooster = AKBooster(micMixer)
        pitchShifter = AKPitchShifter(micBooster, shift: 0)
        micBooster.gain = 1

        // Signal Chain
        tremolo = AKTremolo(pitchShifter, waveform: AKTable(.sine))
        decimator = AKDecimator(tremolo)
        filterSection = FilterSection(decimator)
        filterSection.output.stop()
        
        autopan = AutoPan(filterSection)
        autoPanMixer = AKDryWetMixer(filterSection, autopan)
        autoPanMixer.balance = 0
        
        fatten = Fatten(autoPanMixer)
        
        multiDelay = PingPongDelay(fatten)
        
        masterVolume = AKMixer(multiDelay)
        
        reverb = AKCostelloReverb(masterVolume)
        
        reverbMixer = AKDryWetMixer(masterVolume, reverb, balance: 0.3)
        
        return reverbMixer
    }
    
    
}
