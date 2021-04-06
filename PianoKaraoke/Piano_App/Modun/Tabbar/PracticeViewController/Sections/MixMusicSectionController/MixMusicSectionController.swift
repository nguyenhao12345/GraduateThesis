//
//  MixMusicSectionController.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import SwiftyJSON

protocol MixMusicSectionDelegate: class {
    func scrollToTop()
}

class MixMusicSectionModel: AziBaseSectionModel {
    var dataModels: [MusicModel] = []
    var key: String = "NhacViet"
    var title: String = "Loading..."

    override init() {
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return MixMusicSectionController()
    }
}

class MixMusicSectionController: SectionController<MixMusicSectionModel> {
    
    weak var delegate: MixMusicSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? MixMusicSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return MixMusicCellBuilder()
    }

    
    override init() {
        super.init()
        isUseBackgroundCardView = true
    }
    
    override func didSelectItem(at index: Int) {
        guard let cellModel = cellModelAtIndex(index) as? MusicSimpleCellModel,
            let cellView = cellModel.getCellView() as? MusicSimpleCell,
            let dataModel = cellModel.dataModel,
            let viewController = viewController else { return }
        
        AppRouter.shared.gotoDetailMusic(id: dataModel.idDetail ?? "",
                                         viewController: viewController,
                                         frameAnimation: cellView.imageView.globalFrame,
                                         viewAnimation: cellView.imageView)
    }
    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        self.inset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 12)
        minimumLineSpacing = 12
        minimumInteritemSpacing = 12
        updateUIbyAPI(key: sectionModel?.key ?? "")
    }
    
    func updateUIbyAPI(key: String, isScrollTop: Bool = false) {
        ServiceOnline.share.getData(param: key) { (snapShot) in
            let data = snapShot as? NSDictionary
            DispatchQueue.main.async {
                let jsonMusics = data?["arraySongs"] as? [String: [String: Any]] ?? ["":["":""]]
                let objs = jsonMusics.map({ MusicModel(json: JSON($0.value))})
                let title = data?["title"] as? String ?? ""
                self.sectionModel?.title = title
                self.sectionModel?.dataModels = objs
                self.reloadSection(animated: false) { _ in
                    if isScrollTop {
                        self.delegate?.scrollToTop()
                    }
                }
            }
        }
    }
}
extension MixMusicSectionController: HeaderMixMusicCellDelegate {
    func segmentedMenu(_ text: String, index: Int) {
        if index == 0 {
            sectionModel?.key = "NhacViet"
            updateUIbyAPI(key: sectionModel?.key ?? "", isScrollTop: true)
        } else {
            sectionModel?.key = "NhacTrungQuoc"
            updateUIbyAPI(key: sectionModel?.key ?? "", isScrollTop: true)
        }
    }
    
    
}
class MixMusicCellBuilder: CellBuilder {
    let headerCell = HeaderMixMusicCellModel()
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? MixMusicSectionModel else { return }
        setHeaderCell(headerCell)
        addBlankSpace(-1, width: nil, color: .clear)
        
        if sectionModel.dataModels.count == 0 {
            for _ in 0..<3 {
                let cell = LoadingSongCellModel(height: (Const.widthScreens/2), width: (Const.widthScreens - 12*3)/2)
                appendCell(cell)
            }
        } else {
            for i in sectionModel.dataModels {
                let cell = MusicSimpleCellModel(dataModel: i, height: (Const.widthScreens/2), width: (Const.widthScreens - 12*3)/2)
                appendCell(cell)
            }
        }
    
    }
}
