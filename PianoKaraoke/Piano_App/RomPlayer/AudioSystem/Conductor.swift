//
//  Conductor
//  ROM Player
//
//  Created by Matthew Fecher on 7/20/17.
//  Copyright © 2017 AudioKit Pro. All rights reserved.

import AudioKit

class Conductor {
    
    // Globally accessible
    static let sharedInstance = Conductor()

    var sequencer: AKAppleSequencer!
    var sampler1 = AKSampler()
    var decimator: AKDecimator
    var tremolo: AKTremolo
    var fatten: Fatten
    var filterSection: FilterSection

    var autoPanMixer: AKDryWetMixer
    var autopan: AutoPan

    var multiDelay: PingPongDelay
    var masterVolume = AKMixer()
    var reverb: AKCostelloReverb
    var reverbMixer: AKDryWetMixer
    let midi = AKMIDI()
    
    var tape: AKAudioFile? = nil
    var recorder: AKNodeRecorder? = nil
    var c: AKPitchShifter?
    init() {
        // MIDI Configure
        midi.createVirtualPorts()
        midi.openInput(name: "Session 1")
        midi.openOutput()
    
        // Session settings
        AKAudioFile.cleanTempDirectory()
        AKSettings.bufferLength = .medium
        AKSettings.enableLogging = true
        
        // Allow audio to play while the iOS device is muted.
//        AKSettings.playbackWhileMuted = true
     
//        do {
//            try AKSettings.setSession(category: .playAndRecord, with: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers])
//        } catch {
//            AKLog("Could not set session category.")
//        }
 
        // Signal Chain
        tremolo = AKTremolo(sampler1, waveform: AKTable(.sine))
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
       
        
        // Set a few sampler parameters
        sampler1.attackDuration = 0
        sampler1.decayDuration = 0
        sampler1.sustainLevel = 1
        sampler1.releaseDuration = 2
        
        // Set Output & Start AudioKit
        AudioKit.output = sampler1
        do {
            try AudioKit.start()
        } catch {
            print("AudioKit.start() failed")
        }        

        do {
            try tape = AKAudioFile.init(writeIn: .documents, name: "HieuMp3", settings: [:])
        } catch {
            print("tape failed")
        }
        do {
            try recorder = AKNodeRecorder(node: AudioKit.output, file: tape)
        } catch {
            print("tape failed")
        }

        // Init sequencer
//        midiLoad("rom_poly")
    }
    
    func addMidiListener(listener: AKMIDIListener) {
        midi.addListener(listener)
    }
    var synthSemitoneOffset = 0

    func playNote(note: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        sampler1.play(noteNumber: offsetNote(note, semitones: synthSemitoneOffset), velocity: velocity)

//        sampler1.play(noteNumber: note, velocity: velocity)
    }

    func stopNote(note: MIDINoteNumber, channel: MIDIChannel) {
        sampler1.stop(noteNumber: offsetNote(note, semitones: synthSemitoneOffset))
//        sampler1.stop(noteNumber: note)
    }

    func useSound(_ sound: String) {
        let soundsFolder = Bundle.main.bundleURL.appendingPathComponent("Sounds").path
        sampler1.unloadAllSamples()
        sampler1.loadSFZ(path: soundsFolder, fileName: sound + ".sfz")
    }
    
    func midiLoad(_ midiFile: String) {
        let path = "Sounds/midi/\(midiFile)"
        sequencer = AKAppleSequencer(filename: path)
        sequencer.enableLooping()
        sequencer.setGlobalMIDIOutput(midi.virtualInput)
        sequencer.setTempo(100)
    }
    
    func sequencerToggle(_ value: Double) {
        allNotesOff()
        
        if value == 1 {
            sequencer.play()
        } else {
            sequencer.stop()
        }
    }
    
    func allNotesOff() {
        for note in 0 ... 127 {
            sampler1.stop(noteNumber: MIDINoteNumber(note))
        }
    }
    
    func changeSample(isDefault: Bool) {
        do {
            try AudioKit.stop()
        } catch {
            print("AudioKit.start() failed")
        }

        if isDefault {
            AudioKit.output = sampler1
        } else {
            AudioKit.output = reverbMixer
        }
        do {
            try AudioKit.start()
        } catch {
            print("AudioKit.start() failed")
        }
    }
}
