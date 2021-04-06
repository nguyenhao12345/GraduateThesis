//
//  UIScrollView.swift
//  Azibai
//
//  Created by Azi IOS on 1/17/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setScrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
