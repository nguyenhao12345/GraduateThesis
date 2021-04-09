//
//  InfoUserDetailSectionController.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

class InfoUserDetailSectionModel: InfoUserSectionModel {
    override func getSectionInit() -> SectionControllerInterface? {
        return InfoUserDetailSectionController()
    }
}

class InfoUserDetailSectionController: InfoUserSectionController {
    
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return InfoUserDetailCellBuilder()
    }

}

class InfoUserDetailCellBuilder: InfoUserCellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? InfoUserSectionModel else { return }
        buildDetailUser(sectionModel: sectionModel)
    }
}
