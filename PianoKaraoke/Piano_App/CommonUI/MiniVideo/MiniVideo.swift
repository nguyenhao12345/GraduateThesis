//
//  MiniVideo.swift
//  Piano_App
//
//  Created by Azibai on 26/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

class MiniVideo: BaseView {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let window = UIApplication.topViewController() else { return }
        window.view.bringSubviewToFront(containerView)
    }


    func hidden() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
        guard let window = UIApplication.topViewController() else { return }
        window.view.bringSubviewToFront(containerView)
    }
}
