//
//  ScreenRecorder.swift
//
//  Created by Giridhar on 09/06/17.
//  Copyright © 2017 Giridhar. All rights reserved.
//
//  ScreenRecordingWithAudio
//
//  Modified by Ajay Saini on 14/05/19.
//  Copyright © 2019 Ajay Saini. All rights reserved.
//
import Foundation
import ReplayKit
import AVKit


public class ScreenRecorder
{
    public enum recordingQuality : CGFloat {
        
        case lowest = 0.3
        case low = 0.5
        case normal = 0.8
        case good = 1.0
        case better = 1.3
        case high = 1.5
        case best = 2.0
    }
    
    public var recordingQua : recordingQuality = .normal
    var assetWriter:AVAssetWriter?
//    var videoInput:AVAssetWriterInput?
    var audioInput:AVAssetWriterInput?
    
    var recordCompleted:((Error?) ->Void)?
    
    public var onRecordingError: (() -> Void)?
    
    public init(){}
    
    //MARK: Screen Recording
    func startRecording(recordingHandler:@escaping (Error?)-> Void)
    {
        if #available(iOS 11.0, *)
        {
            ReplayFileUtil.deleteFile()
            RPScreenRecorder.shared().isMicrophoneEnabled = true
            
            let fileURL = ReplayFileUtil.filePath()
            assetWriter = try! AVAssetWriter(outputURL: fileURL, fileType:
                AVFileType.mov)
            let audioSettings = [
                AVFormatIDKey : kAudioFormatFLAC,
                AVNumberOfChannelsKey : 1,
                AVSampleRateKey : 12000,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue

                ] as [String : Any]
            
//            let videoSettings = [
//                AVVideoCodecKey : AVVideoCodecType.h264,
//                AVVideoWidthKey : UIScreen.main.bounds.size.width * recordingQua.rawValue,
//                AVVideoHeightKey : UIScreen.main.bounds.size.height * recordingQua.rawValue
//                ] as [String : Any]
//            videoInput  = AVAssetWriterInput (mediaType: AVMediaType.video, outputSettings: videoSettings)
            
//            videoInput?.expectsMediaDataInRealTime = true
            
            audioInput = AVAssetWriterInput (mediaType: AVMediaType.audio, outputSettings: audioSettings)
            
            audioInput?.expectsMediaDataInRealTime = true
            
            
            if let _audioInput = audioInput {
                if assetWriter?.canAdd(_audioInput) ?? false {
                    assetWriter?.add(_audioInput)
                }
            }
//            if let _videoInput = videoInput {
//                if assetWriter?.canAdd(_videoInput) ?? false {
//                    assetWriter?.add(_videoInput)
//                }
//            }

            RPScreenRecorder.shared().startCapture(handler: { (sample, bufferType, error) in
                print("bufferType.rawValue \(bufferType.rawValue)")
                
                recordingHandler(error)
                
                DispatchQueue.main.async { [weak self] in
                    if CMSampleBufferDataIsReady(sample)
                    {
                        if self?.assetWriter?.status == .unknown
                        {
                            self?.assetWriter?.startWriting()
                            self?.assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sample))
                        }
                        
                        if self?.assetWriter?.status == .failed {
                            print("Error occured, status = \(String(describing: self?.assetWriter?.status.rawValue)), \(String(describing: self?.assetWriter?.error!.localizedDescription)) \(String(describing: self?.assetWriter?.error))")
                            
                            
                            self?.stopRecording { (error) in
                                self?.recordCompleted?(error)
                                self?.onRecordingError?()
                            }
                            
                            
                            return
                        }
//                        if (bufferType == .video)
//                        {
//                            if self?.videoInput?.isReadyForMoreMediaData ?? false
//                            {
//                                self?.videoInput?.append(sample)
//                                print("video")
//                            }
//                        }
                        if (bufferType == .audioApp){
                            if self?.audioInput?.isReadyForMoreMediaData ?? false
                            {
                                self?.audioInput?.append(sample)
                                print("audio")
                            }
                        }
                        
                    }
                }
                
            }) { (error) in
                recordingHandler(error)
                //                debugPrint(error)
            }
        } else
        {
            // Fallback on earlier versions
        }
    }
    
    func stopRecording(handler: @escaping (Error?) -> Void)
    {
        if #available(iOS 11.0, *)
        {
            RPScreenRecorder.shared().stopCapture
                {    (error) in
                    handler(error)
//                    self.videoInput?.markAsFinished()
                    self.audioInput?.markAsFinished()
                    self.assetWriter?.finishWriting
                        {
//                            self.videoInput = nil
                            self.audioInput = nil
                            self.assetWriter = nil

                    }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
}



//
//  ScreenRecorder.swift
//  Wyler
//
//  Created by Cesar Vargas on 10.04.20.
//  Copyright © 2020 Cesar Vargas. All rights reserved.
//

import Foundation
import ReplayKit
import Photos

final public class ScreenRecorder2 {
  private var videoOutputURL: URL?
  private var videoWriter: AVAssetWriter?
  private var videoWriterInput: AVAssetWriterInput?
  private var saveToCameraRoll = false

  public init() {}

  /**
   Starts recording the content of the application screen. It works together with stopRecording

  - Parameter outputURL: The output where the video will be saved. If nil, it saves it in the documents directory.
  - Parameter size: The size of the video. If nil, it will use the app screen size.
  - Parameter saveToCameraRoll: Whether to save it to camera roll. False by default.
  - Parameter errorHandler: Called when an error is found
  */
  public func startRecording(to outputURL: URL? = nil,
                             size: CGSize? = nil,
                             saveToCameraRoll: Bool = false,
                             errorHandler: @escaping (Error) -> Void) {
    if saveToCameraRoll {
      checkPhotoLibraryAuthorizationStatus()
    }

    createVideoWriter(in: outputURL, error: errorHandler)
    addVideoWriterInput(size: size)
    startCapture(error: errorHandler)
  }

  private func checkPhotoLibraryAuthorizationStatus() {
    let status = PHPhotoLibrary.authorizationStatus()
    if status == .notDetermined {
      PHPhotoLibrary.requestAuthorization({ _ in })
    }
  }

  private func createVideoWriter(in outputURL: URL? = nil, error: (Error) -> Void) {
    let newVideoOutputURL: URL

    if let passedVideoOutput = outputURL {
      self.videoOutputURL = passedVideoOutput
      newVideoOutputURL = passedVideoOutput
    } else {
      let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
      newVideoOutputURL = URL(fileURLWithPath: documentsPath.appendingPathComponent("WylerNewVideo.mp4"))
      self.videoOutputURL = newVideoOutputURL
    }

    do {
      try FileManager.default.removeItem(at: newVideoOutputURL)
    } catch {}

    do {
        try videoWriter = AVAssetWriter(outputURL: newVideoOutputURL, fileType: AVFileType.mov)
    } catch let writerError as NSError {
      error(writerError)
      videoWriter = nil
      return
    }
  }

  private func addVideoWriterInput(size: CGSize?) {
    let passingSize: CGSize

    if let passedSize = size {
      passingSize = passedSize
    } else {
      passingSize = UIScreen.main.bounds.size
    }

    if #available(iOS 11.0, *) {
        let videoSettings = [
            AVFormatIDKey : kAudioFormatFLAC,
            AVNumberOfChannelsKey : 1,
            AVSampleRateKey : 12000,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue

            ] as [String : Any]
//        let videoSettings: [String: Any] = [AVVideoCodecKey: AVVideoCodecType.h264,
//                                            AVVideoWidthKey: passingSize.width,
//                                            AVVideoHeightKey: passingSize.height]
        let newVideoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: videoSettings)
        self.videoWriterInput = newVideoWriterInput
        videoWriter?.add(newVideoWriterInput)

    } else {
        // Fallback on earlier versions
    }

  }

  private func startCapture(error: @escaping (Error) -> Void) {
    if #available(iOS 11.0, *) {
        RPScreenRecorder.shared().startCapture(handler: { (sampleBuffer, sampleType, passedError) in
            if let passedError = passedError {
                error(passedError)
                return
            }
            
            switch sampleType {
            case .video:
                break
            case .audioApp:
                self.handleSampleBuffer(sampleBuffer: sampleBuffer)
            default:
                break
            }
        })
    } else {
        // Fallback on earlier versions
    }
  }
    

  private func handleSampleBuffer(sampleBuffer: CMSampleBuffer) {
    if self.videoWriter?.status == AVAssetWriter.Status.unknown {
      self.videoWriter?.startWriting()
      self.videoWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
    } else if self.videoWriter?.status == AVAssetWriter.Status.writing &&
      self.videoWriterInput?.isReadyForMoreMediaData == true {
      self.videoWriterInput?.append(sampleBuffer)
    }
  }
    

  /**
   Stops recording the content of the application screen, after calling startRecording

  - Parameter errorHandler: Called when an error is found
  */
  public func stoprecording(errorHandler: @escaping (Error) -> Void, completionHandler handler: @escaping () -> Void) {
    if #available(iOS 11.0, *) {
        RPScreenRecorder.shared().stopCapture( handler: { error in
            if let error = error {
                errorHandler(error)
            }
        })
    } else {
        // Fallback on earlier versions
    }

    self.videoWriterInput?.markAsFinished()
    self.videoWriter?.finishWriting {
        handler()
      self.saveVideoToCameraRoll(errorHandler: errorHandler)
    }
  }

  private func saveVideoToCameraRoll(errorHandler: @escaping (Error) -> Void) {
    guard let videoOutputURL = self.videoOutputURL else {
      return
    }

    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoOutputURL)
    }, completionHandler: { _, error in
      if let error = error {
        errorHandler(error)
      }
    })
  }
}
