//
//  WithDrawalMoneyViewController.swift
//  Piano_App
//
//  Created by Azibai on 14/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class WithDrawalMoneyViewController: AziBaseViewController {
    enum TypeWithDrawal {
        case Bank(Int)
        case Wallet(Int)
    }
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navView: NavigationViewPayment!
    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = []
    var moneyWithDrawal: Double = 0
    var type: TypeWithDrawal = .Bank(0)
    
    let transferFees: Double = 11000
    override func initUIVariable() {
        super.initUIVariable()
        self.hidesNavigationbar = true
        self.hidesToolbar = true
    }
    
    func getNoteAtts() -> NSMutableAttributedString? {
        let att = Helper.getAttributesStringWithFontAndColor(string: "Lưu ý: \n", font: .kohoMedium14, color: .black)
        att.append(NSAttributedString(string: "Số tiền rút phải lớn hơn hoặc bằng 100.000 VND và nhỏ hơn hoặc bằng số dư khả dụng. Các thông tin về ngân hàng phải chính xác. Nếu bạn điền sai thông tin, mà chúng tôi đã thực hiện lệnh chuyển tiền thì bạn phải chịu phí chuyển tiền của ngân hàng.", attributes: [
        NSAttributedString.Key.font: UIFont.kohoMedium14,
        NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)
        ]))
        return att
    }
    lazy var scSumRealMoney: SimpleShowSumMoneySectionModel = {
        return SimpleShowSumMoneySectionModel(name: "Số dư tài khoản", money: 0, index: 0, isHiddenButton: true, isHightLight: false)
    }()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [
            scSumRealMoney,
            MethodReceiveMoneySectionModel(),
            MoneyNeedWithDrawalSectionModel(),
            PaymentNoteSectionModel(att: getNoteAtts())
        ]
        viewIsReady()
        navView.config(title: "Rút tiền")
        PaymentService.shared.getSumMoneyReal { [weak self] (value) in
            self?.scSumRealMoney.money = value
            self?.scSumRealMoney.sectionController?.updateSection(animated: false)
        }
    }
    
    //MARK: Method
    func viewIsReady() {
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        let layout = SectionBackgroundCardViewLayoutPayment()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    @IBAction func clickWithDrawalMoney(_ sender: Any?) {
        if moneyWithDrawal + transferFees > scSumRealMoney.money {
            self.showToast(string: "Tổng tiền rút phải nhỏ hơn Số dư tài khoản", duration: 2, position: .top)
        } else {
            var param: [String: Any] = ["amount": moneyWithDrawal]
            switch type {
            case .Bank(let id): param["bank_card_id"] = id
            case .Wallet(let id): param["wallet_account_id"] = id
            }
            PaymentService.shared.requestWithDrawalMoney(param: param)
        }
    }
    
}

//MARK: ListAdapterDataSource
extension WithDrawalMoneyViewController: ListAdapterDataSource {
    
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

extension WithDrawalMoneyViewController: MethodReceiveMoneySectionDelegate {
    func updateTypeWithDrawal(type: WithDrawalMoneyViewController.TypeWithDrawal) {
        self.type = type
    }
}

extension WithDrawalMoneyViewController: MoneyNeedWithDrawalSectionDelegate {
    func updateNumberMoneyWithDrawal(double: Double) {
        self.moneyWithDrawal = double
    }
}
