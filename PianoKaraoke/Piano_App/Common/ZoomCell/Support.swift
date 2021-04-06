
//  Created by NguyenHieu on 11/03/2020.
//  Copyright © 2020 Azibai. All rights reserved.
//

import UIKit

//extension NSNotification.Name {
//    
//    public static let CellisZooming = Notification.Name("CellisZooming")
//    public static let CellStopZoom = Notification.Name("CellStopZoom")
//
//}

extension UIView {
    func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraints = superview?.constraints {
            for constraint in constraints where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
                return constraint
            }
        }
        return nil
    }

    func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        let firstItemMatch = constraint.firstItem as? UIView == self && constraint.firstAttribute == layoutAttribute
        let secondItemMatch = constraint.secondItem as? UIView == self && constraint.secondAttribute == layoutAttribute
        return firstItemMatch || secondItemMatch
    }

    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
}
public extension UIImage {
    var hasContent: Bool {
    return cgImage != nil || ciImage != nil
  }
}
