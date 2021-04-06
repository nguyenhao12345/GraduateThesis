//
//  MixMusicBackgroundCard.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

class MixMusicBackgroundCard: UICollectionReusableView {

    
    @IBOutlet weak var viewContainer: DiagonalCustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.viewContainer.backgroundColor = UIColor(hexString: hex)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    

}

class DiagonalCustomView: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        // Get Height and Width
        _ = layer.frame.height
        let layerWidth = layer.frame.width
        // Create Path
        let bezierPath = UIBezierPath()
        //  Points
        let pointA = CGPoint(x: 0, y: 0)
        let pointB = CGPoint(x: layerWidth, y: 0)
        let pointC = CGPoint(x: layerWidth, y: 420)
        let pointD = CGPoint(x: 0, y: 300)
        // Draw the path
        bezierPath.move(to: pointA)
        bezierPath.addLine(to: pointB)
        bezierPath.addLine(to: pointC)
        bezierPath.addLine(to: pointD)
        bezierPath.close()
        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}
