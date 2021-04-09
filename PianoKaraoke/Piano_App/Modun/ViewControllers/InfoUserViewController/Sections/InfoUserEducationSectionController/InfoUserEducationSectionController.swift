//
//  InfoUserEducationSectionController.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

class InfoUserEducationSectionModel: InfoUserSectionModel {
    override func getSectionInit() -> SectionControllerInterface? {
        return InfoUserEducationSectionController()
    }
}

class InfoUserEducationSectionController: InfoUserSectionController {

    override func getCellBuilder() -> CellBuilderInterface? {
        return InfoUserEducationCellBuilder()
    }

}

class InfoUserEducationCellBuilder: InfoUserCellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? InfoUserSectionModel else { return }
        buildUserEducation(sectionModel: sectionModel)
    }
}
