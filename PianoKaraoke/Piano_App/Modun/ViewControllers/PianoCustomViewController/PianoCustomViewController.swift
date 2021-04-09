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
import YoutubeKit

class PianoCustomViewController: UIViewController, RPPreviewViewControllerDelegate, RPScreenRecorderDelegate {

    private let screenRecorder2 = ScreenRecorder2()
    let recorder = ScreenRecordCoordinator()
    
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
    @IBOutlet weak var noteIsPlayingLbl: UILabel!

    var youtubeModel: SearchResult?
    var detailSongModel: DetailInfoSong?

    @IBOutlet weak var btnRecord: UIButton! {
        didSet {
            btnRecord.setImage(UIImage(named: "icons8-microphone-100")?.maskWithColor(color: .white), for: .normal)
        }
    }
    @IBOutlet weak var btnToneChange: UIButton! {
        didSet {
            btnToneChange.setImage(UIImage(named: "icons8-music-notation-100")?.maskWithColor(color: .white), for: .normal)
        }
    }
    @IBOutlet weak var btnSettingFilter: UIButton! {
        didSet {
            btnSettingFilter.setImage(UIImage(named: "icons8-adjust-100")?.maskWithColor(color: .white), for: .normal)
        }
    }

    @IBOutlet weak var viewTone: UIView!
    
    private var linkMp4: String?
    private var nameSong: String?
    private var typeCellInitViewController: TypeCell?
    
    var isRecord: Bool = false
    func startRecording() {
        self.isRecord = true
        self.btnRecord.setImage(UIImage(named: "icons8-microphone-100")?.maskWithColor(color: .red), for: .normal)
        screenRecorder2.startRecording { _ in
        }
    }
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
    }

    func stopRecording() {
        self.isRecord = false
        self.btnRecord.setImage(UIImage(named: "icons8-microphone-100")?.maskWithColor(color: .white), for: .normal)
        screenRecorder2.stoprecording(errorHandler: { _ in
            
        }) {
            DispatchQueue.main.async {
                let vc = EditRecordViewController()
                vc.detailSongModel = self.detailSongModel
                vc.youtubeModel = self.youtubeModel
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
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
    
    
    //MARK: Action
    
    @IBAction func clickShowMenu(_ sender: Any) {
        viewMenuRound.isHidden = false
        btnHiddenMenu.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.viewMenuRound.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { _ in
            
        }
        
    }
    
    @IBOutlet weak var btnHiddenMenu: UIButton!
    
    @IBAction func clickHidenMenu(_ sender: Any) {
        btnHiddenMenu.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.viewMenuRound.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { _ in
            self.viewMenuRound.isHidden = true
        }
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
    
    
    @IBAction func clickTone(sender: Any?) {
        btnHiddenMenu.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.viewMenuRound.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { _ in
            self.viewMenuRound.isHidden = true
            PopupIGViewController.showAlert(viewController: self, title: "Chọn Tone", dataSource: self.tone.arrTone.map({ "\t\($0.getName(quang: ""))"}), hightLight: "\t\(self.tone.getName(quang: ""))", attributes: [NSAttributedString.Key.font : UIFont.HelveticaNeue16, NSAttributedString.Key.foregroundColor : UIColor.defaultText]) { (value, index) in
                self.tone = self.tone.arrTone[index]
                self.resetToneKeyboard()
            }
        }
    }
    
    @IBAction func clickRecord(sender: Any?) {
        btnHiddenMenu.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.viewMenuRound.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { _ in
            if self.isRecord {
                self.stopRecording()
            } else {
                self.startRecording()
            }
            self.viewMenuRound.isHidden = true
        }
    }
    
    @IBAction func clickGotoSetting(sender: Any?) {
        btnHiddenMenu.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.viewMenuRound.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { _ in
            self.viewMenuRound.isHidden = true
            let vc = SettingPianoViewController()
            vc.config(tone: self.tone, currentSound: self.currentSound)
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var viewMenuRound: ViewRound!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMenuRound.isHidden = true
//        titleLbl.text = nameSong
                titleLbl.text = ""
        //        if nameSong == ""
        self.viewMenuRound.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
//        viewTone.isHidden = nameSong != ""
        viewTone.isHidden = false
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
    
    func pianoKeyUp(_ keyNumber: Int, view: PianoKeyboard, labelNote: String) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: {
                self.noteIsPlayingLbl.alpha = 0
                self.noteIsPlayingLbl.transform = CGAffineTransform(scaleX: 1.1, y: 1.1).translatedBy(x: CGFloat.random(in: -10.0...10.0), y: CGFloat.random(in: -10.0...10.0))
            }, completion: nil)
//            self.noteIsPlayingLbl.text = ""
            let i = view.octave + keyNumber + 12
            self.conductor.stopNote(note: MIDINoteNumber(i), channel: 0)
        }
    }
    
    func pianoKeyDown(_ keyNumber: Int, view: PianoKeyboard, labelNote: String) {
        DispatchQueue.main.async {
            

            let i = view.octave + keyNumber + 12
            self.conductor.playNote(note: MIDINoteNumber(i), velocity: 100, channel: 0)
            self.noteIsPlayingLbl.transform = .identity
            self.noteIsPlayingLbl.alpha = 1
            switch view {
            case self.key1:
                self.noteIsPlayingLbl.text = labelNote
//                SRFacebookAnimation.animate(str: labelNote)
            case self.key2:
                self.noteIsPlayingLbl.text = labelNote + "2"
//                SRFacebookAnimation.animate(str: labelNote + "2")

            case self.key3:
                self.noteIsPlayingLbl.text = labelNote + "3"
//                SRFacebookAnimation.animate(str: labelNote + "3")

            default: break

            }
//            SRFacebookAnimation.startPoint(CGPoint(x: 0,
//                                                   y: 120))
//            SRFacebookAnimation.isUptrust(false)
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
