//
//  DefaultCustomAVPlayer.swift
//  Azibai
//
//  Created by Azibai on 28/07/2020.
//  Copyright © 2020 Azi IOS. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class DefaultCustomAVPlayer: CustomAVPlayer {

    override var _needShowControls: Bool {
        didSet {
            self.playButton.isHidden = !_needShowControls
            if _currentVideoState == .pausing && !_needShowControls {
                self.playButton.isHidden = false
            }
        }
    }

    override var backgroundImageView: UIImageView! {
        didSet {
            backgroundImageView.layer.zPosition = 0
        }
    }
    override func configCurrentVideoState(state: CurrentVideoState) {
        super.configCurrentVideoState(state: state)
        playButton.isHidden = true
//        switch _currentVideoState {
//        case .playing:
////            self.playButton.setImage(UIImage(named: "pause"), for: .normal)
//            return
//        case .pausing:
////            self.playButton.setImage(UIImage(named: "play"), for: .normal)
//            return
//        default:
//            return
//        }
    }
    
    override func configIndicatorView(value: Bool) {
        super.configIndicatorView(value: value)
        playButton.isHidden = true
//        switch _currentVideoState {
//        case .playing:
//            self.playButton.setImage(UIImage(named: "pause"), for: .normal)
//            return
//        case .pausing:
//            self.playButton.setImage(UIImage(named: "play"), for: .normal)
//            return
//        default:
//            return
//        }
    }
    override func configTotalTime(value: Float) { }
    override func configCurrentTime(currentTime: Double) {}
    override func hiddenControl() {}
//    override func configIndicatorView(value: Bool) { }
    override func tapControl() {}
}

private var pTouchAreaEdgeInsets: UIEdgeInsets = .zero
extension UIButton {
    var touchAreaEdgeInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &pTouchAreaEdgeInsets) as? NSValue {
                var edgeInsets: UIEdgeInsets = .zero
                value.getValue(&edgeInsets)
                return edgeInsets
            }
            else {
                return .zero
            }
        }
        set(newValue) {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: .zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            objc_setAssociatedObject(self, &pTouchAreaEdgeInsets, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if UIEdgeInsetsEqualToEdgeInsets(self.touchAreaEdgeInsets, .zero) || !self.isEnabled || self.isHidden {
            return super.point(inside: point, with: event)
        }

        let relativeFrame = self.bounds
        let hitFrame = relativeFrame.inset(by: self.touchAreaEdgeInsets)

        return hitFrame.contains(point)
    }
}
