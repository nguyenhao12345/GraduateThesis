//
//  PaymentFilterHistoryViewController.swift
//  Piano_App
//
//  Created by Azibai on 04/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

protocol PaymentFilterHistoryViewControllerDelegate: class {
    func updateFilter(filter: PaymentFilterHistory)
}

class PaymentFilterHistoryViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navView: NavigationViewPayment!
    var filter: PaymentFilterHistory!
    //MARK: Properties
    private var isFetchingMore: Bool = false
    weak var delegate: PaymentFilterHistoryViewControllerDelegate?
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = []
    
    lazy var sectionDate: PaymentFilterDateSectionModel = {
        let sc = PaymentFilterDateSectionModel(filter: filter)
        switch filter.time {
        case .ThirtyDay, .SevenDay:
            sc.isShow = false
        case .Some(let startDate, let endDate):
            sc.isShow = true
        }
        return sc
    }()
    
    lazy var sectionOption1: PaymentFilterBlockSectionModel = {
        let sc = PaymentFilterBlockSectionModel(filter: filter.field1, title: "Lọc giao dịch theo")
        return sc
    }()
    
    lazy var sectionOption2: PaymentFilterBlockSectionModel = {
        let sc = PaymentFilterBlockSectionModel(filter: filter.time, title: "Thời gian")
        return sc
    }()
    
    lazy var sectionMinValue: CURDPaymentInputCellSectionModel = {
        let str: String = filter.minMoney == 0 ? "": String(filter.minMoney)
        let sc = CURDPaymentInputCellSectionModel(title: "Tối thiểu", content: str, placeholder: "Nhập số", type: .Keyboard(.number))
        return sc
    }()
    
    lazy var sectionMaxValue: CURDPaymentInputCellSectionModel = {
        let str: String = filter.maxMoney == 0 ? "": String(filter.maxMoney)
        let sc = CURDPaymentInputCellSectionModel(title: "Tối đa", content: str, placeholder: "Nhập số", type: .Keyboard(.number))
        return sc
    }()
    //MARK: Init
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = [sectionOption1,
                      sectionOption2,
                      sectionDate,
                      sectionMinValue,
                      sectionMaxValue]
        viewIsReady()
    }
    
    //MARK: Method
    func viewIsReady() {
        navView.config(title: "Lịch sử giao dịch")
        navView.delegate = self
        let layout = SectionBackgroundCardViewLayoutPayment()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    
    func updatefilter() {
        guard let filter = filter else { return }
        let time = sectionOption2.filter
        
        if let option1 = sectionOption1.filter as? PaymentFilterHistory.Field1Option {
            filter.field1 = option1
        }
        
        switch time.name {
        case PaymentFilterHistory.TimeOption.ThirtyDay.name:
            filter.time = PaymentFilterHistory.TimeOption.ThirtyDay
        case PaymentFilterHistory.TimeOption.SevenDay.name:
            filter.time = PaymentFilterHistory.TimeOption.SevenDay
        case PaymentFilterHistory.TimeOption.Some(startDate: "", endDate: "").name:
            filter.time = sectionDate.filter.time
        default:
            break
        }
        
        filter.minMoney = NumberFormatter().number(from: sectionMinValue.content)?.doubleValue ?? 0
        filter.maxMoney = NumberFormatter().number(from: sectionMaxValue.content)?.doubleValue ?? 0
    }
}

//MARK: ListAdapterDataSource
extension PaymentFilterHistoryViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return sectionBuilder.getSection(object: object, presenter: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension PaymentFilterHistoryViewController: PaymentFilterBlockSectionDelegate {
    func showSectionFilter() {
        sectionDate.isShow = true
        sectionDate.sectionController?.updateSection(animated: true)
    }
    
    func hiddenSectionFilter() {
        sectionDate.isShow = false
        sectionDate.sectionController?.updateSection(animated: true)
    }
}

extension PaymentFilterHistoryViewController: NavigationViewPaymentDelegate {
    func selectedAt(index: Int) {
        
    }
    
    func selectedAt(typeSection: ManagerPaymentSectionFactory.TYPE) {
        
    }
    
    func clickBack() {
        guard let filter = filter else { return }
        updatefilter()
        delegate?.updateFilter(filter: filter)
    }
}


extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())

        var arrDates = [String]()

        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd--MM--yyyy"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
}
