//
//  VietSongDetailCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol VietSongDetailCellDelegate: class {
    
}

class VietSongDetailCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 44
    }
    
    override func getCellName() -> String {
        return VietSongDetailCell.className
    }
}

class VietSongDetailCell: CellModelView<VietSongDetailCellModel> {
    
    weak var delegate: VietSongDetailCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameSongLbl: UILabel!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? VietSongDetailCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: VietSongDetailCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
    func config(object: MusicModel?) {
        imageView.setImageURL(URL(string: object?.imageSong ?? ""))
        nameSongLbl.text = object?.nameSong
    }
    
}



