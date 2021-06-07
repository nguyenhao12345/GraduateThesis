//
//  ManagerPaymentSectionFactory.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import Foundation

class ManagerPaymentSectionFactory: NSObject {
    var filter: PaymentFilterHistory = PaymentFilterHistory(field1: .All, time: .ThirtyDay, minMoney: 0, maxMoney: 0)

    enum TYPE {
        case Real
        case Provisional
        case History
        case MoneyRecevingAccount
        case None
        var nameString: String {
            switch self {
            case .Real: return "Thực có"
            case .Provisional: return "Tạm tính"
            case .History: return "Lịch sử"
            case .MoneyRecevingAccount: return "Tài khoản nhận tiền"
            case .None: return ""
            }
        }
    }
    
    func getListType() -> [ManagerPaymentSectionFactory.TYPE] {
        return [.Real, .Provisional, .History, .MoneyRecevingAccount]
    }
    
    func getSectionsController(type: ManagerPaymentSectionFactory.TYPE, currentPage: Int? = nil, fromDate: Double? = nil, endDate: Double?  = nil, completion: @escaping ([AziBaseSectionModel])->()) {
        switch type {
        case .Real:
            getSectionsReal(currentPage: currentPage, completion: completion)
        case .Provisional:
            getSectionsProvisional(currentPage: currentPage, completion: completion)
        case .History:
            guard let currentPage = currentPage,
                let fromDate = fromDate,
                let endDate = endDate else { return }
            getSectionsHistory(currentPage: currentPage,
                               fromDate: fromDate, endDate: endDate,
                               completion: completion)
        case .MoneyRecevingAccount:
            guard let currentPage = currentPage else { return }
            getSectionsMoneyRecevingAccount(currentPage: currentPage, completion: completion)
        case .None:
            break
        }
        
    }
    
    private func getSectionsReal(currentPage: Int? = nil, completion: @escaping ([AziBaseSectionModel])->()) {
        let sumMoneyRealSection = SimpleShowSumMoneySectionModel(name: SimpleShowSumMoneySectionModel.Name.TotalAvailableBalance, money: 10000, index: 0, isHiddenButton: false, isHightLight: true)

        if currentPage == 1 {
            PaymentService.shared.getSumMoneyReal { (value) in
                sumMoneyRealSection.money = value
                sumMoneyRealSection.sectionController?.updateSection(animated: false)
                completion([                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel()
                ])
            }
            
            completion([
                sumMoneyRealSection,
                SearchDatePaymentSectionModel(type: .History)
            ])
        }
    }
    
    private func getSectionsProvisional(currentPage: Int? = nil, completion: @escaping ([AziBaseSectionModel])->()) {
        if currentPage ?? 0 > 1 {
            return
        }
        PaymentService.shared.getDataManagerTabProvisional { (notional_incom_total, notional_shop_income, notional_commission_ctv_azibai, notional_commission_ctv_shop, notional_consignment) in
            completion([
                SimpleShowSumMoneySectionModel(name: SimpleShowSumMoneySectionModel.Name.TotalProvisionalBalance, money: notional_incom_total, index: 0, isHiddenButton: true),
                SimpleShowSumMoneySectionModel(name: SimpleShowSumMoneySectionModel.Name.RevenueFromStores, money: notional_shop_income, index: 1),
                SimpleShowSumMoneySectionModel(name: SimpleShowSumMoneySectionModel.Name.CollectedFromPartnerAzibai, money: notional_commission_ctv_azibai, index: 2),
                SimpleShowSumMoneySectionModel(name: SimpleShowSumMoneySectionModel.Name.CollectedFromCollaborators, money: notional_commission_ctv_shop, index: 3),
                SimpleShowSumMoneySectionModel(name: SimpleShowSumMoneySectionModel.Name.CollectFromConsignment, money: notional_consignment, index: 4)
            ])
        }
    }
    
    private func getSectionsHistory(currentPage: Int, fromDate: Double?, endDate: Double?, completion: @escaping ([AziBaseSectionModel])->()) {
        if currentPage == 1 {
            completion([
                SearchDatePaymentSectionModel(type: .Search),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel()
            ])
        } else {
            completion([
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel(),
                HistoryPaymentSectionModel()
            ])

        }
    }
    
    private func getSectionsMoneyRecevingAccount(currentPage: Int, completion: @escaping ([AziBaseSectionModel])->()) {
        var sections: [AziBaseSectionModel] = []
        if currentPage == 1 {
            sections.append(AddAccountPaymentSectionModel())
        }
        PaymentService.shared.getWallets(page: currentPage) { (models) in
            sections.append(contentsOf: models.map({ AccountPaymentSectionModel(wallet: $0 )}))
            completion(sections)
        }
    }
}
