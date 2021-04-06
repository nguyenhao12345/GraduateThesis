//
//  AziBaseSectionModel.swift
//  testIgList
//
//  Created by Azibai on 22/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import Foundation
import IGListKit

open class AziBaseSectionModel: AziBaseModel {
    public weak var sectionController: SectionControllerInterface?
    open func getSectionInit() -> SectionControllerInterface?{
        return nil
    }
    
    deinit {
        print("\(String(describing: self)) section model deinit")
    }
    
}
