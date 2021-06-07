//
//  HistoryPaymentSectionController.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol HistoryPaymentSectionDelegate: class {
    
}

class HistoryPaymentSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return HistoryPaymentSectionController()
    }
}

class HistoryPaymentSectionController: SectionController<HistoryPaymentSectionModel> {
    
    weak var delegate: HistoryPaymentSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? HistoryPaymentSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return HistoryPaymentCellBuilder()
    }

}

class HistoryPaymentCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? HistoryPaymentSectionModel else { return }
        let cell = HistoryPaymentCellModel()
        appendCell(cell)
    }
}
