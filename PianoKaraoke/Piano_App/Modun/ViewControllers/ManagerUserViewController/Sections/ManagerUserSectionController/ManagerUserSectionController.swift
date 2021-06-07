//
//  ManagerUserSectionController.swift
//  Piano_App
//
//  Created by Azibai on 23/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol ManagerUserSectionDelegate: class {
    func remove(sectionModel: AziBaseSectionModel)
}

class ManagerUserSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    var userModel: UserModel!
    
    init(userModel: UserModel) {
        self.userModel = userModel
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return ManagerUserSectionController()
    }
}

class ManagerUserSectionController: SectionController<ManagerUserSectionModel> {
    
    weak var delegate: ManagerUserSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? ManagerUserSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return ManagerUserCellBuilder()
    }

}
extension ManagerUserSectionController: UserInfoManagerCellDelegate {
    func remove() {
        delegate?.remove(sectionModel: sectionModel!)
    }
    
}
class ManagerUserCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? ManagerUserSectionModel else { return }
        let cell = UserInfoManagerCellModel()
        cell.userModel = sectionModel.userModel
        appendCell(cell)
    }
}
