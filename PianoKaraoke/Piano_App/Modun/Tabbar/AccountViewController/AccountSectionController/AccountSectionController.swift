//
//  AccountSectionController.swift
//  Piano_App
//
//  Created by Azibai on 24/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import YoutubeKit
import RealmSwift
protocol AccountSectionDelegate: class {
    
}

class AccountSectionModel: AziBaseSectionModel {
    
    override init() {
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return AccountSectionController()
    }
}

class AccountSectionController: SectionController<AccountSectionModel>, ChangeColorAppDelegate {
    func updateColor(hex: String) {
        AppColor.shared.colorBackGround.accept(hex)
    }
    
    weak var delegate: AccountSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? AccountSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return AccountCellBuilder()
    }

    override func didSelectItem(at index: Int) {
        guard let cellDefault = cellModels[index] as? DefaultIconTextCellModel else { return }
        switch cellDefault.type {
        case .Practice:
            if #available(iOS 13.0, *) {
                let vc = PianoPracticeViewController()
                isDarkSoftUIView = true
                vc.modalPresentationStyle = .overFullScreen
                viewController?.present(vc, animated: true, completion: nil)
            } else {
                break
                // Fallback on earlier versions
            }
        case .ChangePass:
            let vc = ResetPasswdViewController()
            vc.modalPresentationStyle = .overFullScreen
            viewController?.present(vc, animated: false, completion: nil)

        case .LocalSongs:
            let vc = LocalSongsViewController()
            viewController?.navigationController?.push(vc, animation: true)
        case .ChangeColor:
            let vc = ChangeColorAppViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.delegate = self
            viewController?.present(vc, animated: false, completion: nil)
        case .InfoSupport:
            break
        case .Rule:
            break
        case .Login:
            break
        case .Logout:
            REALM_HELPER.deleteDatabase()
            let vc = AuthenticateViewController()
            vc.modalPresentationStyle = .overFullScreen
            viewController?.present(vc, animated: true, completion: nil)
        case .ChangeInfoUser:
            break
        case .InfoUser:
            guard let cell1 = cellModels.filter({ $0 is UserAccountCellModel}).first as? UserAccountCellModel,
            let cellView = cell1.getCellView() as? UserAccountCell else { return }
            let vc = InfoUserViewController()
            vc.frameImageLast = cellView.avataImg.globalFrame ?? .zero
            vc.modalPresentationStyle = .overFullScreen
            viewController?.present(vc, animated: false, completion: nil)
        case .SearchYoutube:
            let vc = SearchSongYoutubeViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            viewController?.present(vc, animated: true, completion: nil)
        case .NONE:
            break
        case .ActiveKey:
            viewController?.showAlert(title: "Key Youtube", message: "", buttonTitles: keyAPIYoube, highlightedButtonIndex: nil) { (index) in
                currentKeyAPIYoube = keyAPIYoube[index]
                YoutubeKit.shared.setAPIKey(currentKeyAPIYoube)
            }
        @unknown default:
            break
        }
    }
}

class AccountCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        let userCell = UserAccountCellModel()
        appendCell(userCell)
        addSingleLine(true)

        let cellInfoUser = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Thông tin tài khoản", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "ic_admin_generalInfo", type: .InfoUser)
        appendCell(cellInfoUser)
        addSingleLine(true)
        
        let cellChangeInfoUser = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Đổi thông tin cá nhân", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "Users-Change-User-icon", type: .ChangeInfoUser)
        appendCell(cellChangeInfoUser)
        addSingleLine(true)

        let cellChangePass = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Đổi mật khẩu", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "change-password", type: .ChangePass)
        appendCell(cellChangePass)
        addSingleLine(true)

        let cellChangeColor = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Đổi màu App", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "color-plate", type: .ChangeColor)
        appendCell(cellChangeColor)
        addSingleLine(true)

        let cellLocalSong = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Đã tải xuống", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "—Pngtree—file download icon_4719240", type: .LocalSongs)
        appendCell(cellLocalSong)
        addSingleLine(true)
        
        let cellPractice = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Luyện tập", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "piano-icon-png-14", type: .Practice)
        appendCell(cellPractice)
        addSingleLine(true)

//        let cellSearchYoutube = DefaultIconTextCellModel(att:  Helper.getAttributesStringWithFontAndColor(string: "Tìm kiếm", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "search_icon_groupshop", type: .SearchYoutube)
//        appendCell(cellSearchYoutube)
//        addSingleLine(true)

        let cellKey = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Mở khoá", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "door-white-key", type: .ActiveKey)
        appendCell(cellKey)
        addSingleLine(true)
        
        let cellInfoSupport = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Thông tin về chúng tôi", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "infoIc", type: .InfoSupport)
        appendCell(cellInfoSupport)
        addSingleLine(true)

        let cellLogout = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Đăng xuất", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "ic_admin_logout", type: .Logout)
        appendCell(cellLogout)

    }
}
