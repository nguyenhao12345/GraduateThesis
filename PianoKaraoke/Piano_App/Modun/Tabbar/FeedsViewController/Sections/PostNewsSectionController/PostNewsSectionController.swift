//
//  PostNewsSectionController.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol PostNewsSectionDelegate: class {
    
}

class PostNewsSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return PostNewsSectionController()
    }
}

class PostNewsSectionController: SectionController<PostNewsSectionModel> {
    
    weak var delegate: PostNewsSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? PostNewsSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return PostNewsCellBuilder()
    }

}

class PostNewsCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        let cell = PostNewsFeedCellModel()
        appendCell(cell)
    }
}
