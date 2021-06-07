//
//  FilterBlockSectionController.swift
//  Piano_App
//
//  Created by Azibai on 04/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol PaymentFilterBlockSectionDelegate: class {
    func showSectionFilter()
    func hiddenSectionFilter()
}

class PaymentFilterBlockSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    var filter: PaymentFilterField
    var title: String = ""
    init(filter: PaymentFilterField, title: String = "") {
        self.filter = filter
        self.title = title
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return PaymentFilterBlockSectionController()
    }
}

class PaymentFilterBlockSectionController: SectionController<PaymentFilterBlockSectionModel> {
    
    weak var delegate: PaymentFilterBlockSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? PaymentFilterBlockSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return PaymentFilterBlockCellBuilder()
    }

}
extension PaymentFilterBlockSectionController: PaymentBlockFilterCellDelegate {
    func updateFilter(filter: PaymentFilterField) {
        sectionModel?.filter = filter
    }
    
    func showModeDateFilter() {
        delegate?.showSectionFilter()
    }
    
    func hiddenModeDateFilter() {
        delegate?.hiddenSectionFilter()
    }
}

class PaymentFilterBlockCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? PaymentFilterBlockSectionModel else { return }
        let cell = PaymentBlockFilterCellModel(filter: sectionModel.filter, title: sectionModel.title)
        appendCell(cell)
    }
}
