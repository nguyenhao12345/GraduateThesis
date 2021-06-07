//
//  SearchDatePaymentCell.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol SearchDatePaymentCellDelegate: class {
    func clickSearchHistory()
}

class SearchDatePaymentCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 44
    }
    
    override func getCellName() -> String {
        return SearchDatePaymentCell.className
    }
}

class SearchDatePaymentCell: CellModelView<SearchDatePaymentCellModel> {
    
    weak var delegate: SearchDatePaymentCellDelegate?
    @IBOutlet weak var containerView: ViewRound!
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? SearchDatePaymentCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: SearchDatePaymentCellModel) {
        super.bindCellModel(cellModel)
        // shadow
        containerView.layer.shadowColor = #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 10

    }
    
    @IBAction func clickSearch(_ sender: Any?) {
        delegate?.clickSearchHistory()
    }
    
}



