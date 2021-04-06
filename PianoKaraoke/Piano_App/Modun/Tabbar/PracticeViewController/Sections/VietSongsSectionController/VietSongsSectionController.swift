//
//  VietSongsSectionController.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import SwiftyJSON

protocol VietSongsSectionDelegate: class {
    
}

class VietSongsSectionModel: AziBaseSectionModel {
    var dataModels: [MusicModel] = []
    var key: String = ""
    var title: String = "Loading..."
    init(key: String) {
        self.key = key
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return VietSongsSectionController()
    }
}

class VietSongsSectionController: SectionController<VietSongsSectionModel> {
    
    weak var delegate: VietSongsSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? VietSongsSectionDelegate
    }
    
    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        
        ServiceOnline.share.getData(param: sectionModel?.key ?? "") { (snapShot) in
            let data = snapShot as? NSDictionary
            DispatchQueue.main.async {
                let jsonMusics = data?["arraySongs"] as? [String: [String: Any]] ?? ["":["":""]]
                let objs = jsonMusics.map({ MusicModel(json: JSON($0.value))})
                let title = data?["title"] as? String ?? ""
                self.sectionModel?.title = title
                self.sectionModel?.dataModels = objs
                self.reloadSection(animated: true, completion: nil)
            }
        }
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return VietSongsCellBuilder()
    }

}

class VietSongsCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? VietSongsSectionModel else { return }
        let cell = VietSongsCellModel()
        cell.dataModels = Array(sectionModel.dataModels.prefix(5))
        cell.title = sectionModel.title
        appendCell(cell)
        addBlankSpace(12, width: nil, color: .clear)
    }
}
