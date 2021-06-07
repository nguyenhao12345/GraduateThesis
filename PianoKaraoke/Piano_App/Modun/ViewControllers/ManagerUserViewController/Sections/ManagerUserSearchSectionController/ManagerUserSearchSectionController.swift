//
//  ManagerUserSearchSectionController.swift
//  Piano_App
//
//  Created by Azibai on 23/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import IGListKit
import Mapper

protocol ManagerUserSearchSectionDelegate: class {
    
}

class ManagerUserSearchSectionModel: AziBaseSectionModel {
    var textSearch: String = ""
    init(textSearch: String = "") {
        self.textSearch = textSearch
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return ManagerUserSearchSectionController()
    }
}

class ManagerUserSearchSectionController: SectionController<ManagerUserSearchSectionModel> {
    
    weak var delegate: ManagerUserSearchSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? ManagerUserSearchSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return ManagerUserSearchCellBuilder()
    }

    override func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        if let viewController = viewController as? ManagerUserViewController {
            viewController.containerView.isHidden = false
            viewController.navView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            viewController.view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)

        }
    }
    
    override func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        if let viewController = viewController as? ManagerUserViewController {
            viewController.containerView.isHidden = true
            viewController.navView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            viewController.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}

class ManagerUserSearchCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? ManagerUserSearchSectionModel else { return }
        
        addBlankSpace(12, color: .clear)
        let cell = SearchCellModel()
        cell.textSearch = sectionModel.textSearch
        appendCell(cell)
        addBlankSpace(12, color: .clear)
    }
}
