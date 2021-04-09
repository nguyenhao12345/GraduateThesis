//
//  InfoUserJobSectionController.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

class InfoUserJobSectionModel: InfoUserSectionModel {
    
    override func getSectionInit() -> SectionControllerInterface? {
        return InfoUserJobSectionController()
    }
}

class InfoUserJobSectionController: InfoUserSectionController {
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return InfoUserJobCellBuilder()
    }

}

class InfoUserJobCellBuilder: InfoUserCellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? InfoUserSectionModel else { return }
        buildUserJob(sectionModel: sectionModel)
    }
}
