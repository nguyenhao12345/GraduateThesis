//
//  MediaDefaultCell.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol MediaDefaultCellDelegate: class {
    
}

class MediaDefaultCellModel: AziBaseCellModel {
    
    var urlImg: String = ""
    var newsModel: NewsFeedModel?
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return maxWidth*2/3
    }
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth - 1
    }
    override func getCellName() -> String {
        return MediaDefaultCell.className
    }
}

class MediaDefaultCell: CellModelView<MediaDefaultCellModel> {
    
    weak var delegate: MediaDefaultCellDelegate?
    @IBOutlet weak var img: HImageView!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? MediaDefaultCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img.config(HImageViewConfigure(backgroundColor: .clear,
                                               durationDismissZoom: 0.2,
                                               maxZoom: 4,
                                               minZoom: 0.8,
                                               vibrateWhenStop: false,
                                               autoStopWhenZoomMin: false,
                                               isUpdateAlphaWhenHandle: true,
                                               backgroundColorWhenZoom: .clear))
        self.backgroundColor = UIColor(hexString: "E5E5E5")
    }
    
    override func bindCellModel(_ cellModel: MediaDefaultCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        img.setImageURL(URL(string: cellModel.urlImg))
    }
    
    @IBAction func clickPlay(_ sender: Any?) {
        guard let newsModel = cellModel?.newsModel,
            let vc = parentViewController else { return }
        AppRouter.shared.gotoNewsFeedDetail(newsModel: newsModel, viewController: vc)
    }
    
}



