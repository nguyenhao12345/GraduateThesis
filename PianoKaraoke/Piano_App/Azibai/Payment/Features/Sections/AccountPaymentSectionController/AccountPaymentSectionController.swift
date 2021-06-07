//
//  AccountPaymentSectionController.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol AccountPaymentSectionDelegate: class {
    func delete(section: AziBaseSectionModel)
}

class AccountPaymentSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    enum TYPE {
        case Momo
        case Bank
    }
    var wallet: WalletModel?
    
    init(wallet: WalletModel?) {
        self.wallet = wallet
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return AccountPaymentSectionController()
    }
}

class AccountPaymentSectionController: SectionController<AccountPaymentSectionModel> {
    
    weak var delegate: AccountPaymentSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? AccountPaymentSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return AccountPaymentCellBuilder()
    }

}

extension AccountPaymentSectionController: AccountPaymentCellDelegate {
    func edit() {
        guard let type = sectionModel?.wallet?._type else { return }
        AppRouter.shared.gotoPaymentCURD(viewController: viewController!, type: .Edit(type), walletModel: sectionModel?.wallet)
    }
    
    func remove() {
        guard let wallet = sectionModel?.wallet else { return }
        switch wallet._type {
        case .Bank:
            PaymentService.shared.deleteBank(id: wallet.id, param: [:]) { [weak self] (error) in
                if let _error = error {
                    self?.viewController?.showToast(string: _error, duration: 1.5, position: .top)
                } else {
                    self?.delegate?.delete(section: self!.sectionModel!)
                }
            }
        case .Momo:
            PaymentService.shared.deleteWallet(id: wallet.id, param: [:]) { [weak self] (error) in
                if let _error = error {
                    self?.viewController?.showToast(string: _error, duration: 1.5, position: .top)
                } else {
                    self?.delegate?.delete(section: self!.sectionModel!)
                }
            }
        }
    }
    
}

class AccountPaymentCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? AccountPaymentSectionModel else { return }
        switch sectionModel.wallet?._type {
        case .Bank:
            buildBankCells(sectionModel: sectionModel)
        case .Momo:
            buildMomoCells(sectionModel: sectionModel)
        case .none:
            break
        }
    }
    
    func buildBankCells(sectionModel: AccountPaymentSectionModel) {
        addBlankSpace(20, width: Const.widthScreens, color: .clear)
        let cell0 = AccountPaymentCellModel(attTitle: Helper.getAttributesStringWithFontAndColor(string: "Ngân hàng", font: .kohoMedium14, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)),
                                            attContent: Helper.getAttributesStringWithFontAndColor(string: sectionModel.wallet?.bank_short_name ?? "", font: .kohoMedium14, color: #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)),
                                            isHiddenBtn: false)
        appendCell(cell0)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)
        let cell1 = AccountPaymentCellModel(attTitle: Helper.getAttributesStringWithFontAndColor(string: "Tài khoản", font: .kohoMedium14, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)),
                                            attContent: Helper.getAttributesStringWithFontAndColor(string: sectionModel.wallet?.account_number ?? "", font: .kohoMedium14, color: #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)),
                                            isHiddenBtn: true)
        appendCell(cell1)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)
        let cell2 = AccountPaymentCellModel(attTitle: Helper.getAttributesStringWithFontAndColor(string: "Chủ tài khoản", font: .kohoMedium14, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)),
                                            attContent: Helper.getAttributesStringWithFontAndColor(string: sectionModel.wallet?.account_name ?? "", font: .kohoMedium14, color: #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)),
                                            isHiddenBtn: true)
        appendCell(cell2)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)
        
        let cell3 = AccountPaymentCellModel(attTitle: Helper.getAttributesStringWithFontAndColor(string: "Tỉnh/Thành Phố", font: .kohoMedium14, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)),
                                            attContent: Helper.getAttributesStringWithFontAndColor(string: sectionModel.wallet?.pre_name ?? "", font: .kohoMedium14, color: #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)),
                                            isHiddenBtn: true)
        appendCell(cell3)
        addBlankSpace(20, width: Const.widthScreens, color: .clear)
    }
    
    func buildMomoCells(sectionModel: AccountPaymentSectionModel) {
        addBlankSpace(20, width: Const.widthScreens, color: .clear)
        let cell0 = AccountPaymentCellModel(attTitle: Helper.getAttributesStringWithFontAndColor(string: "Tài khoản", font: .kohoMedium14, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)),
                                            attContent: Helper.getAttributesStringWithFontAndColor(string: sectionModel.wallet?.phone_number ?? "", font: .kohoMedium14, color: #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)),
                                            isHiddenBtn: false)
        appendCell(cell0)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)
        let cell1 = AccountPaymentCellModel(attTitle: Helper.getAttributesStringWithFontAndColor(string: "Chủ tài khoản", font: .kohoMedium14, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)),
                                            attContent: Helper.getAttributesStringWithFontAndColor(string: sectionModel.wallet?.account_name ?? "", font: .kohoMedium14, color: #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)),
                                            isHiddenBtn: true)
        appendCell(cell1)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)
        let cell2 = AccountPaymentCellModel(attTitle: Helper.getAttributesStringWithFontAndColor(string: "Email", font: .kohoMedium14, color: #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)),
                                            attContent: Helper.getAttributesStringWithFontAndColor(string: sectionModel.wallet?.email ?? "", font: .kohoMedium14, color: #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)),
                                            isHiddenBtn: true)
        appendCell(cell2)
        addBlankSpace(20, width: Const.widthScreens, color: .clear)
    }
}
