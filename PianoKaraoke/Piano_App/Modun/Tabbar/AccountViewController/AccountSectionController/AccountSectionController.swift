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
            AppRouter.shared.gotoPianoPractice(viewController: viewController)
        case .ChangePass:
            guard let viewController = viewController else { return }
            AppRouter.shared.gotoResetPassWord(viewController: viewController)
        case .LocalSongs:
            guard let viewController = viewController else { return }
            AppRouter.shared.gotoLocalSongs(viewController: viewController)
        case .ChangeColor:
            AppRouter.shared.gotoChangeColor(viewController: viewController, delegate: self)
        case .TestVoice:
            let vc = ViewController()
            self.viewController?.present(vc, withNavigation: false)
        case .InfoSupport:
            break
        case .Rule:
            let vc = EffectsViewController()
            self.viewController?.present(vc, withNavigation: false)
        case .Login:
            break
        case .Logout:
            guard let viewController = viewController else { return }
            viewController.showDialogBottom(title: nil, message: "Bạn có chắc chắn muốn đăng xuất không?", buttonTitles: ["Có"], highlightedButtonIndex: nil) { (index) in
                if index == 0 {
                    REALM_HELPER.deleteDatabase()
                    AppRouter.shared.gotoLogin(viewController: viewController)
                }
            }
        case .ChangeInfoUser:
            guard let viewController = viewController,
                let uidUser = AppAccount.shared.getUserLogin()?.uid else { return }
            AppRouter.shared.gotoEditInfoUser(uidUser: uidUser, viewController: viewController)
        case .InfoUser:
            guard let viewController = viewController,
                let uidUser = AppAccount.shared.getUserLogin()?.uid else { return }
            AppRouter.shared.gotoInfoUser(uidUser: uidUser, viewController: viewController)
        case .SearchYoutube:
            guard let viewController = viewController else { return }
            AppRouter.shared.gotoSearchSongYoutube(viewController: viewController)
        case .NONE:
            break
        case .ActiveKey:
            viewController?.showAlert(title: "Key Youtube", message: "", buttonTitles: keyAPIYoube, highlightedButtonIndex: nil) { (index) in
                currentKeyAPIYoube = keyAPIYoube[index]
                YoutubeKit.shared.setAPIKey(currentKeyAPIYoube)
            }
        case .ManagerUser:
            AppRouter.shared.gotoManagerUser(viewController: viewController)
        default:
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

        if AppAccount.shared.getUserLogin()?.admin == 1 {
            let cellManagerUser = DefaultIconTextCellModel(att:  Helper.getAttributesStringWithFontAndColor(string: "Quản lý thành viên", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "icons8-member-skin-type-7-48", type: .ManagerUser)
            appendCell(cellManagerUser)
            addSingleLine(true)
            
            let cellKey = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Mở khoá", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "door-white-key", type: .ActiveKey)
            appendCell(cellKey)
            addSingleLine(true)
            
            let cellTestVoice = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Test Voice", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "infoIc", type: .TestVoice)
            appendCell(cellTestVoice)
            addSingleLine(true)
            
            let cellInfoSupport2 = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "ViewController2", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "infoIc", type: .Rule)
            appendCell(cellInfoSupport2)
            addSingleLine(true)
        }
        
        let cellInfoSupport = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Thông tin về chúng tôi", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "infoIc", type: .InfoSupport)
        appendCell(cellInfoSupport)
        addSingleLine(true)
        
        let cellLogout = DefaultIconTextCellModel(att: Helper.getAttributesStringWithFontAndColor(string: "Đăng xuất", font: .HelveticaNeueMedium18, color: .defaultText), iconStr: "ic_admin_logout", type: .Logout)
        appendCell(cellLogout)

    }
}
