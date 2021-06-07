//
//  SectionBackgroundCardView.swift
//  BaseIGListKit
//
//  Created by Azibai on 21/12/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import IGListKit

public class SectionBackgroundCardView2: UICollectionReusableView {

    @IBOutlet weak var cardBorderShadowView: UIView!
    var paddingHeight: CGFloat = 0
    public override func awakeFromNib() {
        super.awakeFromNib()
//        cardBorderShadowView.type = .normal
//        cardBorderShadowView.isSelected = true

        cardBorderShadowView.layer.cornerRadius = CornerRadius_CardView
//
        // border
        cardBorderShadowView.layer.borderWidth = 1.0
        cardBorderShadowView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor

        // shadow
        cardBorderShadowView.layer.shadowColor = UIColor.black.cgColor
        cardBorderShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardBorderShadowView.layer.shadowOpacity = 0.1
        cardBorderShadowView.layer.shadowRadius = 4.0
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.frame
        frame.origin.x = Margin_Horizontal
        frame.origin.y = Margin_Default + paddingHeight
        frame.size.width -= Margin_Horizontal*2
        frame.size.height -= Margin_Default*2
        frame.size.height -= paddingHeight
        cardBorderShadowView.frame = frame
//        cardBorderShadowView.updateSublayersShape()
//        print("layoutSubviews")
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? SectionBackgroundCardLayoutAttributes {
            paddingHeight = attributes.paddingHeight
        }
    }
}


