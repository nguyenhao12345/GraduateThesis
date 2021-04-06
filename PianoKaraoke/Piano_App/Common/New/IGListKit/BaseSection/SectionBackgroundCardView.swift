//
//  SectionBackgroundCardView.swift
//  gapoFeedClone
//
//  Created by Azibai on 18/08/2020.
//  Copyright © 2020 com.hieudev. All rights reserved.
//
import UIKit

class SectionBackgroundCardView: UICollectionReusableView {

    @IBOutlet weak var cardBorderShadowView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        cardBorderShadowView.layer.cornerRadius = 10
//         
//        // border
//        cardBorderShadowView.layer.borderWidth = 1.0
//        cardBorderShadowView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
//         
//        // shadow
//        cardBorderShadowView.layer.shadowColor = UIColor.black.cgColor
//        cardBorderShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cardBorderShadowView.layer.shadowOpacity = 0.1
//        cardBorderShadowView.layer.shadowRadius = 4.0
//        self.cardBorderShadowView.backgroundColor = [UIColor.red, UIColor.blue, UIColor.yellow].random()
//        print("SectionBackgroundCardView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        var frame = self.frame
//        frame.origin.x = 15
//        frame.origin.y = 7
//        frame.size.width -= 30
//        frame.size.height -= 14
//        cardBorderShadowView.frame = frame
//        print("layoutSubviews")
    }
}
