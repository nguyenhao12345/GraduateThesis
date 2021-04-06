//
//  DefaultSectionController.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//


import UIKit
import IGListKit


public class DefaultSectionCellBuilder: CellBuilder{
    public override func parseCellModels() {}
}

public class DefaultSectionController: SectionController<DefaultSectionModel> {
    public override func getCellBuilder() -> CellBuilderInterface? {
        return DefaultSectionCellBuilder()
    }
}

public class DefaultSectionModel: AziBaseSectionModel {
    
}
