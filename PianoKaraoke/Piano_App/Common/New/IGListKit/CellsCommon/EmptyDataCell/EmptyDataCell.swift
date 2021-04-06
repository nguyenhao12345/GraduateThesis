//
//  EmptyDataCell.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import Mapper
import UIKit

public class EmptyDataCell: CellModelView<EmptyDataCellModel> {
    @IBOutlet weak var contentButton: UIButton!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public func bindCellModel(_ cellModel: EmptyDataCellModel) {
        super.bindCellModel(cellModel)
//        self.contentButton.setTitle(cellModel.content, for: .normal)
//        guard cellModel.dataModel != nil else {
//            return
//        }
        
        //TODO
        
        
    }
}


public protocol EmptyDataCellDelegate: class{
    
}

public class EmptyDataCellModel: AziBaseCellModel {
    public var dataModel: Any?
    public weak var delegate: EmptyDataCellDelegate?
    public var content: String = "Không có dữ liệu"
    public var background: UIColor = UIColor.clear
    
    public override func setSectionController(_ section: Any?) {
        super.setSectionController(section)
        self.delegate = section as? EmptyDataCellDelegate
    }
    
    public override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return maxWidth
    }
    //    public override func getCellName() -> String {
    //        return "EmptyDataCell"
    //    }
}


public class EmptyDataSectionCellBuilder: CellBuilder {
    public override func parseCellModels() {
        self.addEmpyData()
    }
}

public class EmptyDataSection: SectionController<AziBaseModel> {
    
    public override func getCellBuilder() -> CellBuilderInterface? {
        return EmptyDataSectionCellBuilder()
    }
}




public class EmptyDataSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    public override init() {
        super.init()
        self.uid = Ultilities.randomStringKey()
    }
    
    public required init(map: Mapper) {
        super.init(map: map)
    }
    
    
    public override func getSectionInit() -> SectionControllerInterface? {
        return EmptyDataSection()
    }
}
