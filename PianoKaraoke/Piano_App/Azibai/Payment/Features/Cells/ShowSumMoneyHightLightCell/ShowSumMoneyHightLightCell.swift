//
//  ShowSumMoneyHightLightCell.swift
//  Piano_App
//
//  Created by Azibai on 09/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

class ShowSumMoneyHightLightCellModel: ShowSumMoneyCellModel {
    override func getCellName() -> String {
        return ShowSumMoneyHightLightCell.className
    }
}

class ShowSumMoneyHightLightCell: ShowSumMoneyCell {
    
    @IBAction override func clickBtn(_ sender: Any?) {
        delegate?.clickDrawMoney()
    }
}



