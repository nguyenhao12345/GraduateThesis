//
//  MethodReceiveMoneySectionController.swift
//  Piano_App
//
//  Created by Azibai on 14/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol MethodReceiveMoneySectionDelegate: class {
    func updateTypeWithDrawal(type: WithDrawalMoneyViewController.TypeWithDrawal)
}

class MethodReceiveMoneySectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    var type: PaymentTextFieldInputCellModel.TypeInPut.DropDownType = .Date
    
    
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return MethodReceiveMoneySectionController()
    }
}

class MethodReceiveMoneySectionController: SectionController<MethodReceiveMoneySectionModel> {
    
    weak var delegate: MethodReceiveMoneySectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? MethodReceiveMoneySectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return MethodReceiveMoneyCellBuilder()
    }
    
}
extension MethodReceiveMoneySectionController: DotSelectPaymentCellDelegate {
    func selectedCell(_ cellModel: DotSelectPaymentCellModel) {
        if cellModel.title == "Chuyển vào ví Momo" {
            sectionModel?.type = .Momo
        } else if cellModel.title == "Chuyển khoản ngân hàng" {
            sectionModel?.type = .Bank
        }
        updateSection(animated: true)
    }
}

extension MethodReceiveMoneySectionController: TextFieldInputCellDelegate {
    func updateTextFieldInputFromKeyboard(string: String) {
    }
    
    func selectedMomo(momoModel: WalletModel?) {
        guard let id = momoModel?.id else { return }
        delegate?.updateTypeWithDrawal(type: .Wallet(id))
    }
    
    func selectedBank(bankModel: BankModel?) {
        guard let id = bankModel?.id else { return }
        delegate?.updateTypeWithDrawal(type: .Bank(id))
    }
}

class MethodReceiveMoneyCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? MethodReceiveMoneySectionModel else { return }
        
        addBlankSpace(18, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "     Chọn phương thức nhận tiền", font: .kohoMedium16, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)), height: 30)
        
        let cellMomo = DotSelectPaymentCellModel()
        cellMomo.title = "Chuyển vào ví Momo"
        cellMomo.isSelected = sectionModel.type == .Momo
        appendCell(cellMomo)
        
        let cellBank = DotSelectPaymentCellModel()
        cellBank.title = "Chuyển khoản ngân hàng"
        cellBank.isSelected = sectionModel.type == .Bank
        appendCell(cellBank)
        
        switch sectionModel.type {
        case .Bank:
            addBlankSpace(8, color: .clear)
            let cellTextField = TextFieldInputCellModel(content: "", placeholder: "Chọn tài khoản", type: .DropDown(.Bank))
            appendCell(cellTextField)
        case .Momo:
            addBlankSpace(8, color: .clear)
            let cellTextField = TextFieldInputCellModel(content: "", placeholder: "Chọn tài khoản", type: .DropDown(.Momo))
            appendCell(cellTextField)
        default:
            break
        }
        
        addBlankSpace(18, color: .clear)
    }
}
