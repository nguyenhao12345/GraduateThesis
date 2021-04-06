//
//  TopMusicCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol TopMusicCellDelegate: class {
    
}

class TopMusicCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 44
    }
    
    override func getCellName() -> String {
        return TopMusicCell.className
    }
}

class TopMusicCell: CellModelView<TopMusicCellModel> {
    
    weak var delegate: TopMusicCellDelegate?
    
    @IBOutlet weak var imageAvata: UIImageView!
    @IBOutlet weak var imageBackground: UIImageView!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? TopMusicCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: TopMusicCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        config()
    }
    
    func config() {
        let image: String = ["backgroundViolet2","backgroundBlue", "cham-day-noi-dau", "dung-hoi-em", "tinh-don-phuong", "ThanThoai", "PIANO-1"].random()
        imageAvata.image = UIImage.init(named: image)
        imageBackground.image = UIImage.init(named: image)

    }
    
}



