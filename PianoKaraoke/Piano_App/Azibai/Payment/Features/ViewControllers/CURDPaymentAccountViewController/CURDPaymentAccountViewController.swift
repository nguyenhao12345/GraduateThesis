//
//  CURDPaymentAccountViewController.swift
//  Piano_App
//
//  Created by Azibai on 13/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

protocol CURDPaymentAccountViewControllerDelegate: class {
    func updateAccountSuccess()
}

class CURDPaymentAccountViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navView: NavigationViewPayment!
    @IBOutlet weak var bottomBtn: UIButton!

    weak var delegate: CURDPaymentAccountViewControllerDelegate?
    //MARK: Properties
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = []
    var type: CURDPaymentAccountViewController.TYPE = .Add(.Bank)
    var wallet: WalletModel?
    
    //MARK: Init
    init(wallet: WalletModel?) {
        super.init()
        self.wallet = wallet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initUIVariable() {
        super.initUIVariable()
        self.hidesNavigationbar = true
        self.hidesToolbar = true
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
    }
    
    //MARK: Momo
    lazy var scMomoAccountName: CURDPaymentInputCellSectionModel = { [weak self] in
        return CURDPaymentInputCellSectionModel(title: "Tên tài khoản *", content: self?.wallet?.account_name ?? "", placeholder: "Nhập tên", type: .Keyboard(.character))
    }()
    
    lazy var scMomoPhone: CURDPaymentInputCellSectionModel = { [weak self] in
        return CURDPaymentInputCellSectionModel(title: "Số điện thoại *", content: self?.wallet?.phone_number ?? "", placeholder: "Nhập số", type: .Keyboard(.number))
    }()
    
    lazy var scMomoEmail: CURDPaymentInputCellSectionModel = { [weak self] in
        return CURDPaymentInputCellSectionModel(title: "Email *", content: self?.wallet?.email ?? "", placeholder: "Nhập tên", type: .Keyboard(.character))
    }()
    
    //MARK: Bank
    lazy var scBankName: CURDPaymentInputCellSectionModel = { [weak self] in
        return CURDPaymentInputCellSectionModel(title: "Tên ngân hàng", content: self?.wallet?.bank_short_name ?? "", placeholder: "Chọn ngân hàng", type: .DropDown(.Bank))
    }()
    
    lazy var scBankCity: CURDPaymentInputCellSectionModel = { [weak self] in
        return CURDPaymentInputCellSectionModel(title: "Tỉnh/Thành phố", content: self?.wallet?.pre_name ?? "", placeholder: "Chọn Tỉnh/Thành phố", type: .DropDown(.City))
    }()
    
    lazy var scBankSTK: CURDPaymentInputCellSectionModel = { [weak self] in
        return CURDPaymentInputCellSectionModel(title: "Số tài khoản ngân hàng", content: self?.wallet?.account_number ?? "", placeholder: "Nhập số", type: .Keyboard(.number))
    }()
    
    lazy var scBankOwnName: CURDPaymentInputCellSectionModel = { [weak self] in
        return CURDPaymentInputCellSectionModel(title: "Tên chủ tài khoản ngân hàng", content: self?.wallet?.account_name ?? "", placeholder: "Nhập tên", type: .Keyboard(.character))
    }()
    
    //MARK: Method
    func viewIsReady() {
        
        switch type {
        case .Add(let type):
            bottomBtn.setTitle("Thêm tài khoản", for: .normal)
            setNavViewAndDataSource(prefixName: "Thêm", type: type)
        case .Edit(let type):
            bottomBtn.setTitle("Cập nhật tài khoản", for: .normal)
            setNavViewAndDataSource(prefixName: "Sửa", type: type)
        }

        
        let layout = SectionBackgroundCardViewLayoutPayment()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    func getBankNoteAtts() -> NSMutableAttributedString? {
        let att = Helper.getAttributesStringWithFontAndColor(string: "Lưu ý: \nCác thông tin về ngân hàng phải chính xác.", font: .kohoMedium14, color: .black)
        att.append(NSAttributedString(string: "Nếu bạn điền sai thông tin mà chúng tôi đã thực hiện lệnh chuyển tiền thì bạn phải chịu trách nhiệm về sai xót của mình.", attributes: [
        NSAttributedString.Key.font: UIFont.kohoMedium14,
        NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)
        ]))
        return att
    }
    
    func getMomoNoteAtts() -> NSMutableAttributedString? {
        let att = Helper.getAttributesStringWithFontAndColor(string: "Lưu ý: \nCác thông tin về Momo phải chính xác.", font: .kohoMedium14, color: .black)
        att.append(NSAttributedString(string: "Nếu bạn điền sai thông tin mà chúng tôi đã thực hiện lệnh chuyển tiền thì bạn phải chịu trách nhiệm về sai xót của mình.", attributes: [
        NSAttributedString.Key.font: UIFont.kohoMedium14,
        NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2, green: 0.2588235294, blue: 0.2980392157, alpha: 1)
        ]))
        return att
    }
    
    func setUpDataSourcesMomo() {
        dataSource = [scMomoAccountName, scMomoPhone, scMomoEmail, PaymentNoteSectionModel(att: getMomoNoteAtts())]
    }
    func setUpDataSourcesBank() {
        dataSource = [scBankName, scBankCity, scBankSTK, scBankOwnName, PaymentNoteSectionModel(att: getBankNoteAtts())]
    }
    
    func createAccountBank() {
        let param: [String: Any] = ["bank_id": scBankName.id ?? 0,
                                    "province_id": scBankCity.id ?? 0,
                                    "account_number": scBankSTK.content,
                                    "account_name": scBankOwnName.content]
            
            PaymentService.shared.createBank(param: param) { [weak self] (error) in
                if error == nil {
                    self?.delegate?.updateAccountSuccess()
                    self?.dismiss()
                } else {
                    self?.showToast(string: error ?? "Có lỗi xảy ra vui lòng thử lại!", duration: 1.5, position: .top)
                }
            }
    }
    
    func createAccountMomo() {
        let param: [String: Any] = ["digital_wallet_id": 2,
                                    "phone_number": scMomoPhone.content,
                                    "email": scMomoEmail.content,
                                    "account_name": scMomoAccountName.content]
        PaymentService.shared.createMomo(param: param) { [weak self] (error) in
            if let _error = error {
                self?.showToast(string: _error, duration: 1.5, position: .top)
            } else {
                self?.delegate?.updateAccountSuccess()
                self?.dismiss()
            }
        }
    }
    
    func updateBank() {
        guard let wallet = wallet else { return }
        
        let param: [String: Any] = ["id": wallet.id,
                                    "user_id": wallet.user_id,
                                    "bank_id": scBankName.id ?? 0,
                                    "province_id": scBankCity.id ?? 0,
                                    "account_number": scBankSTK.content,
                                    "account_name": scBankOwnName.content]
        
        PaymentService.shared.updateAccountBank(id: wallet.id, param: param) { [weak self] (error) in
            if error == nil {
                self?.delegate?.updateAccountSuccess()
                self?.dismiss()
            } else {
                self?.showToast(string: error ?? "Có lỗi xảy ra vui lòng thử lại!", duration: 1.5, position: .top)
            }
        }
    }
    
    func updateMomo() {
        guard let wallet = wallet else { return }
        
        let param: [String: Any] = ["id": wallet.id,
                                    "digital_wallet_id": 2,
                                    "user_id": wallet.user_id,
                                    "phone_number": scMomoPhone.content,
                                    "email": scMomoEmail.content,
                                    "account_name": scMomoAccountName.content]
        PaymentService.shared.updateAccountMomo(id: wallet.id, param: param) { [weak self] (error) in
            if let _error = error {
                self?.showToast(string: _error, duration: 1.5, position: .top)
            } else {
                self?.delegate?.updateAccountSuccess()
                self?.dismiss()
            }
        }
    }
    
    @IBAction func clickBottomButton(_ sender: Any?) {
        switch type {
        case .Add(let type):
            switch type {
            case .Bank: createAccountBank()
            case .Momo: createAccountMomo()
            }
        case .Edit(let type):
            switch type {
            case .Bank: updateBank()
            case .Momo: updateMomo()
            }
        }
    }
    
    func setNavViewAndDataSource(prefixName: String, type: AccountPaymentSectionModel.TYPE) {
        switch type {
        case .Momo:
            navView.config(title: "\(prefixName) tài khoản MoMo")
            setUpDataSourcesMomo()
        case .Bank:
            navView.config(title: "\(prefixName) tài khoản Ngân hàng")
            setUpDataSourcesBank()
        }
    }
        
}

//MARK: ListAdapterDataSource
extension CURDPaymentAccountViewController: ListAdapterDataSource {
    
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

extension CURDPaymentAccountViewController {
    enum TYPE {
        case Add(AccountPaymentSectionModel.TYPE)
        case Edit(AccountPaymentSectionModel.TYPE)
    }
}
