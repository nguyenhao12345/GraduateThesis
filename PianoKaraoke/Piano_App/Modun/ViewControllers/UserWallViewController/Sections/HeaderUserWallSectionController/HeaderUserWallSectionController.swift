//
//  HeaderUserWallSectionController.swift
//  Piano_App
//
//  Created by Azibai on 31/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import IGListKit
import Mapper

protocol HeaderUserWallSectionDelegate: class {
    
}

class HeaderUserWallSectionModel: AziBaseSectionModel {
    var uidUser: String = ""
    var userModel: UserModel? = nil
    init(uidUser: String = "") {
        self.uidUser = uidUser
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return HeaderUserWallSectionController()
    }
}

class HeaderUserWallSectionController: SectionController<HeaderUserWallSectionModel> {
    
    weak var delegate: HeaderUserWallSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? HeaderUserWallSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return HeaderUserWallCellBuilder()
    }
    
    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        fetchData()
    }
    
    func fetchData() {
        guard let uid = sectionModel?.uidUser else { return }
        ServiceOnline.share.getDataUser(uid: uid) { (data) in
            LOADING_HELPER.dismiss()
            guard let data = data as? [String: Any] else { return }
            self.sectionModel?.userModel = UserModel(data: data)
            self.updateSection(animated: true)
            if let viewController = self.viewController as? UserWallViewController {
                viewController.titleNameLbl.text = self.sectionModel?.userModel?.name
            }
        }
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        if let viewController = viewController as? UserWallViewController {
            viewController.titleNameLbl.isHidden = false
        }
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        if let viewController = viewController as? UserWallViewController {
            viewController.titleNameLbl.isHidden = true
        }
    }

}

class HeaderUserWallCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? HeaderUserWallSectionModel else { return }
        addBlankSpace(12, width: Const.widthScreens, color: .clear)
        let cell = HeaderUserWallCellModel()
        cell.user = sectionModel.userModel
        appendCell(cell)
//        addBlankSpace(12, width: Const.widthScreens, color: .clear)
    }
}
