//
//  LoadingSection.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import UIKit

public class LoadingSectionCellBuilder: CellBuilder{
    public override func parseCellModels() {
        guard let sc = sectionModel as? LoadingSectionModel else { return }
        for _ in 0..<sc.numberLoading {
            self.addLoading()
        }
    }
}

public class LoadingSection: SectionController<AziBaseModel> {
    
    public override func getCellBuilder() -> CellBuilderInterface? {
        return LoadingSectionCellBuilder()
    }
}
