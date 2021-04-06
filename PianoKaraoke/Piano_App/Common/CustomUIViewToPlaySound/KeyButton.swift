//
//  ViewController.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 10/13/18.
//  Copyright © 2018 com.nguyenhieu.demo. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

protocol KeyButtonDelegate {
    func beganTouch(keyButton: KeyButton)
    func endedTouch(keyButton: KeyButton)
    func swipeTouch(keyButtonStart: KeyButton, keyButtonEnd: UIButton)
}

class KeyButton: UIButton {
    var delegate: KeyButtonDelegate?
    static var keybutton = KeyButton()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = true
        isSelected = true
        delegate?.beganTouch(keyButton: self)
        self.shake()
        self.flash()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        isSelected = false
        delegate?.endedTouch(keyButton: self)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isHighlighted = false
        isSelected = false
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let point:CGPoint = touch!.location(in: self)
//        print(point)
    }
}

