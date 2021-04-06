//
//  NewsFeedMeCommentCell.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol NewsFeedMeCommentCellDelegate: class {
    
}

class NewsFeedMeCommentCellModel: MeCommentCellModel {
    override init() {
        super.init()
//        margin = 0
    }
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return super.getCellHeight(maxWidth: maxWidth) + 8
    }
    
    override func getCellName() -> String {
        return NewsFeedMeCommentCell.className
    }
}

class NewsFeedMeCommentCell: MeCommentCell {
    
}



