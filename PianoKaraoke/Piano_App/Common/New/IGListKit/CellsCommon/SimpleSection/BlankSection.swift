//
//  BlankSection.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//


import UIKit
import Mapper

public class BlankSectionCellBuilder: CellBuilder{
    public override func parseCellModels() {
        guard let sectionModel = self.sectionModel as? BlankSectionModel else {
            return
        }
        self.addBlankSpace(sectionModel.height, color: sectionModel.color)
    }
}

public class BlankSection: SectionController<BlankSectionModel> {
    public override func getCellBuilder() -> CellBuilderInterface? {
        return BlankSectionCellBuilder()
    }
}


public class BlankSectionModel: AziBaseSectionModel {
    public var height: CGFloat = 8
    public var color: UIColor = UIColor.white
    
    init(height: CGFloat) {
        self.height = height
        super.init()
    }
    init(height: CGFloat, color: UIColor) {
        super.init()
        self.height = height
        self.color = color
    }
//
    public required init(map: Mapper) {
        super.init(map: map)
    }
//
    public override func getSectionInit() -> SectionControllerInterface? {
        return BlankSection()
    }
}
