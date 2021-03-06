//
//  SettingPianoViewController.swift
//  Piano_App
//
//  Created by Azibai on 17/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
protocol SettingPianoDelegate: class {
    func done(tone: Tone, currentSound: Int)
}
class SettingPianoViewController: UIViewController {
    let conductor = Conductor.sharedInstance
    var tone: Tone = .Do
    let arrSound = [ "TX Brass.sfz", "TX LoTine81z.sfz", "TX Metalimba.sfz", "TX Pluck Bass.sfz" ]
    var currentSound = 0
    
    weak var delegate: SettingPianoDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBOutlet weak var navView: UIView!
    
    
    @IBOutlet weak var reverbAmtKnob: MIDIKnob!
    @IBOutlet weak var reverbMixKnob: MIDIKnob!
    
    @IBOutlet weak var delayTimeKnob: MIDIKnob!
    @IBOutlet weak var delayFeedbackKnob: MIDIKnob!
    @IBOutlet weak var delayMixKnob: MIDIKnob!
    
    @IBOutlet weak var vol1Knob: MIDIKnob!
    @IBOutlet weak var masterVolume: MIDIKnob!
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var freqKnob: MIDIKnob!
    @IBOutlet weak var rezKnob: MIDIKnob!
    @IBOutlet weak var lfoRateKnob: MIDIKnob!
    @IBOutlet weak var lfoAmtKnob: MIDIKnob!
    
    @IBOutlet weak var autoPanRateKnob: MIDIKnob!
    @IBOutlet weak var distortKnob: MIDIKnob!
    @IBOutlet weak var crushKnob: MIDIKnob!
    
    @IBOutlet weak var sub24Toggle: ToggleButton!
    @IBOutlet weak var fattenToggle: ToggleButton!
    @IBOutlet weak var filterToggle: ToggleButton!
    @IBOutlet weak var reverbToggle: LedButton!
    @IBOutlet weak var delayToggle: LedButton!
    @IBOutlet weak var autoPanToggle: ToggleButton!
    @IBOutlet weak var distortionToggle: ToggleButton!
    
