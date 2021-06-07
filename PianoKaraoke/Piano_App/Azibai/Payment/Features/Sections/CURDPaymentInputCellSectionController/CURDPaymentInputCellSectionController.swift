//
//  CURDPaymentInputCellSectionController.swift
//  Piano_App
//
//  Created by Azibai on 14/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol CURDPaymentInputCellSectionDelegate: class {
}

class CURDPaymentInputCellSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    
    var title: String = ""
    var content: String = ""
    var placeholder: String = ""
    var id: Int?
    var type: PaymentTextFieldInputCellModel.TypeInPut = .Keyboard(.number)
    
    init(id: Int? = nil, title: String = "", content: String = "", placeholder: String = "", type: PaymentTextFieldInputCellModel.TypeInPut = .Keyboard(.number)) {
        self.title = title
        self.content = content
        self.placeholder = placeholder
        self.type = type
        self.id = id
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return CURDPaymentInputCellSectionController()
    }
}

class CURDPaymentInputCellSectionController: SectionController<CURDPaymentInputCellSectionModel> {
    
    weak var delegate: CURDPaymentInputCellSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? CURDPaymentInputCellSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return CURDPaymentInputCellCellBuilder()
    }

}
extension CURDPaymentInputCellSectionController: PaymentTextFieldInputCellDelegate {
    func contentUpdate(string: String, id: Int?) {
        sectionModel?.content = string
        sectionModel?.id = id
    }
}

class CURDPaymentInputCellCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? CURDPaymentInputCellSectionModel else { return }
        
        let cell = PaymentTextFieldInputCellModel(title: sectionModel.title,
                                                  content: sectionModel.content,
                                                  placeholder: sectionModel.placeholder,
                                                  type: sectionModel.type)
        appendCell(cell)
    }

}
