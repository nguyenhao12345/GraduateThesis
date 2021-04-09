//
//  InfoUserSectionController.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol InfoUserSectionDelegate: class {
    
}

class InfoUserSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    
    var userModel: UserModel?
    var isEdit: Bool = false
    init(userModel: UserModel?, isEdit: Bool = false) {
        self.userModel = userModel
        self.isEdit = isEdit
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return InfoUserSectionController()
    }
}

class InfoUserSectionController: SectionController<InfoUserSectionModel> {
    
    weak var delegate: InfoUserSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? InfoUserSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return InfoUserCellBuilder()
    }

}

class InfoUserCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? InfoUserSectionModel else { return }
        buildUserInfo(sectionModel: sectionModel)
    }
    
    func buildDetailUser(sectionModel: InfoUserSectionModel) {
        if sectionModel.isEdit {
            addBlankSpace(1, width: Const.widthScreens, color: .clear)
            addEditButtonRight()
        }
        addBlankSpace(18, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Chi tiết về \(sectionModel.userModel?.name ?? "")", font: .HelveticaNeueBold16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 1)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)

        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Họ tên:  \(sectionModel.userModel?.name ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)
        
        addBlankSpace(8, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Tên gọi khác: \(sectionModel.userModel?.infoIntro ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)

        var sex: String = ""
        if sectionModel.userModel?.sex == 0 {
            sex = "Chưa xác định"
        }
        if sectionModel.userModel?.sex == 1 {
            sex = "Nam"
        }
        if sectionModel.userModel?.sex == -1 {
            sex = "Nữ"
        }
        addBlankSpace(8, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Giới tính: \(sex)", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)

        addBlankSpace(8, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Ngày sinh: \(sectionModel.userModel?.birth ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)


        addBlankSpace(18, width: Const.widthScreens, color: .clear)
    }
    
    func buildUserInfo(sectionModel: InfoUserSectionModel) {
        if sectionModel.isEdit {
            addBlankSpace(1, width: Const.widthScreens, color: .clear)
            addEditButtonRight()
        }
        addBlankSpace(18, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Thông tin liên hệ", font: .HelveticaNeueBold16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 1)
        
        addBlankSpace(12, width: Const.widthScreens, color: .clear)
        
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Email: \(sectionModel.userModel?.email ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)
        
        addBlankSpace(8, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Phone: \(sectionModel.userModel?.phone ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)

        addBlankSpace(18, width: Const.widthScreens, color: .clear)

    }
    
    func buildUserLocation(sectionModel: InfoUserSectionModel) {
        if sectionModel.isEdit {
            addBlankSpace(1, width: Const.widthScreens, color: .clear)
            addEditButtonRight()
        }
        addBlankSpace(18, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Những nơi \(sectionModel.userModel?.name ?? "") sống", font: .HelveticaNeueBold16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 1)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)

        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Nơi sống: \(sectionModel.userModel?.address ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)
        
        addBlankSpace(8, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Quê quán: \(sectionModel.userModel?.homeTown ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)


        addBlankSpace(18, width: Const.widthScreens, color: .clear)

    }
    
    func buildUserEducation(sectionModel: InfoUserSectionModel) {
        if sectionModel.isEdit {
            addBlankSpace(1, width: Const.widthScreens, color: .clear)
            addEditButtonRight()
        }
        addBlankSpace(18, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Học vấn", font: .HelveticaNeueBold16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 1)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)

        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Từng học tại: \(sectionModel.userModel?.education ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)
        addBlankSpace(18, width: Const.widthScreens, color: .clear)

    }
    
    func buildUserJob(sectionModel: InfoUserSectionModel) {
        if sectionModel.isEdit {
            addBlankSpace(1, width: Const.widthScreens, color: .clear)
            addEditButtonRight()
        }
        addBlankSpace(18, width: Const.widthScreens, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Công việc", font: .HelveticaNeueBold16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 1)
        addBlankSpace(12, width: Const.widthScreens, color: .clear)
        
        addSimpleText(Helper.getAttributesStringWithFontAndColor(string: "Đang làm việc tại: \(sectionModel.userModel?.job ?? "")", font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 32, truncationString: nil, numberOfLine: 0)

        addBlankSpace(18, width: Const.widthScreens, color: .clear)
    }

}