    @IBOutlet weak var attackKnob: MIDIKnob!
    @IBOutlet weak var releaseKnob: MIDIKnob!
    
    
    func config(tone: Tone = .Do,
                currentSound: Int = 0) {
        self.tone = tone
        self.currentSound = currentSound
    }

    
    @IBAction func clickSound(_ sender: Any?) {
        self.showAlert(title: "Chọn Sound", message: "", buttonTitles: arrSound, highlightedButtonIndex: nil) { (index) in
            
            let newPreset = self.arrSound[index]
            self.outputLabel.text = newPreset
            self.conductor.useSound(newPreset)
            
            // reset attack/release knob positions
            self.attackKnob.knobValue = 0.0
            self.releaseKnob.knobValue = 0.33

            
            self.currentSound = index
        }
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        self.dismiss {
            self.delegate?.done(tone: self.tone,
                                currentSound: self.currentSound)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
        setupCallbacks()
        
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.navView.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        
    }
    
    func setUpdefaut() {
        
    }
    
    func setDefaults() {
//        vol1Knob.range = -9 ... 3
//        vol1Knob.value = log(conductor.sampler1.masterVolume)
//
//        masterVolume.range = 0 ... 5.0
//        masterVolume.value = conductor.masterVolume.volume
//
//        autoPanRateKnob.range = 0 ... 5
//        autoPanRateKnob.taper = conductor.autopan.freq
//
//        reverbAmtKnob.knobValue = CGFloat(conductor.reverb.feedback)
//        reverbMixKnob.value = 0.3
//
//
//
//        if reverbToggle.isOn {
//            reverbMixKnob.value = conductor.reverbMixer.balance
//        } else {
//            reverbMixKnob.value = 0
//        }
//
//        conductor.multiDelay.time = 0.85
//        delayTimeKnob.range = 0 ... 1.0
//        delayTimeKnob.value = conductor.multiDelay.time
//
//        delayFeedbackKnob.range = 0.0 ... 1.0
//        delayFeedbackKnob.value = conductor.multiDelay.feedback
//
//        if delayToggle.value == 1 {
//            delayMixKnob.value = conductor.multiDelay.balance
//        } else {
//            delayMixKnob.value = 0
//        }
//
//        freqKnob.range = 100 ... 16000
//        freqKnob.taper = 4
//        freqKnob.value = conductor.filterSection.cutoffFrequency
//
//
//        rezKnob.range = 0 ... 0.98
//        rezKnob.value = self.conductor.filterSection.resonance
//
//        lfoAmtKnob.range = 0 ... 1
//        lfoAmtKnob.value = conductor.filterSection.cutoffFrequency * conductor.filterSection.cutoffFrequency
//
//        lfoRateKnob.range = 0 ... 5
//        lfoRateKnob.taper = 2.5
//        lfoRateKnob.value = conductor.filterSection.lfoRate
//
//        distortKnob.range = 0.6 ... 0.99
//        distortKnob.value = conductor.decimator.rounding
//        distortionToggle.value = self.conductor.decimator.mix
//
//
//
//        crushKnob.range = 0 ... 0.06
//        crushKnob.taper = 1.0
//        crushKnob.value = conductor.decimator.decimation
//
//        attackKnob.range = 0.001 ... 6
//        releaseKnob.range = 0.01 ... 5
//        releaseKnob.value = conductor.sampler1.releaseDuration

             // Set Default Knob/Control Values
             vol1Knob.range = -9 ... 3
             vol1Knob.value = -2
             conductor.sampler1.masterVolume = 0.8
             
             masterVolume.range = 0 ... 5.0
             masterVolume.value = 2.5
             conductor.masterVolume.volume = 2.5
            
             autoPanRateKnob.range = 0 ... 5
             autoPanRateKnob.taper = 2
             
             reverbAmtKnob.knobValue = 0.7
             conductor.reverb.feedback = 0.7
             reverbMixKnob.value = 0.3
             reverbToggle.value = 1
             
             delayTimeKnob.range = 0 ... 1.0
             delayTimeKnob.value = 0.85
             conductor.multiDelay.time = 0.85
             
             delayFeedbackKnob.range = 0.0 ... 1.0
             delayFeedbackKnob.value = 0.25
             
             delayMixKnob.value = 0.0
             delayToggle.value = 1
            
             freqKnob.range = 100 ... 16000
             freqKnob.taper = 4
             freqKnob.value = 1000
             conductor.filterSection.cutoffFrequency = 1000
             
             rezKnob.range = 0 ... 0.98
             rezKnob.value = 0.4
             conductor.filterSection.resonance = 0.4
             
             lfoAmtKnob.range = 0 ... 1
             lfoAmtKnob.value = 0.5
             conductor.filterSection.lfoAmplitude = 0.5
             
             lfoRateKnob.range = 0 ... 5
             lfoRateKnob.taper = 2.5
             lfoRateKnob.value = 0.5
             conductor.filterSection.lfoRate = 0.5
        
             conductor.tremolo.depth = 0.5
             conductor.tremolo.frequency = 0
             
             distortKnob.range = 0.6 ... 0.99
             distortKnob.value = 0.6
             conductor.decimator.rounding = 0.0
             conductor.decimator.mix = 0.0
             distortionToggle.value = 0
             
             crushKnob.range = 0 ... 0.06
             crushKnob.taper = 1.0
             crushKnob.value = 0.0
             conductor.decimator.decimation = 0
             
             attackKnob.range = 0.001 ... 6
             releaseKnob.range = 0.01 ... 5
             releaseKnob.value = 0.8

    }
    @IBOutlet weak var changeSample: SynthUIButton!
    @IBOutlet weak var toneChange: SynthUIButton!
    @IBOutlet weak var soundChange: SynthUIButton!

    var isLoadSampleDefault: Bool = true

    func setupCallbacks() {
        
        toneChange.callback = { _ in
            self.showAlert(title: "Chọn Tone", message: "", buttonTitles: self.tone.arrTone.map({ $0.getName(quang: "")}), highlightedButtonIndex: nil) { (index) in
                self.tone = self.tone.arrTone[index]
            }
        }
        
        soundChange.callback = { _ in
            self.showAlert(title: "Chọn Sound", message: "", buttonTitles: self.arrSound, highlightedButtonIndex: nil) { (index) in
                
                let newPreset = self.arrSound[index]
                self.outputLabel.text = newPreset
                self.conductor.useSound(newPreset)
                
                // reset attack/release knob positions
                self.attackKnob.knobValue = 0.0
                self.releaseKnob.knobValue = 0.33
                
                
                self.currentSound = index
            }
        }

        changeSample.callback = { _ in
            self.showAlert(title: "", message: "", buttonTitles: ["Mix Default", "Mix Optionally Edit"], highlightedButtonIndex: self.isLoadSampleDefault ? 0: 1) { (value) in
                self.isLoadSampleDefault = value == 0 ? true: false
                self.conductor.changeSample(isDefault: self.isLoadSampleDefault)
            }
        }
        
        vol1Knob.callback = { value in
            self.conductor.sampler1.masterVolume = pow(10.0, value / 20.0)
            self.outputLabel.text = "Vol Boost: \(value.decimalString) db"
        }
        
        masterVolume.callback = { value in
            self.conductor.masterVolume.volume = value
            self.outputLabel.text = "Master Vol: \((value/self.masterVolume.range.upperBound).percentageString)"
        }
        
        distortKnob.callback = { value in
            self.conductor.decimator.rounding = value
            self.outputLabel.text = "Distort: \(Double(self.distortKnob.knobValue).percentageString)"
        }
        
        crushKnob.callback = { value in
            self.conductor.decimator.decimation = value
            self.outputLabel.text = "Crusher: \(Double(self.crushKnob.knobValue).percentageString)"
        }
        
        freqKnob.callback = { value in
            self.conductor.filterSection.cutoffFrequency = value
            self.outputLabel.text = "Freq: \(value.decimalString) Hz"
            
            // Adjust LFO Knob
            self.conductor.filterSection.lfoAmplitude = Double(self.lfoAmtKnob.knobValue) * value
        }
        
        rezKnob.callback = { value in
            self.conductor.filterSection.resonance = value
            self.outputLabel.text = "Rez/Q: \(value.decimalString)"
        }
        
        lfoRateKnob.callback = { value in
            self.conductor.filterSection.lfoRate = value
            self.outputLabel.text = "LFO Rate: \(value.decimalString) Hz"
        }
        
        lfoAmtKnob.callback = { value in
            // Calculate percentage of frequency
            let lfoAmp = value * self.conductor.filterSection.cutoffFrequency
            self.conductor.filterSection.lfoAmplitude = lfoAmp
            self.outputLabel.text = "LFO Amt: \(value.percentageString), Freq: \(lfoAmp.decimalString)Hz"
        }
        
        reverbAmtKnob.callback = { value in
            self.conductor.reverb.feedback = value
            if value == 1.0 {
                self.outputLabel.text = "Reverb Level: Blackhole!"
            } else {
                self.outputLabel.text = "Reverb Level: \(value.percentageString)"
            }
          
        }
        
        reverbMixKnob.callback = { value in
            if self.reverbToggle.isOn { self.conductor.reverbMixer.balance = value }
            self.outputLabel.text = "Reverb Wet: \(value.percentageString)"
        }
        
        delayTimeKnob.callback = { value in
            self.conductor.multiDelay.time = value
            self.outputLabel.text = "Time Between Taps: \(value.decimalString)ms"
        }
        
        delayFeedbackKnob.callback = { value in
            self.conductor.multiDelay.feedback = value
            switch value {
            case 0:
                self.outputLabel.text = "Feedback: Basic Multi-taps"
            case 0.99:
                self.outputLabel.text = "Feedback: Blackhole!"
            default:
                self.outputLabel.text = "Feedback knob: \(value.decimalString)"
            }
        }
        
        delayMixKnob.callback = { value in
            guard self.delayToggle.value == 1 else { return }
            self.conductor.multiDelay.balance = value
            self.outputLabel.text = "Delay Dry/Wet: \(value.percentageString)"
        }
        
        autoPanRateKnob.callback = { value in
            self.conductor.autopan.freq = value
            self.outputLabel.text = "Auto Pan Rate: \(value.decimalString) Hz"
        }
        
//        auditionBass.callback = { value in
//            if value == 1 { self.conductor.midiLoad("rom_bass") }
//            self.conductor.sequencerToggle(value)
//        }
//
//        auditionLead.callback = { value in
//            if value == 1 { self.conductor.midiLoad("rom_lead") }
//            self.conductor.sequencerToggle(value)
//        }
//
//        auditionPoly.callback = { value in
//            if value == 1 { self.conductor.midiLoad("rom_poly") }
//            self.conductor.sequencerToggle(value)
//        }
        
        autoPanToggle.callback = { value in
            if value == 0 {
                self.outputLabel.text = "Auto Pan Off"
                self.conductor.autoPanMixer.balance = 0
            } else {
                self.outputLabel.text = "Auto Pan On"
                self.conductor.autoPanMixer.balance = 1
            }
        }
        
        reverbToggle.callback = { value in
            if value == 0 {
                self.outputLabel.text = "Reverb Off"
                self.conductor.reverbMixer.balance = 0.0
            } else {
                self.outputLabel.text = "Reverb On"
                self.conductor.reverbMixer.balance = self.reverbMixKnob.value
            }
        }
        
        distortionToggle.callback = { value in
            if value == 0 {
                self.outputLabel.text = "Distortion Off"
                self.conductor.decimator.mix = 0
            } else {
                self.outputLabel.text = "Distortion On"
                self.conductor.decimator.mix = 1
            }
        }
        
        delayToggle.callback = { value in
            if value == 0 {
                self.outputLabel.text = "Delay Off"
                self.conductor.multiDelay.stop()
            } else {
                self.outputLabel.text = "Delay On"
                self.conductor.multiDelay.start()
                self.conductor.multiDelay.balance = self.delayMixKnob.value
            }
        }
        
        filterToggle.callback = { value in
            if value == 0 {
                self.outputLabel.text = "Filter Off"
                self.conductor.filterSection.output.stop()
            } else {
                self.outputLabel.text = "Filter On"
                self.conductor.filterSection.output.start()
            }
        }
        
        fattenToggle.callback = { value in
            if value == 0 {
                self.outputLabel.text = "Stereo Widen Off"
                self.conductor.fatten.dryWetMix.balance = 0
            } else {
                self.outputLabel.text = "Stereo Widen On"
                self.conductor.fatten.dryWetMix.balance = 1
            }
        }
        
        attackKnob.callback = { value in
            self.conductor.sampler1.attackDuration = value
            self.outputLabel.text = "Attack: \(Int(value))"
        }
        
        releaseKnob.callback = { value in
            self.conductor.sampler1.releaseDuration = value
            self.outputLabel.text = "Release: \(Int(value))"
        }
    }
    
    
}
