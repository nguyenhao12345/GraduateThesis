//
//  PianoPracticeViewController.swift
//  Piano_App
//
//  Created by Azibai on 24/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit
import AudioKit
import AudioKitUI

@available(iOS 13.0, *)
class PianoPracticeViewController: AziBaseViewController {
        //MARK: Init
    let conductor = Conductor.sharedInstance
    @IBOutlet weak var keyboardView: SynthKeyboard!
    @IBOutlet weak var octaveStepper: Stepper!
    @IBOutlet weak var displayContainer: SoftUIView!
    @IBOutlet weak var configureKeyboardButton: SynthUIButton!
    @IBOutlet weak var soundsChange: SynthUIButton!
    @IBOutlet weak var beatsChange: SynthUIButton!
    @IBOutlet weak var changeSample: SynthUIButton!
    @IBOutlet weak var toastLbl: UILabel!

    @IBOutlet weak var viewChangeKeys: UIView!
    @IBOutlet weak var octaveRangeSegment: UISegmentedControl!
    @IBOutlet weak var typeNoteSegment: UISegmentedControl!
    @IBOutlet weak var labelModeSegment: UISegmentedControl!
    @IBOutlet weak var keyboardModeSegment: UISegmentedControl!
    @IBOutlet weak var keyboardImage: UIImageView!
    
    @IBOutlet weak var viewVideo: DefaultCustomAVPlayer!
    @IBOutlet weak var onOfBtn: LedButton!
    @IBOutlet weak var volumeBtn: MIDIKnob!
    @IBOutlet weak var volumeKeyBtn: MIDIKnob!
    @IBOutlet weak var playBtn: UIButton!
    
    //MARK: Dellay
    @IBOutlet weak var dellayBtn: LedButton!
    @IBOutlet weak var dellay_Time: MIDIKnob!
    @IBOutlet weak var dellay_FeedBack: MIDIKnob!
    @IBOutlet weak var dellay_Mix: MIDIKnob!

    //MARK: Reverb
    @IBOutlet weak var reverbBtn: LedButton!
    @IBOutlet weak var reverb_amt: MIDIKnob!
    @IBOutlet weak var reverb_mix: MIDIKnob!

    //MARK: PAN
    @IBOutlet weak var autoPanToggle: ToggleButton!
    @IBOutlet weak var autoPanRateKnob: MIDIKnob!
    @IBOutlet weak var attackKnob: MIDIKnob!
    @IBOutlet weak var releaseKnob: MIDIKnob!
    @IBOutlet weak var fattenToggle: ToggleButton!

    @IBOutlet weak var filterToggle: ToggleButton!
    @IBOutlet weak var freqKnob: MIDIKnob!
    @IBOutlet weak var rezKnob: MIDIKnob!
    @IBOutlet weak var lfoAmtKnob: MIDIKnob!
    @IBOutlet weak var lfoRateKnob: MIDIKnob!
    
    var currentSound = 1
    let arrSound: [String] = [ "TX Brass", "TX LoTine81z", "TX Metalimba", "TX Pluck Bass" ]
    let arrSoundName: [String] = [ "Brass", "LoTine81z", "Metalimba", "Pluck Bass" ]

    
    
    var curentBeat: Int? = nil
    
    let arrBeat: [String] = LocalVideoManager.shared.getAllLocalSongYoutube().map({ $0.snippet.title })


    var labelMode: Int = 1
    var octaveRange: Int = 2
    var darkMode: Bool = true
    var isLoadSampleDefault: Bool = true
    enum KeyImage: String {
        case lightMode = "mockup_whitekeys"
        case darkMode = "mockup_blackkeys"
    }


