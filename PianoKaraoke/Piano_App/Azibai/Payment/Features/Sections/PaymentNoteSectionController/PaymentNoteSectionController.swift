//
//  PaymentNoteSectionController.swift
//  Piano_App
//
//  Created by Azibai on 14/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol PaymentNoteSectionDelegate: class {
    
}

class PaymentNoteSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    var att: NSMutableAttributedString?

    init(att: NSMutableAttributedString?) {
        self.att = att
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return PaymentNoteSectionController()
    }
}

class PaymentNoteSectionController: SectionController<PaymentNoteSectionModel> {
    
    weak var delegate: PaymentNoteSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? PaymentNoteSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return PaymentNoteCellBuilder()
    }

}

class PaymentNoteCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? PaymentNoteSectionModel else { return }
        let cell = PaymentNoteCellModel()
        cell.att = sectionModel.att
        appendCell(cell)
    }
}
