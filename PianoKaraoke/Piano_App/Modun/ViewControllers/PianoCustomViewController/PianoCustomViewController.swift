//
//  PianoCustomViewController.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import ReplayKit
import AVKit
import AudioKit
import AudioKitUI

class PianoCustomViewController: UIViewController, RPPreviewViewControllerDelegate {
    private let screenRecorder2 = ScreenRecorder2()
    let conductor = Conductor.sharedInstance
    let defaultOctave = 60
    var currentSound = 1
    let arrSoundName: [String] = [ "Brass", "LoTine81z", "Metalimba", "Pluck Bass" ]
    var tone: Tone = .Do

    @IBOutlet weak var key1: PianoKeyboard!
    @IBOutlet weak var key2: PianoKeyboard!
    @IBOutlet weak var key3: PianoKeyboard!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var videoView: CustomAVPlayer!
    @IBOutlet weak var displayContainer: UIView!
    @IBOutlet weak var nameToneLbl: UILabel!
    @IBOutlet weak var btnRecord: UIButton!
    
    private var linkMp4: String?
    private var nameSong: String?
    private var typeCellInitViewController: TypeCell?
    
    //MARK: Method
    func config(link: String?, nameSong: String?, typeCellInitViewController: TypeCell?) {
        self.linkMp4 = link
        self.nameSong = nameSong
        self.typeCellInitViewController = typeCellInitViewController
    }
    
    private func playvideo(localOrOnline: TypeCell ,link: String) {
        switch localOrOnline {
        case .CellLocal, .CellYoutube:
            videoView.config(localURL: link)
        case .CellOnline:
            videoView.configure(videoURLString: link, backgroundImage: nil)
        }
    }
    func resetToneKeyboard() {
        setUpTone(key: key1, quang: 1)
        setUpTone(key: key2, quang: 2)
        setUpTone(key: key3, quang: 3)
        nameToneLbl.text = tone.getKeyName(quang: "")
    }
    
    func setUpTone(key: PianoKeyboard, quang: Int) {
        var extra = 0
        if tone != .Do, tone != .DoThang {
            extra = 12
        }
        key.octave = tone.rawValue + 12*quang - extra
        for i in tone.arrTone {
            key.setLabel(for: key.octave + (i.rawValue -  tone.rawValue), text: i.getName(quang: "\(quang)"))
        }
    }
    
    func record() {
        if conductor.recorder?.isRecording ?? false {
            conductor.recorder?.stop()
            btnRecord.setTitle("Stop Record", for: .normal)
            ASVideoPlayerController.sharedVideoPlayer.pauseForceCurrent()
            let vc = EditRecordViewController()
            self.present(vc, animated: true, completion: nil)

        } else {
            do {
                try conductor.recorder?.record()
                btnRecord.setTitle("Recording", for: .normal)
            } catch {
                AKLog("Couldn't record")
            }
        }
    }
    
    //MARK: Action
    @IBAction func clickStop(_ sender: Any) {
        self.currentSound += 1
        self.currentSound %= 4
        self.conductor.useSound("TX " + self.arrSoundName[currentSound])
    }
    
    @IBAction func clickGhi(_ sender: Any) {
    
    }
    
    @IBAction func clickSetting(_ sender: Any) {
        let vc = SettingPianoViewController()
        vc.config(tone: tone, currentSound: currentSound)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        displayContainer.removeFromSuperview()
        LocalVideoManager.shared.removeFileLocal(name: LocalVideoManager.shared.VideoYoutube)
        ASVideoPlayerController.sharedVideoPlayer.pauseForceCurrent()
        self.dismiss()
    }
    
    
    @IBAction func clickUpTone(_ sender: Any?) {
        tone = tone.editTone(control: .Up)
        resetToneKeyboard()
    }
    
    @IBAction func clickDownTone(_ sender: Any?) {
        tone = tone.editTone(control: .Down)
        resetToneKeyboard()
    }
        
    @IBAction func clickRecord2(sender: Any?) {
        record()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = nameSong
        playvideo(localOrOnline: typeCellInitViewController ?? TypeCell.CellLocal, link: linkMp4 ?? "")
        self.view.backgroundColor = UIColor.init(hexString: AppColor.shared.colorBackGround.value)
        key1.delegate = self
        resetToneKeyboard()
        key2.delegate = self
        key3.delegate = self
        
        conductor.midi.addListener(self)
        self.conductor.useSound("TX " + arrSoundName[currentSound])
        videoView.delegate = self
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension PianoCustomViewController: PianoKeyboardDelegate {
    
    func pianoKeyUp(_ keyNumber: Int, view: PianoKeyboard) {
        DispatchQueue.main.async {
            let i = view.octave + keyNumber + 12
            self.conductor.stopNote(note: MIDINoteNumber(i), channel: 0)
        }
    }
    
    func pianoKeyDown(_ keyNumber: Int, view: PianoKeyboard) {
        DispatchQueue.main.async {
            let i = view.octave + keyNumber + 12
            self.conductor.playNote(note: MIDINoteNumber(i), velocity: 100, channel: 0)
        }
    }
    
}

extension PianoCustomViewController: AKMIDIListener {
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        DispatchQueue.main.async {
            self.conductor.playNote(note: noteNumber, velocity: velocity, channel: channel)
        }
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        DispatchQueue.main.async {
            self.conductor.stopNote(note: noteNumber, channel: channel)
        }
    }
    
    // MIDI Controller input
    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel) {
        AKLog("Channel: \(channel + 1) controller: \(controller) value: \(value)")
//        conductor.controller(controller, value: value)
    }
    
    // MIDI Pitch Wheel
    func receivedMIDIPitchWheel(_ pitchWheelValue: MIDIWord, channel: MIDIChannel) {
//        conductor.pitchBend(pitchWheelValue)
    }
    
    // After touch
    func receivedMIDIAfterTouch(_ pressure: MIDIByte, channel: MIDIChannel) {
//        conductor.afterTouch(pressure)
    }
    
    func receivedMIDISystemCommand(_ data: [MIDIByte]) {
        // do nothing: silence superclass's log chatter
    }
    
    // MIDI Setup Change
    func receivedMIDISetupChange() {
        AKLog("midi setup change, midi.inputNames: \(conductor.midi.inputNames)")
        let inputNames = conductor.midi.inputNames
        inputNames.forEach { inputName in
            conductor.midi.openInput(name: inputName)
        }
    }
    
}

extension PianoCustomViewController: SettingPianoDelegate {
    func done(tone: Tone, currentSound: Int) {
        self.tone = tone
        self.currentSound = currentSound
        resetToneKeyboard()
        self.conductor.useSound("TX " + arrSoundName[currentSound])
    }
}

extension PianoCustomViewController: CustomAVPlayerDelegate {
    func customAVPlayerDidTap(view: CustomAVPlayer) {
        
    }
    
    func customAVPlayerPlayButtonTapped(isPlaying: Bool) {
        
    }
    
    func finishedPlayingVideo() {
        let vc = EditRecordViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
