//
//  SimpleShowSumMoneySectionController.swift
//  Piano_App
//
//  Created by Azibai on 09/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol SimpleShowSumMoneySectionDelegate: class {
    
}

class SimpleShowSumMoneySectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    
    enum Name {
        static let TotalAvailableBalance: String = "Tổng số dư khả dụng"
        static let TotalProvisionalBalance: String = "Tổng số dư tạm tính"
        static let RevenueFromStores: String = "Doanh thu từ cửa hàng"
        static let CollectedFromPartnerAzibai: String = "Thu thập từ đối tác Azibai"
        static let CollectedFromCollaborators: String = "Thu thập từ cộng tác viên"
        static let CollectFromConsignment: String = "Thu thập từ nhận ký gửi"
    }
    
    var name: String = ""
    var money: Double = 0.0
    var index: Int = 0
    var isHiddenButton: Bool = true
    var isHightLight: Bool = false
    init(name: String, money: Double, index: Int, isHiddenButton: Bool = false, isHightLight: Bool = false) {
        self.name = name
        self.money = money
        self.index = index
        self.isHiddenButton = isHiddenButton
        self.isHightLight = isHightLight
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return SimpleShowSumMoneySectionController()
    }
}

class SimpleShowSumMoneySectionController: SectionController<SimpleShowSumMoneySectionModel> {
    
    weak var delegate: SimpleShowSumMoneySectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? SimpleShowSumMoneySectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return SimpleShowSumMoneyCellBuilder()
    }
    
    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        inset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
    }

}
extension SimpleShowSumMoneySectionController: ShowSumMoneyCellDelegate {
    func clickDrawMoney() {
        AppRouter.shared.gotoPaymentWithDrawMoney(viewController: viewController!)
    }
    
    func clickViewDetail() {
        switch sectionModel?.name ?? "" {
        case SimpleShowSumMoneySectionModel.Name.TotalAvailableBalance:
            AppRouter.shared.gotoPaymentTotalAvailableBalance(viewController: viewController!)
        case SimpleShowSumMoneySectionModel.Name.RevenueFromStores:
            AppRouter.shared.gotoPaymentRevenueFromStores(viewController: viewController!)
        case SimpleShowSumMoneySectionModel.Name.CollectedFromPartnerAzibai:
            AppRouter.shared.gotoPaymentFromPartnerAzibai(viewController: viewController!)
        case SimpleShowSumMoneySectionModel.Name.CollectedFromCollaborators:
            AppRouter.shared.gotoPaymentCollectedFromCollaborators(viewController: viewController!)
        case SimpleShowSumMoneySectionModel.Name.CollectFromConsignment:
            AppRouter.shared.gotoPaymentCollectFromConsignment(viewController: viewController!)
        default:
            break
        }
    }
    
    
}

class SimpleShowSumMoneyCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? SimpleShowSumMoneySectionModel else { return }
//        addBlankSpace(12, color: .clear)

        if sectionModel.isHightLight {
            let cell = ShowSumMoneyHightLightCellModel()
            cell.moneyStr = sectionModel.money.toMoney() + "đ"
            cell.title = sectionModel.name
            appendCell(cell)
        } else {
            let cell = ShowSumMoneyCellModel()
            cell.moneyStr = sectionModel.money.toMoney() + "đ"
            cell.title = sectionModel.name
            cell.isHiddenButton = sectionModel.isHiddenButton
            appendCell(cell)
        }
    }

}
