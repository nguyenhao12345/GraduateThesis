//
//  TopMussicSectionController.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol TopMussicSectionDelegate: class {
    
}

class TopMussicSectionModel: AziBaseSectionModel {
    
    override init() {
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return TopMussicSectionController()
    }
}

class TopMussicSectionController: SectionController<TopMussicSectionModel> {
    
    weak var delegate: TopMussicSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? TopMussicSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return TopMussicCellBuilder()
    }
    
     override func didUpdate(to object: Any) {
         super.didUpdate(to: object)
     }
}

class TopMussicCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        
        let cell = TopMusicsCellModel()
        appendCell(cell)
        addBlankSpace(12, width: nil, color: .clear)
    }
}
