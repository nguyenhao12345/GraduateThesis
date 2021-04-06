//
//  NewsDetailNewsFeedHeaderSectionController.swift
//  Piano_App
//
//  Created by Azibai on 02/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol NewsDetailNewsFeedHeaderSectionDelegate: class {
    
}

class NewsDetailNewsFeedHeaderSectionModel: AziBaseSectionModel {
    var newsFeedModel: NewsFeedModel? = nil

    init(newsFeedModel: NewsFeedModel?) {
        self.newsFeedModel = newsFeedModel
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return NewsDetailNewsFeedHeaderSectionController()
    }
}

class NewsDetailNewsFeedHeaderSectionController: SectionController<NewsDetailNewsFeedHeaderSectionModel> {
    
    weak var delegate: NewsDetailNewsFeedHeaderSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? NewsDetailNewsFeedHeaderSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return NewsDetailNewsFeedHeaderCellBuilder()
    }

}

class NewsDetailNewsFeedHeaderCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? NewsDetailNewsFeedHeaderSectionModel else { return }
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: sectionModel.newsFeedModel?.content ?? "", font: .HelveticaNeue16, color: .white), height: nil, spaceWitdh: 32, truncationString: Helper.getAttributesStringWithFontAndColor(string: "...Xem thêm", font: .HelveticaNeueMedium16, color: .lightText), numberOfLine: 3)
        
        addBlankSpace(12, color: .clear)
        addBlankSpace(0.5, width: Const.widthScreens - 32, color: .lightGray)
        addBlankSpace(12, color: .clear)
    }
}
