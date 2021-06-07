//
//  AddAccountPaymentSectionController.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol AddAccountPaymentSectionDelegate: class {
    
}

class AddAccountPaymentSectionModel: AziBaseSectionModel {
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return AddAccountPaymentSectionController()
    }
}

class AddAccountPaymentSectionController: SectionController<AddAccountPaymentSectionModel> {
    
    weak var delegate: AddAccountPaymentSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? AddAccountPaymentSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return AddAccountPaymentCellBuilder()
    }

}

class AddAccountPaymentCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        let cell = AddAccountPaymentCellModel()
        appendCell(cell)
    }
}
