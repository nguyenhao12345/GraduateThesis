//
//  MoneyNeedWithDrawalSectionController.swift
//  Piano_App
//
//  Created by Azibai on 14/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol MoneyNeedWithDrawalSectionDelegate: class {
    func updateNumberMoneyWithDrawal(double: Double)
}

class MoneyNeedWithDrawalSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    
    let diffIDCellModelSumMoney: String = "diffIDCellModelSumMoney"
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return MoneyNeedWithDrawalSectionController()
    }
}

class MoneyNeedWithDrawalSectionController: SectionController<MoneyNeedWithDrawalSectionModel> {
    
    weak var delegate: MoneyNeedWithDrawalSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? MoneyNeedWithDrawalSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return MoneyNeedWithDrawalCellBuilder()
    }

}
extension MoneyNeedWithDrawalSectionController: TextFieldInputCellDelegate {
    func selectedBank(bankModel: BankModel?) {
    }
    
    func selectedMomo(momoModel: WalletModel?) {
        
    }
    
    func updateTextFieldInputFromKeyboard(string: String) {
        let money = NumberFormatter().number(from: string)?.doubleValue
        if let cell = cellModelByDiffID(sectionModel?.diffIDCellModelSumMoney) as? HeaderSimpleCellModel {
            let sum = ((money ?? 0) + 11000).toMoney()
            cell.attributed =  Helper.getAttributesStringWithFontAndColor(string: "     Tổng tiền rút: \(sum) VNĐ", font: .kohoMedium16, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1))
            cell.updateCell()
        }
        if let _money = money {
            delegate?.updateNumberMoneyWithDrawal(double: _money)
        }
    }
}

class MoneyNeedWithDrawalCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? MoneyNeedWithDrawalSectionModel else { return }
        addBlankSpace(18, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "     Số tiền cần rút", font: .kohoMedium16, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)), height: 34)
        
        let cellTextField = TextFieldInputCellModel(content: "", placeholder: "Nhập số tiền cần rút", type: .Keyboard(.number))
        appendCell(cellTextField)
        
        addBlankSpace(18, color: .clear)

        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "     Phí chuyển khoản: 11.000 VNĐ", font: .kohoMedium16, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)), height: 34)

        let cellModel = HeaderSimpleCellModel(attributed: Helper.getAttributesStringWithFontAndColor(string: "     Tổng tiền rút: 11.000 VNĐ", font: .kohoMedium16, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)), height: 34, spaceWitdh: 0, truncationString: nil, numberOfLine: 1)

        cellModel.diffID = sectionModel.diffIDCellModelSumMoney
        appendCell(cellModel)
        
        addBlankSpace(6, color: .clear)
    }
}
