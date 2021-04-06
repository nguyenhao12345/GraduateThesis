//
//  UICollectionViewCell.swift
//  Azibai
//
//  Created by Mac on 10/20/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import Foundation
import PINRemoteImage

extension UICollectionViewCell: PINRemoteImageManagerAlternateRepresentationProvider {
    
    func pinDowloadImage(imageUrl: URL, completion: @escaping(PinResultRequest) -> ()) {
        let imageManager = PINRemoteImageManager.init(sessionConfiguration: nil, alternativeRepresentationProvider: self)
        imageManager.downloadImage(with: imageUrl) { (result : PINRemoteImageManagerResult) in
            
            guard let animatedData = result.alternativeRepresentation as? NSData, let animatedSize = PINGIFAnimatedImage(animatedImageData: animatedData as Data) else {
                if let data = result.image?.compressedData(quality: 1.0) {
                    completion(.image(imageData: data, size: result.image?.size ?? CGSize.zero))
                }
                
                return
            }
            completion(.animatedImage(imageData: animatedData as Data, size: CGSize(width: CGFloat(animatedSize.width), height: CGFloat(animatedSize.height))))
        }
    }
    
    public func alternateRepresentation(with data: Data!, options: PINRemoteImageManagerDownloadOptions = []) -> Any! {
        guard let nsdata = data as NSData? else {
            return nil
        }
        if nsdata.pin_isGIF() || nsdata.pin_isAnimatedGIF() {
            return data
        }
        return nil
    }
}
