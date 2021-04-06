//
//  MusicSimpleCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol MusicSimpleCellDelegate: class {
    
}

class MusicSimpleCellModel: AziBaseCellModel {
    var dataModel: MusicModel?
    var height: CGFloat = 0
    var width: CGFloat = 0
    init(dataModel: MusicModel?, height: CGFloat, width: CGFloat) {
        self.dataModel = dataModel
        self.height = height
        self.width = width
        super.init()
    }
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return height
    }
    
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return width
    }
    
    override func getCellName() -> String {
        return MusicSimpleCell.className
    }
}

class MusicSimpleCell: CellModelView<MusicSimpleCellModel> {
    
    weak var delegate: MusicSimpleCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? MusicSimpleCellDelegate
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewMedia: UIView!

    @IBOutlet weak var nameSongLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: MusicSimpleCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        
        config(object: cellModel.dataModel)
    }
    
    func config(object: MusicModel?) {
        imageView.setImageURL(URL(string: object?.imageSong ?? ""))
        nameSongLbl.text = object?.nameSong
        viewMedia.dropShadow(color: .black, opacity: 0.4, offSet: CGSize(width: 1, height: -1), radius: 7, scale: true)

    }
}



