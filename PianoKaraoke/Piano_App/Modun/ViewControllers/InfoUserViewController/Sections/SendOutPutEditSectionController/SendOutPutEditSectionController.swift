//
//  SendOutPutEditSectionController.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol SendOutPutEditSectionDelegate: class {
    func done()
    func cancel()
}

class SendOutPutEditSectionModel: AziBaseSectionModel {
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
        return SendOutPutEditSectionController()
    }
}

class SendOutPutEditSectionController: SectionController<SendOutPutEditSectionModel> {
    
    weak var delegate: SendOutPutEditSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? SendOutPutEditSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return SendOutPutEditCellBuilder()
    }

}
extension SendOutPutEditSectionController: SendOutPutEditCellDelegate {
    func done() {
        delegate?.done()
    }
    
    func cancel() {
        delegate?.cancel()
    }
}

class SendOutPutEditCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? SendOutPutEditSectionModel else { return }
        if sectionModel.isEdit {
            addBlankSpace(12, width: Const.widthScreens, color: .clear)
            let cell = SendOutPutEditCellModel()
            appendCell(cell)
            addBlankSpace(12, width: Const.widthScreens, color: .clear)
        } else { return }
    }
}
