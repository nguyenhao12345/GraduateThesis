//
//  UIImageView.swift
//  Azibai
//
//  Created Azi IOS on 11/8/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit
import Photos
import PINRemoteImage
import Kingfisher

// MARK: - Methods
public extension UIImageView {

    /// SwifterSwift: Set image from a URL.
    ///
    /// - Parameters:
    ///   - url: URL of image.
    ///   - contentMode: imageView content mode (default is .scaleAspectFit).
    ///   - placeHolder: optional placeholder image
    ///   - completionHandler: optional completion handler to run when download finishs (default is nil).
    func download(
        from url: URL,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        placeholder: UIImage? = nil,
        completionHandler: ((UIImage?) -> Void)? = nil) {

        image = placeholder
        self.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async {
                self.image = image
                completionHandler?(image)
            }
            }.resume()
    }

    /// SwifterSwift: Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }

    /// SwifterSwift: Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }

    //
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func imageWithAsset(_ asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        options.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: self.width * UIScreen.main.scale, height: self.height * UIScreen.main.scale), contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
            
        })
        return thumbnail
    }
}
#endif

class ScaleAspectFitImageView : UIImageView {
    /// constraint to maintain same aspect ratio as the image
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
}

//Load image
extension UIImageView {
    func setImageURL(_ url: URL?, defaultImage: UIImage? = nil, completion: ((PINRemoteImageManagerResult?)->())? = nil) {
        image = Constants.Image.Default
        
        guard let url = url else {
            image = Constants.Image.Default
            setNeedsLayout()
            completion?(nil)
            return
        }
        
        let placeholder = defaultImage == nil ? Constants.Image.Default : defaultImage
        
        //        pin_updateWithProgress = true
        pin_setImage(from: url, placeholderImage: placeholder) { [weak self] (result) in
            guard let self = self else { return }
            if result.image == nil, !url.isGIF() {
                self.image = Constants.Image.Default
                //                self.setDefaultImage()
            }
            completion?(result)
        }

    }
    
    func setDefaultImage() {
        loadGif(name: "default")
    }
    
    @discardableResult
    func setImageWithKF(_ url: URL?, defaultImage: UIImage? = Constants.Image.Default, completion: ((RetrieveImageResult?)->())? = nil) -> DownloadTask?
    {
        let dowloadTask: DownloadTask? = self.kf.setImage(
            with: url,
            placeholder: defaultImage) { result in
            switch result {
            case .success(let value):
                completion?(value)
                break
            case .failure(let error):
                Log("Load image fail: \(error)")
                completion?(nil)
                break
            }
        }
        return dowloadTask
        //        if url?.pathExtension.lowercased() == "gif" {
        //            dowloadTask = self.kf.setImage(with: url, placeholder: defaultImage,
        //                                           options: [.cacheOriginalImage])
        //        } else {
        ////            let processor = DownsamplingImageProcessor(size: self.frame.size)
        //            dowloadTask = self.kf.setImage(
        //                with: url,
        //                placeholder: defaultImage,
        //                options: [
        ////                    .processor(processor),
        ////                    .scaleFactor(UIScreen.main.scale),
        ////                    .transition(.none),
        //                    .cacheOriginalImage
        //            ]) { result in
        //                switch result {
        //                case .success(let value):
        //                    completion?(value)
        //                    break
        //                case .failure(let error):
        //                    Log("Load image fail: \(error)")
        //                    completion?(nil)
        //                    break
        //                }
        //            }
        //        }
    }
    
    func cancelDownloadTask() {
        self.kf.cancelDownloadTask()
    }
}

