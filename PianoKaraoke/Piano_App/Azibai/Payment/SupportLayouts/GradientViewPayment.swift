//
//  GradientViewPayment.swift
//  Piano_App
//
//  Created by Azibai on 14/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

class GradientViewPayment: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        
        gradientLayer.colors = [#colorLiteral(red: 0.9843137255, green: 0.9254901961, blue: 0.8235294118, alpha: 0.02).cgColor, #colorLiteral(red: 0.968627451, green: 0.8509803922, blue: 0.6352941176, alpha: 0.04).cgColor, #colorLiteral(red: 1, green: 0.8588235294, blue: 0.5843137255, alpha: 0.09).cgColor]
    }
}
