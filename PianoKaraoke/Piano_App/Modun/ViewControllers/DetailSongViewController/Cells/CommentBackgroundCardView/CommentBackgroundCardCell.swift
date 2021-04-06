//
//  CommentBackgroundCardCell.swift
//  Piano_App
//
//  Created by Azibai on 15/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

class CommentBackgroundCardCell: UICollectionReusableView {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

class CommentUIVisualEffectView: UIVisualEffectView {
    override func draw(_ rect: CGRect) {
        let layerWidth = layer.frame.width
        // Create Path
        let bezierPath = UIBezierPath()
        //  Points
        let pointA = CGPoint(x: 0, y: 0)
        let pointB = CGPoint(x: layerWidth, y: 0)
        let pointC = CGPoint(x: layerWidth, y: 420)
        let pointD = CGPoint(x: 0, y: 360)
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
