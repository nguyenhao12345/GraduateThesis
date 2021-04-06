//
//  PostNewsFeedCell.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol PostNewsFeedCellDelegate: class {
    
}

class PostNewsFeedCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 60 + 48
    }
    
    override func getCellName() -> String {
        return PostNewsFeedCell.className
    }
}

class PostNewsFeedCell: CellModelView<PostNewsFeedCellModel> {
    
    weak var delegate: PostNewsFeedCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? PostNewsFeedCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: PostNewsFeedCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
}



