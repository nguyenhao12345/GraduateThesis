//
//  SectionBackgroundPaymentCardView.swift
//  Piano_App
//
//  Created by Azibai on 09/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
public class SectionBackgroundCardViewLayoutPayment: SectionBackgroundCardViewLayout<SectionBackgroundPaymentCardView> {
    
}

public class SectionBackgroundPaymentCardView: UICollectionReusableView {
    
    @IBOutlet weak var cardBorderShadowView: UIView!
    var paddingHeight: CGFloat = 0
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        cardBorderShadowView.layer.cornerRadius = CornerRadius_CardView
        //
        // border
//        cardBorderShadowView.layer.borderWidth = 1.0
//        cardBorderShadowView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        // shadow
        cardBorderShadowView.layer.shadowColor = #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1).cgColor
        cardBorderShadowView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cardBorderShadowView.layer.shadowOpacity = 0.3
        cardBorderShadowView.layer.shadowRadius = 10
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.frame
        frame.origin.x = Margin_Horizontal
        frame.origin.y = Margin_Default + paddingHeight
        frame.size.width -= Margin_Horizontal*2
        frame.size.height -= Margin_Default*2
//        frame.size.height -= paddingHeight
        cardBorderShadowView.frame = frame
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? SectionBackgroundCardLayoutAttributes {
            paddingHeight = attributes.paddingHeight
        }
    }
}


