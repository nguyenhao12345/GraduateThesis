//
//  SectionBuilderInterface.swift
//  testIgList
//
//  Created by Azibai on 22/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import Foundation
import IGListKit

public protocol SectionBuilderInterface: class{
    func getSection(object: Any?, presenter: AnyObject?) -> ListSectionController
    func getSection(object: Any?, view: AnyObject?) -> ListSectionController

}
