//
//  FeedStyleInstrumentSectionController.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import SwiftyJSON

protocol FeedStyleInstrumentSectionDelegate: class {
    
}

class FeedStyleInstrumentSectionModel: AziBaseSectionModel {
    var dataModels: [MusicModel] = []
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return FeedStyleInstrumentSectionController()
    }
}

class FeedStyleInstrumentSectionController: SectionController<FeedStyleInstrumentSectionModel> {
    
    weak var delegate: FeedStyleInstrumentSectionDelegate?
    
    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        
        ServiceOnline.share.getData(param: "SuggestForYou") { (snapShot) in
            let data = snapShot as? NSDictionary
            DispatchQueue.main.async {
                let jsonMusics = data?["data"] as? [String: [String: Any]] ?? ["":["":""]]
                _ = data?["title"] as? String ?? ""
                let objs = jsonMusics.map({ MusicModel(json: JSON($0.value))})
                self.sectionModel?.dataModels = objs
                self.reloadSection(animated: true, completion: nil)
            }
        }
    }
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? FeedStyleInstrumentSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return FeedStyleInstrumentCellBuilder()
    }

    override func didSelectItem(at index: Int) {
        guard let cellModel = cellModelAtIndex(index) as? InstrumentSuggestCellModel,
            let cellView = cellModel.getCellView() as? InstrumentSuggestCell,
            let dataModel = cellModel.dataModel,
            let viewController = viewController else { return }
        
        AppRouter.shared.gotoDetailMusic(id: dataModel.idDetail ?? "",
                                         viewController: viewController,
                                         frameAnimation: cellView.imageSong.globalFrame,
                                         viewAnimation: cellView.imageSong)
    }
}

class FeedStyleInstrumentCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? FeedStyleInstrumentSectionModel else { return }
        addBlankSpace(12, width: nil, color: .clear)

        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "     Gợi ý cho bạn", font: .HelveticaNeueBold18, color: .black))

        if sectionModel.dataModels.count != 0 {
            for i in sectionModel.dataModels {
                let cell = InstrumentSuggestCellModel()
                cell.dataModel = i
                appendCell(cell)
                addBlankSpace(12, width: nil, color: .clear)
            }
        } else {
            let cell = LoadingSuggestCellModel()
            appendCell(cell)
            addBlankSpace(24, width: nil, color: .clear)
        }
        
        
        addBlankSpace(12, width: nil, color: .clear)


    }
}
