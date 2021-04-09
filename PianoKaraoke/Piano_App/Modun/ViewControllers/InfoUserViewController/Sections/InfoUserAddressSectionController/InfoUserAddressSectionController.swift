//
//  InfoUserAddressSectionController.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper


class InfoUserAddressSectionModel: InfoUserSectionModel {
    override func getSectionInit() -> SectionControllerInterface? {
        return InfoUserAddressSectionController()
    }
}

class InfoUserAddressSectionController: InfoUserSectionController {
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return InfoUserAddressCellBuilder()
    }

}

class InfoUserAddressCellBuilder: InfoUserCellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? InfoUserSectionModel else { return }
        buildUserLocation(sectionModel: sectionModel)
    }
}
