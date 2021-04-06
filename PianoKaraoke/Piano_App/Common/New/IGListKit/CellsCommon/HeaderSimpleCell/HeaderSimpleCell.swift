//
//  HeaderSimpleCell.swift
//  NewsFeed
//
//  Created by Azibai on 30/12/2019.
//  Copyright © 2019 AzibaiNewFeed. All rights reserved.
//

import UIKit
import DTCoreText

protocol HeaderSimpleCellDelegate: class {
    
}
func heightForView(textAtt: NSAttributedString, width: CGFloat, numberOfline: Int = 0) -> CGFloat {
    let label: DTAttributedLabel = DTAttributedLabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = numberOfline
    label.lineBreakMode = .byTruncatingTail
    label.attributedString = textAtt
    label.sizeToFit()
    return label.frame.height
}

func sizeForView(textAtt: NSAttributedString, width: CGFloat, numberOfline: Int = 0) -> CGSize {
    let label: DTAttributedLabel = DTAttributedLabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = numberOfline
    label.lineBreakMode = .byTruncatingTail
    label.attributedString = textAtt
    label.sizeToFit()
    return label.frame.size
}



class HeaderSimpleCellModel: AziBaseCellModel {
    
    var attributed: NSMutableAttributedString?
    var truncationString: NSMutableAttributedString?
    var height: CGFloat?
    var spaceWitdh: CGFloat = 0
    var numberOfLine = 0
    init(attributed: NSMutableAttributedString, height: CGFloat? = 44, spaceWitdh: CGFloat = 0, truncationString: NSMutableAttributedString? = nil, numberOfLine: Int = 0) {
        self.attributed = attributed
        self.height = height
        self.spaceWitdh = spaceWitdh
        self.truncationString = truncationString
        self.numberOfLine = numberOfLine
    }
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        if let height = height {
            return height
        }
        guard let att = attributed else { return 44 }
        return heightForView(textAtt: att, width: maxWidth - spaceWitdh, numberOfline: numberOfLine)
    }
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth - spaceWitdh
    }
    
    override func getCellName() -> String {
        return "HeaderSimpleCell"
    }
}

class HeaderSimpleCell: CellModelView<HeaderSimpleCellModel> {
    
    weak var delegate: HeaderSimpleCellDelegate?
    @IBOutlet weak var coreText: DTAttributedLabel!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? HeaderSimpleCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        initGesture()

    }
    
    override func bindCellModel(_ cellModel: HeaderSimpleCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        self.coreText.attributedString = cellModel.attributed
        self.coreText.numberOfLines = cellModel.numberOfLine
        self.coreText.truncationString = cellModel.truncationString
        if cellModel.truncationString != nil {
            initGesture()
        }
    }
    
    func initGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clickLabel))
        coreText.addGestureRecognizer(tap)
    }
    
    @objc func clickLabel(_ sender: Any) {
        if cellModel?.truncationString == nil {
            return
        }
        if coreText.numberOfLines == 0 {
            cellModel?.numberOfLine = 3
        }
        else {
            cellModel?.numberOfLine = 0
        }
        cellModel?.reloadCell(true)
    }
    
}



