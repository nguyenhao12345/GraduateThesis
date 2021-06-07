//
//  HistoryLabelCellCell.swift
//  Piano_App
//
//  Created by Azibai on 04/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol HistoryLabelCellDelegate: class {
    func viewAllHistory()
}

class HistoryLabelCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 44
    }
    
    override func getCellName() -> String {
        return HistoryLabelCell.className
    }
}

class HistoryLabelCell: CellModelView<HistoryLabelCellModel> {
    
    weak var delegate: HistoryLabelCellDelegate?
    @IBOutlet weak var containerView: ViewRound!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? HistoryLabelCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: HistoryLabelCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        
        containerView.layer.shadowColor = #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 10
    }
    
    @IBAction func clickBtn(_ sender: Any?) {
        delegate?.viewAllHistory()
    }
    
}



