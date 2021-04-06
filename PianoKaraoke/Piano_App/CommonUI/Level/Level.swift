//
//  Level.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/3/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import UIKit

class Level: UIView {
    @IBOutlet private var contentView: UIView!
    private var numberStars: Int?
    
    
    @IBOutlet private weak var stars5: UIImageView!
    @IBOutlet private weak var stars4: UIImageView!
    @IBOutlet private weak var stars3: UIImageView!
    @IBOutlet private weak var stars2: UIImageView!
    @IBOutlet private weak var stars1: UIImageView!
    func config(numberStars: Int?) {
        self.numberStars = numberStars
        switch numberStars {
        case 1:
                stars1.image = UIImage(named: "stars")
                stars2.image = UIImage(named: "starsExtra")
                stars3.image = UIImage(named: "starsExtra")
                stars4.image = UIImage(named: "starsExtra")
                stars5.image = UIImage(named: "starsExtra")
        case 2:
                stars1.image = UIImage(named: "stars")
                stars2.image = UIImage(named: "stars")
                stars3.image = UIImage(named: "starsExtra")
                stars4.image = UIImage(named: "starsExtra")
                stars5.image = UIImage(named: "starsExtra")
        case 3:
                stars1.image = UIImage(named: "stars")
                stars2.image = UIImage(named: "stars")
                stars3.image = UIImage(named: "stars")
                stars4.image = UIImage(named: "starsExtra")
                stars5.image = UIImage(named: "starsExtra")
        case 4:
                stars1.image = UIImage(named: "stars")
                stars2.image = UIImage(named: "stars")
                stars3.image = UIImage(named: "stars")
                stars4.image = UIImage(named: "stars")
                stars5.image = UIImage(named: "starsExtra")
        case 5:
            stars1.image = UIImage(named: "stars")
            stars2.image = UIImage(named: "stars")
            stars3.image = UIImage(named: "stars")
            stars4.image = UIImage(named: "stars")
            stars5.image = UIImage(named: "stars")
        default:    break
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        instanceFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.instanceFromNib()
//        fatalError("init(coder:) has not been implemented")
    }
    private func instanceFromNib(){
        Bundle.main.loadNibNamed("Level", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
