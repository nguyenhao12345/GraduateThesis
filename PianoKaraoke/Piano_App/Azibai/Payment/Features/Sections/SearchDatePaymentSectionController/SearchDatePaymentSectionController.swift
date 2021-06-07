//
//  SearchDatePaymentSectionController.swift
//  Piano_App
//
//  Created by Azibai on 12/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol SearchDatePaymentSectionDelegate: class {
    func viewAllHistory()
    func searchHistory()
}

class SearchDatePaymentSectionModel: AziBaseSectionModel {
    
    enum TypeShow {
        case Search
        case History
    }
    var type: TypeShow = .Search
    
    init(type: TypeShow = .Search) {
        self.type = type
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return SearchDatePaymentSectionController()
    }
}

class SearchDatePaymentSectionController: SectionController<SearchDatePaymentSectionModel> {
    
    weak var delegate: SearchDatePaymentSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? SearchDatePaymentSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return SearchDatePaymentCellBuilder()
    }

}

extension SearchDatePaymentSectionController: HistoryLabelCellDelegate {
    
    func viewAllHistory() {
        delegate?.viewAllHistory()
    }
    
}
extension SearchDatePaymentSectionController: SearchDatePaymentCellDelegate {
    func clickSearchHistory() {
        delegate?.searchHistory()
    }
}

class SearchDatePaymentCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? SearchDatePaymentSectionModel else { return }
        addBlankSpace(2, color: .clear)
        switch sectionModel.type {
        case .History:
            let cell = HistoryLabelCellModel()
            appendCell(cell)
        case .Search:
            let cell = SearchDatePaymentCellModel()
            appendCell(cell)
        }
        addBlankSpace(8, color: .clear)
    }
}
