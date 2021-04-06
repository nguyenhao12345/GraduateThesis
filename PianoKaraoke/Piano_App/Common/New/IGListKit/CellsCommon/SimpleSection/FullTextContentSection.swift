//
//  FullTextContentSection.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import UIKit

public class FullTextContentSectionCellBuilder: CellBuilder{
    
    override public func parseCellModels() {
        guard let sectionModel = self.sectionModel as? FullTextContentSectionModel else{
            return
        }
        let height:CGFloat = 0
        let minHeight = sectionModel.minHeight
        if height < minHeight{
            self.cellModels.safeAppend(BlankSpaceCellModel(height: minHeight - height))
        }
    }

}

public class FullTextContentSection: SectionController<FullTextContentSectionModel> {
    
    public override func getCellBuilder() -> CellBuilderInterface? {
        return FullTextContentSectionCellBuilder()
    }
    
}
public class FullTextContentSectionModel: AziBaseSectionModel{
    public var textContent: String?
    public var minHeight:CGFloat = 0
    
    
    public override func getSectionInit() -> SectionControllerInterface? {
        return FullTextContentSection()
    }
}
