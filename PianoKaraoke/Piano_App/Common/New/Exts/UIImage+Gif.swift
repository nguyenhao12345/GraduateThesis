//
//  UIImage+Gif.swift
//  azibai
//
//  Created by HoanVu on 8/18/17.
//  Copyright © 2017 azibai. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import Photos

class ImageViewRound: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
    }
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }

    func removePixel(to toPoint: CGPoint, lineWidth: CGFloat) {
        // 1
        UIGraphicsBeginImageContext(self.image!.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
       
        self.image?.draw(at:  contentClippingRect.origin)
        
        //chỉnh toạ độ đường vẽ
        context.move(to: toPoint)
        context.addLine(to: toPoint)

        // thông số cọ vẽ
        context.setLineCap(.round)
        context.setBlendMode(.clear)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(UIColor.red.cgColor)

        //đường vẽ
        context.strokePath()
        //kết thúc đường vẽ
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

    }

    public func loadGif(name: String, lossless : Bool = false) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name,lossless:lossless)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    public func loadGifData(data: Data, lossless : Bool = false) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let image = UIImage.gif(data: data,lossless:lossless)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    public func loadGifURL(url: String, lossless : Bool = false) {
        DispatchQueue.global().async {
            let image = UIImage.gif(url: url,lossless:lossless)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    public func loadGifURL(url: String, lossless : Bool = false, completion: @escaping (_ image:UIImage?) -> Void) {
        DispatchQueue.global().async {
            let image = UIImage.gif(url: url,lossless:lossless)
            DispatchQueue.main.async {
                if let _  = image {
                    self.image = image
                    completion(image!)
                }
            }
        }
    }
    
}

extension UIImage {
    public class func gif(data: Data, lossless : Bool = false) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        return UIImage.animatedImageWithSource(source,lossless:lossless)
        
    }
    
    public class func gifConvertData(url: String) -> Data? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return imageData
    }
    
    public class func gif(url: String, lossless : Bool = false) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData,lossless:lossless)
    }
    
    public class func gif(name: String, lossless : Bool = false) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData,lossless:lossless)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.01
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        
        if delay < 0.01 {
            delay = 0.01 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource, lossless : Bool = false) -> UIImage? {
        let lossper = lossless == true ? 1 : 1
        
        var count = CGImageSourceGetCount(source) / lossper
        
        if count > 10{
            count = count - (count/3)
        }
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
             if lossless{
                delays.append(Int(delaySeconds * 100.0)) // Seconds to ms
             }else{
                delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
            }
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            if lossless{
                let dataConvertLowest = frame.lowestQualityJPEGNSData
                let imageConvert = UIImage.init(data: dataConvertLowest as Data)
                frameCount = Int(delays[Int(i)] / gcd)
                
                for _ in 0..<frameCount {
                    frames.append(imageConvert!)
                }
            }
            else{
                frameCount = Int(delays[Int(i)] / gcd)
                
                for _ in 0..<frameCount {
                    frames.append(frame)
                }
            }
            
        }
        
        // Heyhey
        if lossless{
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 100.0)
        
        return animation
        }else{
            let animation = UIImage.animatedImage(with: frames,
                                                  duration: Double(duration) / 1000.0)
            
            return animation
        }
    }
    
}

extension UIImage {
    
    class func getImagePHAsset(_ phasset: PHAsset?) -> UIImage? {
        return nil
//        guard let asset = phasset else { return nil }
//        let manager = PHImageManager.default()
//        let option = PHImageRequestOptions()
//        var thumbnail = UIImage()
//        option.isSynchronous = true
//        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
//            guard let _thumbnail = result else { return }
//            thumbnail = _thumbnail
//        })
//        return thumbnail
    }
    
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeImageCustom(targetSize: CGSize) -> UIImage {
        let newSize: CGSize = CGSize(width: targetSize.width, height: targetSize.height)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension CGImage {
    var isDark: Bool {
        get {
            guard let imageData = self.dataProvider?.data else { return false }
            guard let ptr = CFDataGetBytePtr(imageData) else { return false }
            let length = CFDataGetLength(imageData)
            let threshold = Int(Double(self.width * self.height) * 0.45)
            var darkPixels = 0
            for i in stride(from: 0, to: length, by: 4) {
                let r = ptr[i]
                let g = ptr[i + 1]
                let b = ptr[i + 2]
                let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                if luminance < 150 {
                    darkPixels += 1
                    if darkPixels > threshold {
                        return true
                    }
                }
            }
            return false
        }
    }
}

extension UIImage {
    var isDark: Bool {
        get {
            return self.cgImage?.isDark ?? false
        }
    }
        func maskWithColor(color: UIColor) -> UIImage? {
            let maskImage = cgImage!
            
            let width = size.width
            let height = size.height
            let bounds = CGRect(x: 0, y: 0, width: width, height: height)
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
            
            context.clip(to: bounds, mask: maskImage)
            context.setFillColor(color.cgColor)
            context.fill(bounds)
            
            if let cgImage = context.makeImage() {
                let coloredImage = UIImage(cgImage: cgImage)
                return coloredImage
            } else {
                return nil
            }
        }
}

extension UIImage
{
    var highestQualityJPEGNSData: NSData {
        return self.jpegData(compressionQuality: 1)! as NSData
        
    }
    var highQualityJPEGNSData: NSData    { return self.jpegData(compressionQuality: 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return self.jpegData(compressionQuality: 0.25)! as NSData}
    var lowestQualityJPEGNSData: NSData  { return self.jpegData(compressionQuality: 0.0)! as NSData }
}