    @IBAction func clickBack(_ sender: Any?) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.shouldRotate = false
        }
        isDarkSoftUIView = false
        displayContainer.removeFromSuperview()
        self.conductor.sampler1.masterVolume = 2.5
        self.conductor.filterSection.output.stop()
        self.conductor.multiDelay.stop()
        self.conductor.reverbMixer.balance = 0.0
        self.conductor.autoPanMixer.balance = 0
        self.conductor.fatten.dryWetMix.balance = 0
        self.dismiss()
    }
    
    func setUpKeys() {
        octaveRangeSegment.selectedSegmentIndex = octaveRange - 1
        labelModeSegment.selectedSegmentIndex = labelMode
        typeNoteSegment.selectedSegmentIndex = 1
        keyboardModeSegment.selectedSegmentIndex = darkMode ? 1 : 0
        if !darkMode {
            keyboardImage.image = UIImage(named: KeyImage.lightMode.rawValue)
        }
    }
    
    @IBAction func octaveRangeDidChange(_ sender: UISegmentedControl) {
        octaveRange = sender.selectedSegmentIndex + 1
        didFinishSelecting(octaveRange: octaveRange, labelMode: labelMode, darkMode: darkMode)
    }
    
    @IBAction func typeNoteDidChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            keyboardView.isShowViet = true
        } else {
            keyboardView.isShowViet = false
        }
        didFinishSelecting(octaveRange: octaveRange, labelMode: labelMode, darkMode: darkMode)
    }
    @IBAction func keyLabelDidChange(_ sender: UISegmentedControl) {
        labelMode = sender.selectedSegmentIndex
        didFinishSelecting(octaveRange: octaveRange, labelMode: labelMode, darkMode: darkMode)
    }
    
    
    @IBAction func keyboardModeDidChange(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            darkMode = true
            keyboardImage.image = UIImage(named: KeyImage.darkMode.rawValue)
        } else {
            darkMode = false
            keyboardImage.image = UIImage(named: KeyImage.lightMode.rawValue)
        }
        
        didFinishSelecting(octaveRange: octaveRange, labelMode: labelMode, darkMode: darkMode)
    }
    
    func didFinishSelecting(octaveRange: Int, labelMode: Int, darkMode: Bool) {
        keyboardView.octaveCount = octaveRange
        keyboardView.labelMode = labelMode
        keyboardView.darkMode = darkMode
        keyboardView.setNeedsDisplay()
    }

    @IBAction func playTapHandler() {
        if onOfBtn.value == 0 {
            self.showToast(string: "Vui lòng bật màn hình", duration: 1.5, position: .top)
            return
        }
        
        if viewVideo._currentVideoState == .none {
            self.showToast(string: "Bạn chưa chọn beat/bài hát", duration: 1.5, position: .top)
            return
        }

        if viewVideo.getStatusPlaying() {
            self.setTextToastLbl(text: "Pausing")
            viewVideo.pause()
            playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            self.setTextToastLbl(text: "Playing")
            viewVideo.play()
            playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func backwardTapHandler() {
        self.setTextToastLbl(text: "Backward")
    }

    @IBAction func forwardTapHandler() {
        self.setTextToastLbl(text: "Forward")
    }


    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewChangeKeys.isHidden = true
        viewIsReady()
        setUpKeys()
        
        keyboardView.delegate = self
        keyboardView.polyphonicMode = true
        keyboardView.firstOctave = 2

         self.conductor.useSound(arrSound[currentSound])
        displayContainer.type = .normal
        displayContainer.isSelected = true
        
        
        let plot = AKNodeFFTPlot(AudioKit.output, frame: CGRect(x: 0, y: 0, width: 2400, height: 86))
        plot.frame = CGRect(origin: .zero, size: CGSize(width: displayContainer.width*10, height: displayContainer.height))
        plot.color = #colorLiteral(red: 0.537254902, green: 0.9019607843, blue: 0.9764705882, alpha: 1)
        plot.backgroundColor = #colorLiteral(red: 0.2431372549, green: 0.2431372549, blue: 0.262745098, alpha: 0)
        plot.gain = 5
        displayContainer.addSubview(plot)

        viewVideo.cornerRadius = displayContainer.cornerRadius
        setUpCallBacks()
    }
    
    func setTextToastLbl(text: String) {
        self.toastLbl.text = text
    }
    
    func setUpCallBacks() {
        
//        conductor.sampler1.masterVolume = 0.8
//        conductor.masterVolume.volume = 2.5
        conductor.tremolo.depth = 0.5
        conductor.tremolo.frequency = 0
        conductor.decimator.decimation = 0

        lfoRateKnob.range = 0 ... 5
        lfoRateKnob.taper = 2.5
        lfoRateKnob.value = 0.5
        conductor.filterSection.lfoRate = 0.5
        lfoRateKnob.callback = { value in
            self.conductor.filterSection.lfoRate = value
            self.setTextToastLbl(text: "LFO Rate: \(value.decimalString) Hz")
        }

        
        lfoAmtKnob.range = 0 ... 1
        lfoAmtKnob.value = 0.5
        conductor.filterSection.lfoAmplitude = 0.5
        lfoAmtKnob.callback = { value in
            // Calculate percentage of frequency
            let lfoAmp = value * self.conductor.filterSection.cutoffFrequency
            self.conductor.filterSection.lfoAmplitude = lfoAmp
            self.setTextToastLbl(text: "LFO Amt: \(value.percentageString), Freq: \(lfoAmp.decimalString)Hz")
        }

        
        rezKnob.range = 0 ... 0.98
        rezKnob.value = 0.4
        conductor.filterSection.resonance = 0.4
        rezKnob.callback = { value in
            self.conductor.filterSection.resonance = value
            self.setTextToastLbl(text: "Rez/Q: \(value.decimalString) Hz")
        }

        freqKnob.range = 100 ... 16000
        freqKnob.taper = 4
        freqKnob.value = 1000
        conductor.filterSection.cutoffFrequency = 1000
        freqKnob.callback = { value in
            self.conductor.filterSection.cutoffFrequency = value
            self.setTextToastLbl(text: "Freq: \(value.decimalString) Hz")

            // Adjust LFO Knob
            self.conductor.filterSection.lfoAmplitude = Double(self.lfoAmtKnob.knobValue) * value
        }

        
        filterToggle.callback = { value in
            if value == 0 {
                self.setTextToastLbl(text: "Filter Off")
                self.conductor.filterSection.output.stop()
            } else {
                self.setTextToastLbl(text: "Filter On")
                self.conductor.filterSection.output.start()
            }
        }

        fattenToggle.callback = { value in
            if value == 0 {
                self.setTextToastLbl(text: "Stereo Widen Off")
                self.conductor.fatten.dryWetMix.balance = 0
            } else {
                self.setTextToastLbl(text: "Stereo Widen On")
                self.conductor.fatten.dryWetMix.balance = 1
            }
        }
        
        releaseKnob.range = 0.01 ... 5
        releaseKnob.value = 0.8
        releaseKnob.callback = { value in
            self.conductor.sampler1.releaseDuration = value
            self.setTextToastLbl(text: "Release: \(Int(value))")
        }

        attackKnob.range = 0.001 ... 6
        attackKnob.callback = { value in
            self.conductor.sampler1.attackDuration = value
            self.setTextToastLbl(text: "Attack: \(Int(value))")
        }
        
        autoPanRateKnob.range = 0 ... 5
        autoPanRateKnob.taper = 2
        autoPanRateKnob.callback = { value in
            self.conductor.autopan.freq = value
            self.setTextToastLbl(text: "Auto Pan Rate: \(value.decimalString) Hz")
        }

        autoPanToggle.callback = { value in
            if value == 0 {
                self.setTextToastLbl(text: "Auto Pan Off")
                self.conductor.autoPanMixer.balance = 0
            } else {
                self.setTextToastLbl(text: "Auto Pan On")
                self.conductor.autoPanMixer.balance = 1
            }
        }

        
        reverbBtn.value = 1
        reverbBtn.callback = { value in
            if value == 0 {
                self.setTextToastLbl(text: "Reverb Off")
                self.conductor.reverbMixer.balance = 0.0
            } else {
                self.setTextToastLbl(text: "Reverb On")
                self.conductor.reverbMixer.balance = self.reverb_mix.value
            }
        }
        
        reverb_amt.knobValue = 0.7
        conductor.reverb.feedback = 0.7
        reverb_amt.callback = { value in
            self.conductor.reverb.feedback = value
            if value == 1.0 {
                self.setTextToastLbl(text: "Reverb Level: Blackhole!")
            } else {
                self.setTextToastLbl(text: "Reverb Level: \(value.percentageString)!")
            }
        }
        
        reverb_mix.value = 0.3
        reverb_mix.callback = { value in
            if self.reverbBtn.isOn { self.conductor.reverbMixer.balance = value }
            self.setTextToastLbl(text: "Reverb Wet: \(value.percentageString)!")
        }


        
        
        dellayBtn.value = 1
        dellayBtn.callback = { value in
            if value == 0 {
                self.setTextToastLbl(text: "Delay Off")
                self.conductor.multiDelay.stop()
            } else {
                self.setTextToastLbl(text: "Delay On")
                self.conductor.multiDelay.start()
                self.conductor.multiDelay.balance = self.dellay_Mix.value
            }
        }
        
        dellay_Time.range = 0 ... 1.0
        dellay_Time.value = 0.85
        conductor.multiDelay.time = 0.85
        dellay_Time.callback = {  value in
            self.conductor.multiDelay.time = value
            self.setTextToastLbl(text: "Time Between Taps: \(value.decimalString)ms")
        }
        
        
        dellay_FeedBack.range = 0.0 ... 1.0
        dellay_FeedBack.value = 0.25
        dellay_FeedBack.callback = {  value in
            self.conductor.multiDelay.feedback = value
            switch value {
            case 0:
                self.setTextToastLbl(text: "Feedback: Basic Multi-taps")
            case 0.99:
                self.setTextToastLbl(text: "Feedback: Blackhole!")
            default:
                self.setTextToastLbl(text: "Feedback knob: \(value.decimalString)")
            }
        }

        dellay_Mix.value = 0.0
        dellay_Mix.callback = {  value in
            guard self.dellayBtn.value == 1 else { return }
            self.conductor.multiDelay.balance = value
            self.setTextToastLbl(text: "Delay Dry/Wet: \(value.percentageString)")
        }
        
        octaveStepper.minValue = -2
        octaveStepper.maxValue = 3
        octaveStepper.callback = { value in
            self.keyboardView.firstOctave = Int(value) + 2
            self.setTextToastLbl(text: "\(value)")
        }
        
        configureKeyboardButton.callback = { _ in
            self.configureKeyboardButton.value = 0
            self.viewChangeKeys.isHidden = false
        }
        
        soundsChange.callback = { _ in
            self.soundsChange.value = 0
            self.showAlert(title: "Chọn nhạc cụ", message: nil, buttonTitles: self.arrSound, highlightedButtonIndex: self.currentSound) { (value) in
                self.currentSound = value
                 self.conductor.useSound(self.arrSound[value])
                self.setTextToastLbl(text: self.arrSoundName[value])
            }
        }
        
        beatsChange.callback = { _ in
            self.beatsChange.value = 0
            self.showAlert(title: "Chọn Beat", message: nil, buttonTitles: self.arrBeat, highlightedButtonIndex: self.curentBeat) { (value) in
                self.curentBeat = value
                ASVideoPlayerController.sharedVideoPlayer.pauseRemoveLayer(customAVPlayer: self.viewVideo)
                self.viewVideo.config(localURL: LocalVideoManager.shared.getURLVideoLocal(key: self.arrBeat[value]))
                ASVideoPlayerController.sharedVideoPlayer.playVideo(withCustomAVPlayer: self.viewVideo)
                self.onOfBtn.value = 1
                self.playBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                self.setTextToastLbl(text: self.arrBeat[value])
            }
        }
        
        changeSample.callback = { _ in
//            self.conductor.changeSample(isDefault: changeSample.value == 1.0)
            self.showAlert(title: "", message: "", buttonTitles: ["Mix Default", "Mix Optionally Edit"], highlightedButtonIndex: self.isLoadSampleDefault ? 0: 1) { (value) in
                self.isLoadSampleDefault = value == 0 ? true: false
                self.conductor.changeSample(isDefault: self.isLoadSampleDefault)
            }
        }
        
        volumeKeyBtn.range = 0 ... 5.0
        volumeKeyBtn.value = 2.5
        self.conductor.sampler1.masterVolume = 2.5

        volumeKeyBtn.callback = { value in
            self.conductor.sampler1.masterVolume = value
            self.setTextToastLbl(text: "Master Vol: \((value/self.volumeKeyBtn.range.upperBound).percentageString)")
        }

        volumeBtn.range = 0 ... 1
        volumeBtn.value = 1
        volumeBtn.callback = { value in
            self.viewVideo.videoLayer.player?.volume = Float(value)
            self.setTextToastLbl(text: "Âm lượng beat: \(value*100)%")
        }
        
        onOfBtn.value = 0
        onOfBtn.callback = { value in
            self.playBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            if self.curentBeat == nil {
                self.onOfBtn.value = 0
                return
            }

            if value == 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewVideo.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }) { _ in
                    self.viewVideo.transform = CGAffineTransform(scaleX: 0, y: 0)
                    ASVideoPlayerController.sharedVideoPlayer.pauseForceCurrent()
                }
                self.setTextToastLbl(text: "Tắt Video")
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewVideo.transform = .identity
                }) { _ in
                }
                self.setTextToastLbl(text: "Bật Video")
            }
        }
    }
    
    @IBAction func clickDoneChangeKey(_ sender: Any?) {
        viewChangeKeys.isHidden = true
    }
    
    open override var shouldAutorotate: Bool {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.shouldRotate
        }
        return true
    }

    //MARK: Method
    func viewIsReady() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.shouldRotate = true
        }

    }
   

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscapeRight }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      UIView.setAnimationsEnabled(false)
      UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
      UIView.setAnimationsEnabled(true)
    }
}


@available(iOS 13.0, *)
extension PianoPracticeViewController: AKKeyboardDelegate {
    
    public func noteOn(note: MIDINoteNumber, velocity: MIDIVelocity = 127) {
        conductor.playNote(note: note, velocity: velocity, channel: 0)
    }
    
    public func noteOff(note: MIDINoteNumber) {
        DispatchQueue.main.async {
            self.conductor.stopNote(note: note, channel: 0)
        }
    }
}

