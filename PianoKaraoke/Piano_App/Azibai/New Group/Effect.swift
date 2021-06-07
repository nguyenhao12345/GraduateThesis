//
//  Effect.swift
//  SongProcessor
//
//  Created by Yaron Karasik on 5/20/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation
import AudioKit

typealias EffectValue = (type: ValueType, value: Double, min: Double, max: Double)
import Foundation
import UIKit

private extension Selector {
    static let buttonTapped = #selector(DatePickerDialog.buttonTapped)
    static let deviceOrientationDidChange = #selector(DatePickerDialog.deviceOrientationDidChange)
}

open class DatePickerDialog: UIView {
    public typealias DatePickerCallback = ( Date? ) -> Void

    // MARK: - Constants
    private let kDefaultButtonHeight: CGFloat = 50
    private let kDefaultButtonSpacerHeight: CGFloat = 1
    private let kCornerRadius: CGFloat = 7
    private let kDoneButtonTag: Int     = 1

    // MARK: - Views
    private var dialogView: UIView!
    private var titleLabel: UILabel!
    open var datePicker: UIDatePicker!
    private var cancelButton: UIButton!
    private var doneButton: UIButton!

    // MARK: - Variables
    private var defaultDate: Date?
    private var datePickerMode: UIDatePicker.Mode?
    private var callback: DatePickerCallback?
    var showCancelButton: Bool = false
    var locale: Locale?

    private var textColor: UIColor!
    private var buttonColor: UIColor!
    private var font: UIFont!

