
//  Created by NguyenHieu on 11/03/2020.
//  Copyright © 2020 Azibai. All rights reserved.
//

import UIKit

public struct HImageViewConfigure {
    
    public var backgroundColor:         UIColor          = .clear
    public var durationDismissZoom:     TimeInterval     = 0.2
    public var maxZoom:                 CGFloat?         = 4
    public var minZoom:                 CGFloat          = 0.8
    public var vibrateWhenStop:         Bool             = false
    public var autoStopWhenZoomMin:     Bool             = false
    public var isUpdateAlphaWhenHandle: Bool             = true
    public var backgroundColorWhenZoom: UIColor          = .black

    public var licensedZoom:            Bool             = false

    
}
