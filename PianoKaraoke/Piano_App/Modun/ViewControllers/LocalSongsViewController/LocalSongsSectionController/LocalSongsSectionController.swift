//
//  LocalSongsSectionController.swift
//  Piano_App
//
//  Created by Azibai on 15/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol LocalSongsSectionDelegate: class {
    func deleteFileLocalSucces()
}

class LocalSongsSectionModel: AziBaseSectionModel {
    
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return LocalSongsSectionController()
    }
}

class LocalSongsSectionController: SectionController<LocalSongsSectionModel>, InstrumentSuggestCellDelegate {
    func clickDownLoad(by: InstrumentSuggestCellModel?) {
        
    }
    
    
    weak var delegate: LocalSongsSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? LocalSongsSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return LocalSongsCellBuilder()
    }

    override func didSelectItem(at index: Int) {
        guard let cellModel = cellModelAtIndex(index) as? InstrumentSuggestCellModel,
            let cellView = cellModel.getCellView() as? InstrumentSuggestCell,
            let dataModel = cellModel.dataModel,
            let viewController = viewController else { return }
        
        AppRouter.shared.gotoDetailMusic(id: dataModel.idDetail ?? "",
                                         viewController: viewController,
                                         frameAnimation: cellView.imageSong.globalFrame,
                                         viewAnimation: cellView.imageSong,
                                         dataModel: dataModel.detailSong)
    }
    
    func remove(by: InstrumentSuggestCellModel?) {
//        guard let cellModel = by,
//            let model = cellModel.dataModel?.detailSong else { return }
//        LocalVideoManager.shared.remove(object: model)
//        self.updateSection(animated: true, completion: nil)
//        self.delegate?.deleteFileLocalSucces()
        
        guard let cellModel = by,
            let model = cellModel.dataModel?.detailSong else { return }
        self.viewController?.showAlertCustomize(title: "Bạn thật sự muốn xoá?", message: "", buttonTitles: ["Xoá","Huỷ bỏ"], highlightedButtonIndex: 0, completion: { (value) in
            if value == 0 {
                LocalVideoManager.shared.remove(object: model)
                self.updateSection(animated: true, completion: nil)
                self.delegate?.deleteFileLocalSucces()
            } else {
                guard let cellView = cellModel.getCellView() as? InstrumentSuggestCell else { return }
                UIView.animate(withDuration: 0.3) {
                    cellView.hiddenRemoveView()
                }
            }
        })
    }
    

}

class LocalSongsCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        let dataModels = LocalVideoManager.shared.getAllLocalSongs()
        if dataModels.count == 0 {
            return
        }
        addBlankSpace(12, width: nil, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "Đã kiểm duyệt", font: .HelveticaNeueBold16, color: .defaultText), height: nil, spaceWitdh: 30)
        addBlankSpace(12, width: nil, color: .clear)
        for i in dataModels {
            let cell = InstrumentSuggestCellModel()
            cell.isHiddenBtnRemove = false
            cell.isHiddenImagePlay = true
            cell.dataModel = MusicModel(obj: i)
            appendCell(cell)
            addBlankSpace(12, width: nil, color: .clear)
        }

    }
    
}
