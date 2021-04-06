//
//  BlockShadowCell.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import UIKit

class BlockShadowCell: CellModelView<BlockShadowCellModel> {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}

public class BlockShadowCellModel: AziBaseCellModel {
    public var height: CGFloat = 8
    public override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return height
    }
}

public class BlockShadowSectionCellBuilder: CellBuilder{
    public override func parseCellModels() {
        self.addBlockShadow()
    }
}

public class BlockShadowSection: SectionController<BlockShadowSectionModel> {
    public override func getCellBuilder() -> CellBuilderInterface? {
        return BlockShadowSectionCellBuilder()
    }
}


public class BlockShadowSectionModel: AziBaseSectionModel {
    
    
    public override func getSectionInit() -> SectionControllerInterface? {
        return BlockShadowSection()
    }
}