    // MARK: - Dialog initialization
    public init(textColor: UIColor = UIColor.black,
                buttonColor: UIColor = UIColor.blue,
                font: UIFont = .boldSystemFont(ofSize: 15),
                locale: Locale? = nil,
                showCancelButton: Bool = true) {
        let size = UIScreen.main.bounds.size
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.textColor = textColor
        self.buttonColor = buttonColor
        self.font = font
        self.showCancelButton = showCancelButton
        self.locale = locale
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        self.dialogView = createContainerView()

        self.dialogView!.layer.shouldRasterize = true
        self.dialogView!.layer.rasterizationScale = UIScreen.main.scale

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

        self.dialogView!.layer.opacity = 0.5
        self.dialogView!.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)

        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        self.addSubview(self.dialogView!)
    }

    /// Handle device orientation changes
    @objc func deviceOrientationDidChange(_ notification: Notification) {
        self.frame = UIScreen.main.bounds
        let dialogSize = CGSize(width: 300, height: 230 + kDefaultButtonHeight + kDefaultButtonSpacerHeight)
        dialogView.frame = CGRect(x: (UIScreen.main.bounds.size.width - dialogSize.width) / 2,
                                  y: (UIScreen.main.bounds.size.height - dialogSize.height) / 2,
                                  width: dialogSize.width,
                                  height: dialogSize.height)
    }

    /// Create the dialog view, and animate opening the dialog
    open func show(_ title: String,
                   doneButtonTitle: String = "Done",
                   cancelButtonTitle: String = "Cancel",
                   defaultDate: Date = Date(),
                   minimumDate: Date? = nil, maximumDate: Date? = nil,
                   datePickerMode: UIDatePicker.Mode = .dateAndTime,
                   callback: @escaping DatePickerCallback) {
        self.titleLabel.text = title
        self.doneButton.setTitle(doneButtonTitle, for: .normal)
        if showCancelButton {
            self.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        }
        self.datePickerMode = datePickerMode
        self.callback = callback
        self.defaultDate = defaultDate
        self.datePicker.datePickerMode = self.datePickerMode ?? UIDatePicker.Mode.date
        self.datePicker.date = self.defaultDate ?? Date()
        self.datePicker.maximumDate = maximumDate
        self.datePicker.minimumDate = minimumDate
        if let locale = self.locale {
            self.datePicker.locale = locale
        }
        /* Add dialog to main window */
        guard let appDelegate = UIApplication.shared.delegate else { fatalError() }
        guard let window = appDelegate.window else { fatalError() }
        window?.addSubview(self)
        window?.bringSubviewToFront(self)
        window?.endEditing(true)

        NotificationCenter.default.addObserver(self,
                                               selector: .deviceOrientationDidChange,
                                               name: UIDevice.orientationDidChangeNotification, object: nil)

        /* Anim */
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                self.dialogView!.layer.opacity = 1
                self.dialogView!.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
        )
    }

    /// Dialog close animation then cleaning and removing the view from the parent
    private func close() {
        let currentTransform = self.dialogView.layer.transform

        let startRotation = (self.value(forKeyPath: "layer.transform.rotation.z") as? NSNumber) as? Double ?? 0.0
        let rotation = CATransform3DMakeRotation((CGFloat)(-startRotation + .pi * 270 / 180), 0, 0, 0)

        self.dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1))
        self.dialogView.layer.opacity = 1

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [],
            animations: {
                self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                let transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
                self.dialogView.layer.transform = transform
                self.dialogView.layer.opacity = 0
        }) { (_) in
            for v in self.subviews {
                v.removeFromSuperview()
            }

            self.removeFromSuperview()
            self.setupView()
        }
    }

    /// Creates the container view here: create the dialog, then add the custom content and buttons
    private func createContainerView() -> UIView {
        let screenSize = UIScreen.main.bounds.size
        let dialogSize = CGSize(width: 300, height: 230 + kDefaultButtonHeight + kDefaultButtonSpacerHeight)

        // For the black background
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)

        // This is the dialog's container; we attach the custom content and the buttons to this one
        let container = UIView(frame: CGRect(x: (screenSize.width - dialogSize.width) / 2,
                                                   y: (screenSize.height - dialogSize.height) / 2,
                                                   width: dialogSize.width,
                                                   height: dialogSize.height))

        // First, we style the dialog to match the iOS8 UIAlertView >>>
        let gradient: CAGradientLayer = CAGradientLayer(layer: self.layer)
        gradient.frame = container.bounds
        gradient.colors = [UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor,
                           UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor,
                           UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor]

        let cornerRadius = kCornerRadius
        gradient.cornerRadius = cornerRadius
        container.layer.insertSublayer(gradient, at: 0)

        container.layer.cornerRadius = cornerRadius
        container.layer.borderColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        container.layer.borderWidth = 1
        container.layer.shadowRadius = cornerRadius + 5
        container.layer.shadowOpacity = 0.1
        container.layer.shadowOffset = CGSize(width: 0 - (cornerRadius + 5) / 2, height: 0 - (cornerRadius + 5) / 2)
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowPath = UIBezierPath(roundedRect: container.bounds,
                                                        cornerRadius: container.layer.cornerRadius).cgPath

        // There is a line above the button
        let yPosition = container.bounds.size.height - kDefaultButtonHeight - kDefaultButtonSpacerHeight
        let lineView = UIView(frame: CGRect(x: 0,
                                            y: yPosition,
                                            width: container.bounds.size.width,
                                            height: kDefaultButtonSpacerHeight))
        lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
        container.addSubview(lineView)

        //Title
        self.titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 280, height: 30))
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = self.textColor
        self.titleLabel.font = self.font.withSize(17)
        container.addSubview(self.titleLabel)

        self.datePicker = configuredDatePicker()
        container.addSubview(self.datePicker)

        // Add the buttons
        addButtonsToView(container: container)

        return container
    }

    fileprivate func configuredDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 30, width: 0, height: 0))
        datePicker.setValue(self.textColor, forKeyPath: "textColor")
        datePicker.autoresizingMask = .flexibleRightMargin
        datePicker.frame.size.width = 300
        datePicker.frame.size.height = 216
        return datePicker
    }

    /// Add buttons to container
    private func addButtonsToView(container: UIView) {
        var buttonWidth = container.bounds.size.width / 2

        var leftButtonFrame = CGRect(
            x: 0,
            y: container.bounds.size.height - kDefaultButtonHeight,
            width: buttonWidth,
            height: kDefaultButtonHeight
        )
        var rightButtonFrame = CGRect(
            x: buttonWidth,
            y: container.bounds.size.height - kDefaultButtonHeight,
            width: buttonWidth,
            height: kDefaultButtonHeight
        )
        if showCancelButton == false {
            buttonWidth = container.bounds.size.width
            leftButtonFrame = CGRect()
            rightButtonFrame = CGRect(
                x: 0,
                y: container.bounds.size.height - kDefaultButtonHeight,
                width: buttonWidth,
                height: kDefaultButtonHeight
            )
        }
        let interfaceLayoutDirection = UIApplication.shared.userInterfaceLayoutDirection
        let isLeftToRightDirection = interfaceLayoutDirection == .leftToRight

        if showCancelButton {
            self.cancelButton = UIButton(type: .custom) as UIButton
            self.cancelButton.frame = isLeftToRightDirection ? leftButtonFrame : rightButtonFrame
            self.cancelButton.setTitleColor(self.buttonColor, for: .normal)
            self.cancelButton.setTitleColor(self.buttonColor, for: .highlighted)
            self.cancelButton.titleLabel!.font = self.font.withSize(14)
            self.cancelButton.layer.cornerRadius = kCornerRadius
            self.cancelButton.addTarget(self, action: .buttonTapped, for: .touchUpInside)
            container.addSubview(self.cancelButton)
        }
        self.doneButton = UIButton(type: .custom) as UIButton
        self.doneButton.frame = isLeftToRightDirection ? rightButtonFrame : leftButtonFrame
        self.doneButton.tag = kDoneButtonTag
        self.doneButton.setTitleColor(self.buttonColor, for: .normal)
        self.doneButton.setTitleColor(self.buttonColor, for: .highlighted)
        self.doneButton.titleLabel!.font = self.font.withSize(14)
        self.doneButton.layer.cornerRadius = kCornerRadius
        self.doneButton.addTarget(self, action: .buttonTapped, for: .touchUpInside)
        container.addSubview(self.doneButton)
    }

    @objc func buttonTapped(sender: UIButton!) {
        if sender.tag == kDoneButtonTag {
            self.callback?(self.datePicker.date)
        } else {
            self.callback?(nil)
        }

        close()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

enum EffectType: Int {
    case delay = 0
    case moogLadder
    case reverb
    case pitchShifter
    case bitCrusher
    
    static var count: Int { return EffectType.bitCrusher.rawValue + 1}
    
    var name: String {
        switch self {
        case .delay: return "Delay"
        case .moogLadder: return "Moog Ladder"
        case .reverb: return "Reverb"
        case .pitchShifter: return "Pitch Shifter"
        case .bitCrusher: return "Bit Crusher"
        }
    }
    
    var values: [EffectValue] {
        switch self {
        case .delay: return [(.time, 1.0, 0.0, 10.0), (.feedback, 0.5, 0, 1), (.lowPassCutoff, 15000, 0.0, 30000), (.dryWetMix, 0.5, 0.0, 1.0)]
        case .pitchShifter: return [(.shift, AKPitchShifter.defaultShift, AKPitchShifter.shiftRange.lowerBound, AKPitchShifter.shiftRange.upperBound), (.windowSize, AKPitchShifter.defaultWindowSize, AKPitchShifter.windowSizeRange.lowerBound, AKPitchShifter.windowSizeRange.upperBound), (.crossFade, AKPitchShifter.defaultCrossfade, AKPitchShifter.crossfadeRange.lowerBound, AKPitchShifter.crossfadeRange.upperBound)]
        case .moogLadder: return [(.resonance, AKMoogLadder.defaultResonance, AKMoogLadder.resonanceRange.lowerBound, AKMoogLadder.resonanceRange.upperBound), (.cutOffFrequency, AKMoogLadder.defaultCutoffFrequency, AKMoogLadder.cutoffFrequencyRange.lowerBound, AKMoogLadder.cutoffFrequencyRange.upperBound)]
        case .bitCrusher: return [(.bitDepth, AKBitCrusher.defaultBitDepth, AKBitCrusher.bitDepthRange.lowerBound, AKBitCrusher.bitDepthRange.upperBound), (.sampleRate, AKBitCrusher.defaultSampleRate, AKBitCrusher.sampleRateRange.lowerBound, AKBitCrusher.sampleRateRange.upperBound)]
        default: return [EffectValue]()
        }
    }
}

enum ValueType: Int {
    case time = 0
    case feedback
    case lowPassCutoff
    case dryWetMix
    case rampTime
    case shift
    case windowSize
    case crossFade
    case cutOffFrequency
    case resonance
    case sampleRate
    case bitDepth
    
    var name: String {
        switch self {
        case .time: return "Time"
        case .feedback: return "Feedback"
        case .lowPassCutoff: return "Low Pass Cutoff"
        case .dryWetMix: return "Dry Wet Mix"
        case .rampTime: return "Ramp Time"
        case .shift: return "Shift"
        case .windowSize: return "Window Size"
        case .crossFade: return "Cross Fade"
        case .cutOffFrequency: return "Cutoff Frequency"
        case .resonance: return "Resonance"
        case .sampleRate: return "Sample Rate"
        case .bitDepth: return "Bit Depth"
        }
    }
}

class Effect {
    let effectType: EffectType
    let node: AKInput
    var values = [EffectValue]()
    
    init(effectType anEffectType: EffectType) {
        effectType = anEffectType
        node = Effect.nodeForEffectType(effectType)
        values = effectType.values
    }
    
    class func nodeForEffectType(_ effectType: EffectType) -> AKInput {
        switch effectType {
        case .delay: return AKDelay()
        case .moogLadder: return AKMoogLadder()
        case .reverb: return AKReverb()
        case .pitchShifter: return AKPitchShifter()
        case .bitCrusher: return AKBitCrusher()
        }        
    }
    
    func updateValue(valueType: ValueType, value: Double) {
        values.enumerated().forEach { (index, effectValue) in
            if effectValue.type == valueType {
                values[index].value = value
            }
        }
        
        switch (effectType) {
        case .delay:
            guard let delay = node as? AKDelay else { break }
            switch valueType {
            case .time: delay.time = value
            case .feedback: delay.feedback = value
            case .lowPassCutoff: delay.lowPassCutoff = value
            case .dryWetMix: delay.dryWetMix = value
            default: break
            }
        case .pitchShifter:
            guard let pitchShifter = node as? AKPitchShifter else { break }
            switch valueType {
            case .shift: pitchShifter.shift = value
            case .crossFade: pitchShifter.crossfade = value
            case .windowSize: pitchShifter.windowSize = value
            default: break
            }
        case .moogLadder:
            guard let moogLadder = node as? AKMoogLadder else { break }
            switch valueType {
            case .resonance: moogLadder.resonance = value
            case .cutOffFrequency: moogLadder.cutoffFrequency = value
            default: break
            }
        case .bitCrusher:
            guard let bitCrusher = node as? AKBitCrusher else { break }
            switch valueType {
            case .bitDepth: bitCrusher.bitDepth = value
            case .sampleRate: bitCrusher.sampleRate = value
            default: break
            }
        default: break
        }
    }
}


import Alamofire
import SwiftyJSON

public enum APIError: Error {
    case message(String)

    var localizedDescription: String {
        switch self {
        case .message(let string):
            return string
        }
    }

}

public extension Error {

    var message: String {
        if self is AFError {
            return "Unknown error"
        } else if let error = self as? APIError {
            return error.localizedDescription
        } else {
            return self.localizedDescription
        }
    }
}

public extension DataRequest {
    func customValidate() -> Self {
        return validate { (request, response, data) -> Request.ValidationResult in
//            if !AppDelegate.shared.isInternetAvailable {
//                return .failure(APIError.message("Không có kết nối mạng!"))
//            }
            let defaultError = "Có lỗi xảy ra. Vui lòng thử lại!"
            if let _data = data {
//                let str = String(decoding: _data, as: UTF8.self)
                let _json = JSON(_data)
                if _json != JSON.null {
                    let _success = _json["status"].intValue == 1
                    if !_success {
                        if let _errorMessage = _json["msg"].string {
                            if _errorMessage.lowercased() == "invalid token" || response.statusCode == 401 {
                                return .failure(APIError.message("Phiên làm việc của bạn đã hết hạn. Vui lòng đăng nhập lại!"))
                            }
                            else {
                                return .failure(APIError.message(_errorMessage))
                            }
                        }
                        else {
                            return .failure(APIError.message(defaultError))
                        }
                    }
                    else {
                        return .success
                    }
                }
                else {
                    return .failure(APIError.message(defaultError))
                }
            }
            else {
                return .failure(APIError.message(defaultError))
            }
        }.validate()
    }
}
private let emptyDataStatusCodes: Set<Int> = [204, 205]
extension Request {
    /// Returns a SwiftyJSON object contained in a result type constructed from the response data using `JSONSerialization`
    /// with the specified reading options.
    ///
    /// - parameter options:  The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter response: The response from the server.
    /// - parameter data:     The data returned from the server.
    /// - parameter error:    The error already encountered if it exists.
    ///
    /// - returns: The result data type.
    public static func serializeResponseSwiftyJSON(
        options: JSONSerialization.ReadingOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<JSON>
    {
        guard error == nil else { return .failure(error!) }

        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(JSON.null) }

        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }

        do {
            let json = try JSONSerialization.jsonObject(with: validData, options: options)
            return .success(JSON(json))
        } catch {
            return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
        }
    }
}

