import UIKit
import AudioKit
import AudioKitUI
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var viewVideo: CustomAVPlayer!
    let arrBeat: [String] = LocalVideoManager.shared.getAllLocalSongYoutube().map({ $0.snippet.title })
    var curentBeat: Int? = nil

    @IBAction func clickBeat(_ sender: Any?) {
        self.showAlert(title: "Chọn Beat", message: nil, buttonTitles: self.arrBeat, highlightedButtonIndex: self.curentBeat) { (value) in
            self.curentBeat = value
            ASVideoPlayerController.sharedVideoPlayer.pauseRemoveLayer(customAVPlayer: self.viewVideo)
            self.viewVideo.config(localURL: LocalVideoManager.shared.getURLVideoLocal(key: self.arrBeat[value]))
            ASVideoPlayerController.sharedVideoPlayer.playVideo(withCustomAVPlayer: self.viewVideo)
        }
    }
    
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.value = 0
            slider.minimumValue = -15
            slider.maximumValue = 15
            slider.addTarget(self, action: #selector(_handleVolumeheadSliderValueChanged), for: .valueChanged)
            slider.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd), for: .touchUpOutside)
            slider.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd), for: .touchCancel)

            slider.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var slider2: UISlider! {
        didSet {
            slider2.value = 0
            slider2.addTarget(self, action: #selector(_handleVolumeheadSliderValueChanged2), for: .valueChanged)
            slider2.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd2), for: .touchUpOutside)
            slider2.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd2), for: .touchCancel)

            slider2.addTarget(self, action: #selector(_handleVolumeheadSliderTouchEnd2), for: .touchUpInside)
        }
    }
    @objc private func _handleVolumeheadSliderTouchEnd2(_ sender: UISlider) {
        player.setPosition(Double(sender.value))
    }
    
    @objc private func _handleVolumeheadSliderValueChanged2(_ sender: UISlider) {
    }

    
    
    @objc private func _handleVolumeheadSliderTouchEnd(_ sender: UISlider) {
        sender.value = Float(Double(sender.value).round(nearest: 0.5))
        pitchShifter?.shift = Double(sender.value).round(nearest: 0.5)
        label.text = "\(Double(sender.value).round(nearest: 0.5))"
    }
    
    @objc private func _handleVolumeheadSliderValueChanged(_ sender: UISlider) {
        pitchShifter?.shift = Double(sender.value).round(nearest: 0.5)
        label.text = "\(Double(sender.value).round(nearest: 0.5))"
    }
    
    @IBOutlet weak var label: UILabel!


    @IBAction func clickStop(_ sender: Any?) {
        do{
            try AudioKit.stop()
        } catch {
            print("error occured")
        }
        
    }
    
    var player: AKPlayer!
    @IBAction func changemultiDelaytime(_ sender: UISlider) {
        multiDelay.time = Double(sender.value)

    }
    @IBAction func changefilterSectioncutoffFrequency(_ sender: UISlider) {
        filterSection.cutoffFrequency = Double(sender.value)
    }

    @IBAction func changefilterSectionresonance(_ sender: UISlider) {
                filterSection.resonance = Double(sender.value)

    }

    @IBAction func changelfoAmplitude(_ sender: UISlider) {
                filterSection.lfoAmplitude = Double(sender.value)

    }
    @IBAction func changelfoRate(_ sender: UISlider) {
                filterSection.lfoRate = Double(sender.value)

    }
    @IBAction func changedepth(_ sender: UISlider) {
        tremolo.depth = Double(sender.value)
    }
    @IBAction func changefrequency(_ sender: UISlider) {
        tremolo.frequency = Double(sender.value)
    }
    @IBAction func changerounding(_ sender: UISlider) {
                decimator.rounding = Double(sender.value)

    }
    @IBAction func changemix(_ sender: UISlider) {
                decimator.mix = Double(sender.value)

    }
    @IBAction func changedecimation(_ sender: UISlider) {
                decimator.decimation = Double(sender.value)

    }
    @IBAction func changebalance(_ sender: UISlider) {
                autoPanMixer.balance = Double(sender.value)

    }
    @IBAction func changedryWetMix(_ sender: UISlider) {
                fatten.dryWetMix.balance = Double(sender.value)

    }
    @IBAction func changefeedback(_ sender: UISlider) {
                reverb.feedback = Double(sender.value)

    }

    @IBAction func changeVolume(_ sender: UISlider) {
        volume.accept(Double(sender.value))
    }

    var volume: BehaviorRelay<Double> = BehaviorRelay(value: 1.0)
     @IBAction func start2(_ sender: Any?) {
            let mic = AKMicrophone()
    //        AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate

            let micMixer = AKMixer(mic)
            volume.subscribe(onNext: { (value) in
                mic?.volume = value
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    //        mic?.volume =
            tracker = AKFrequencyTracker.init(mic)
            micBooster = AKBooster(micMixer)
            pitchShifter = AKPitchShifter(micBooster, shift: 0)
            micBooster!.gain = 1
            
            
            AudioKit.output = pitchShifter
    //        pitchShifter
    //        reverbMixer
//            AKSettings.ioBufferDuration = 0x // Optional, set this to decrease latency


            // select input of device
            AKSettings.sampleRate = 44100
            AKSettings.channelCount = 2
//            AKSettings.playbackWhileMuted = true
//            AKSettings.enableRouteChangeHandling = false
//            AKSettings.useBluetooth = false
//            AKSettings.defaultToSpeaker = true
//            AKSettings.audioInputEnabled = false
    //        AKSettings.bufferLength = .longest
            
            do{
                try AudioKit.start()
            } catch {
                print("error occured")
            }


            do {

                if #available(iOS 10.0, *) {
                    try AKSettings.setSession(category: .playAndRecord , with: [.defaultToSpeaker])
    //                try AKSettings.session.overrideOutputAudioPort(.speaker)

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
    @IBAction func start(_ sender: Any?) {
        let mic = AKMicrophone()
//        AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate

        let micMixer = AKMixer(mic)
        volume.subscribe(onNext: { (value) in
            mic?.volume = value
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

//        mic?.volume =
        tracker = AKFrequencyTracker.init(mic)
        micBooster = AKBooster(micMixer)
        pitchShifter = AKPitchShifter(micBooster, shift: 0)
        micBooster!.gain = 1
        
           // Signal Chain
        tremolo = AKTremolo(pitchShifter, waveform: AKTable(.sine))
        decimator = AKDecimator(tremolo)
        filterSection = FilterSection(decimator)

        
        autopan = AutoPan(filterSection)
        autoPanMixer = AKDryWetMixer(filterSection, autopan)
        
        fatten = Fatten(autoPanMixer)
        
        multiDelay = PingPongDelay(fatten)
        
        
        masterVolume = AKMixer(multiDelay)
        
        reverb = AKCostelloReverb(masterVolume)

        reverbMixer = AKDryWetMixer(masterVolume, reverb, balance: 0.3)

        multiDelay.time = 0.2
        filterSection.output.start()
        filterSection.cutoffFrequency = 1000
        filterSection.resonance = 0.4
        filterSection.lfoAmplitude = 0.5
        filterSection.lfoRate = 0.5
        tremolo.depth = 0.5
        tremolo.frequency = 0
        decimator.rounding = 0.0
        decimator.mix = 0.0
        decimator.decimation = 0
        autoPanMixer.balance = 0
        multiDelay.start()
        fatten.dryWetMix.balance = 1
        reverb.feedback = 0.7

        
        AudioKit.output = reverbMixer
        
        AKSettings.ioBufferDuration = 0 // Optional, set this to decrease latency


        // select input of device
        AKSettings.sampleRate = 44100
        AKSettings.channelCount = 2
        AKSettings.playbackWhileMuted = true
        AKSettings.enableRouteChangeHandling = false
        AKSettings.useBluetooth = false
        AKSettings.defaultToSpeaker = true
        AKSettings.audioInputEnabled = false
//        AKSettings.bufferLength = .longest
        
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
            try! mic?.setDevice(input)
        }

    }
    
    @IBAction func clickPlayMusic(_ sender: Any?) {
        
        self.showAlert(title: "Chọn Beat", message: nil, buttonTitles: self.arrBeat, highlightedButtonIndex: self.curentBeat) { (value) in
            self.curentBeat = value
            //self.arrBeat[value]
            if let mixloop = try? AKAudioFile(readFileName: "\(self.arrBeat[value]).mp4", baseDir: .documents) {
                self.player = AKPlayer(audioFile: mixloop)
                self.player.completionHandler = { Swift.print("completion callback has been triggered!") }
                self.player.isLooping = true
                self.player.buffering = .always
                self.pitchShifter = AKPitchShifter(self.player, shift: 0)
                AudioKit.output = self.pitchShifter
                do {
                    try AudioKit.start()
                } catch {
                    print("AudioKit.start() failed")
                }
                self.player.play()
                self.slider2.minimumValue = 0
                self.slider2.maximumValue = Float(self.player.duration)
                AKSettings.sampleRate = AudioKit.engine.inputNode.inputFormat(forBus: 0).sampleRate
                AKSettings.channelCount = 2
                do {

                    if #available(iOS 10.0, *) {
                        try AKSettings.setSession(category: .playAndRecord , with: [.allowBluetoothA2DP, .defaultToSpeaker, .allowAirPlay ])
                        print("using A2DP")
                    } else {
                        try AKSettings.setSession(category: .playAndRecord, with: [ .mixWithOthers])
                    }

                } catch {

                    print("Could not set session category.")

                }

            }

        }
        
    }
    
    
    func changeSample(node: AKNode?) {
        do {
            try AudioKit.stop()
        } catch {
            print("AudioKit.start() failed")
        }

        AudioKit.output = node

        do {
            try AudioKit.start()
        } catch {
            print("AudioKit.start() failed")
        }
    }



    var micBooster: AKBooster?
    var pitchShifter: AKPitchShifter?
//    AKTimePitch
//    AKPitchShifter?
    var tracker: AKFrequencyTracker!
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
extension Double {
    func round(nearest: Double) -> Double {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }

    func floor(nearest: Double) -> Double {
        let intDiv = Double(Int(self / nearest))
        return intDiv * nearest
    }
}
