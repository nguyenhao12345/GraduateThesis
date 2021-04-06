//
//  PopupIGSectionController.swift
//  gapoFeedClone
//
//  Created by Azibai on 30/07/2020.
//  Copyright © 2020 com.hieudev. All rights reserved.
//

import UIKit
import Mapper

protocol PopupIGSectionDelegate: class {
    
}

class PopupIGSectionModel: AziBaseSectionModel {
    var dataModels: [String] = []
    var attributes: [NSAttributedString.Key : Any]? = nil
    init(dataModels: [String] = [],
         attributes: [NSAttributedString.Key : Any]? = nil) {
        self.dataModels = dataModels
        self.attributes = attributes
        if self.attributes == nil {
            self.attributes = [.font : UIFont.kohoMedium16,
                               .foregroundColor : UIColor.init(hexString: "A1A1A1")]
        }
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return PopupIGSectionController()
    }
}

class PopupIGSectionController: SectionController<PopupIGSectionModel> {
    
    weak var delegate: PopupIGSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? PopupIGSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return PopupIGCellBuilder()
    }
    
    override func didSelectItem(at index: Int) {
        guard let cell = cellModelAtIndex(index) as? HeaderSimpleCellModel,
            let viewController = viewController as? PopupIGViewController else { return }
        viewController.completionHandle?(cell.attributed?.string ?? "")
    }

}

class PopupIGCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? PopupIGSectionModel else { return }
        addBlankSpace(6, color: .clear)
        for (index, i) in sectionModel.dataModels.enumerated() {
            addBlankSpace(12, color: .clear)
            addSimpleText(NSMutableAttributedString(string: i, attributes: sectionModel.attributes), height: nil)
            addBlankSpace(12, color: .clear)
            if index != sectionModel.dataModels.count - 1 {
                addSingleLine(true)
            }
        }
        addBlankSpace(12, color: .clear)

    }
}