extension DataRequest {
    /// Creates a response serializer that returns a SwiftyJSON object result type constructed from the response data using
    /// `JSONSerialization` with the specified reading options.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    ///
    /// - returns: A JSON object response serializer.
    public static func swiftyJSONResponseSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<JSON>
    {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseSwiftyJSON(options: options, response: response, data: data, error: error)
        }
    }

    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
    /// - parameter completionHandler: A closure to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func responseSwiftyJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<JSON>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.swiftyJSONResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}


//public final class SwiftyJSONResponseSerializer: ResponseSerializer {
//    /// `JSONSerialization.ReadingOptions` used when serializing a response.
//    public let options: JSONSerialization.ReadingOptions
//
//    /// HTTP response codes for which empty responses are allowed.
//    public let emptyResponseCodes: Set<Int>
//
//    /// HTTP request methods for which empty responses are allowed.
//    public let emptyRequestMethods: Set<HTTPMethod>
//
//    public typealias SerializedObject = JSON
//
//    public init(options: JSONSerialization.ReadingOptions = .allowFragments,
//                emptyResponseCodes: Set<Int> = JSONResponseSerializer.defaultEmptyResponseCodes,
//                emptyRequestMethods: Set<HTTPMethod> = JSONResponseSerializer.defaultEmptyRequestMethods) {
//        self.options = options
//        self.emptyResponseCodes = emptyResponseCodes
//        self.emptyRequestMethods = emptyRequestMethods
//    }
//
//    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> SerializedObject {
//        guard error == nil else { throw error! }
//
//        if let response = response, emptyResponseCodes.contains(response.statusCode) { return JSON.null }
//
//        guard let validData = data, validData.count > 0 else {
//            throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
//        }
//
//        do {
//            let json = try JSONSerialization.jsonObject(with: validData, options: options)
//            return JSON(json)
//        } catch {
//            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
//        }
//    }
//}
//
//public extension DataRequest {
//    /// Adds a handler to be called once the request has finished.
//    ///
//    /// - parameter options: The JSON serialization reading options. Defaults to `.allowFragments`.
//    /// - parameter completionHandler: A closure to be executed once the request has finished.
//    ///
//    /// - returns: The request.
//    @discardableResult
//    func responseSwiftyJSON(queue: DispatchQueue? = nil,
//                                   options: JSONSerialization.ReadingOptions = .allowFragments,
//                                   completionHandler: @escaping (AFDataResponse<SwiftyJSONResponseSerializer.SerializedObject>) -> Void) -> Self {
//        let serializer = SwiftyJSONResponseSerializer(options: options)
//        if let q = queue {
//            return response(queue: q,
//                            responseSerializer: serializer,
//                            completionHandler: completionHandler)
//
//        } else {
//            return response(responseSerializer: serializer,
//                            completionHandler: completionHandler)
//        }
//    }
//}


