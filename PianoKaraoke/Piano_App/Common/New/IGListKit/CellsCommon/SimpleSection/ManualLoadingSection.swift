//
//  ManualLoadingSection.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import UIKit
import Mapper

public protocol ManualLoadingSectionDelegate:class {
    func manualLoadingSectionLoad()
}


extension ManualLoadingSection:ManualLoadingCellDelegate{
    
    public func manualLoadingCellLoad(){
        self.delegate?.manualLoadingSectionLoad()
    }
}


public class ManualLoadingSectionCellBuilder: CellBuilder{
    public override func parseCellModels() {
        self.addManualLoading()
    }
}

class ManualLoadingSection: SectionController<AziBaseModel> {
    public weak var delegate: ManualLoadingSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        self.delegate = presenter as? ManualLoadingSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return ManualLoadingSectionCellBuilder()
    }
    
}




public class ManualLoadingSectionModel: AziBaseSectionModel {
    public override init() {
        super.init()
        self.uid = Ultilities.randomStringKey()
    }
    
    public required init(map: Mapper) {
        super.init(map: map)
    }
    
    public override func getSectionInit() -> SectionControllerInterface? {
        return ManualLoadingSection()
    }
}
