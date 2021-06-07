//
//  PaymentFilterDateSectionController.swift
//  Piano_App
//
//  Created by Azibai on 04/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol PaymentFilterDateSectionDelegate: class {
    
}

class PaymentFilterDateSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    var filter: PaymentFilterHistory
    var isShow: Bool = false
    init(filter: PaymentFilterHistory) {
        self.filter = filter
        super.init()
    }

    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return PaymentFilterDateSectionController()
    }
}

class PaymentFilterDateSectionController: SectionController<PaymentFilterDateSectionModel> {
    
    weak var delegate: PaymentFilterDateSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? PaymentFilterDateSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return PaymentFilterDateCellBuilder()
    }

}

class PaymentFilterDateCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? PaymentFilterDateSectionModel else { return }
        if sectionModel.isShow {
            let cell = PaymentFilterDateCellModel(filter: sectionModel.filter)
            appendCell(cell)
        }
    }
}
