//
//  RoundSlider.swift
//  Piano_App
//
//  Created by Azibai on 16/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import AudioKitUI
import AudioKit

class RoundSlider: BaseView {

    @IBOutlet weak var slider: FlatKnob!
    @IBOutlet weak var label: UILabel!
    
//    var range: ClosedRange = 0.0...1.0
    func config(range: ClosedRange<Double>, value: Double, labelName: String, callback: @escaping (Double)->Void) {
        slider.range = range
        slider.value = value
        label.text = labelName
        slider.callback = { [weak self] value in
            self?.label.text = labelName + "Value: \(value)"
            callback(value)
        }
    }
}
