//
//  FeedHeaderDetailFSPagerCell.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
//
//protocol FeedHeaderDetailFSPagerCellDelegate: class {
//
//}
//
//class FeedHeaderDetailFSPagerCellModel: AziBaseCellModel {
//
//    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
//        return 44
//    }
//
//    override func getCellName() -> String {
//        return FeedHeaderDetailFSPagerCell.className
//    }
//}

class FeedHeaderDetailFSPagerCell: FSPagerViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avataImageView: UIImageView!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configUI(object: SongsLocalDetail) {
        backgroundImageView.image = object.getImageSong()
        avataImageView.image = object.getImageSong()
        contentLbl.text = object.getContent()
        titleLbl.text = object.getNameSong()
    }
    
}
