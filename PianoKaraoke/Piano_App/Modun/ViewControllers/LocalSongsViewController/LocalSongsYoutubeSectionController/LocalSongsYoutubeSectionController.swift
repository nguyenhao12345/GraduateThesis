//
//  LocalSongsYoutubeSectionController.swift
//  Piano_App
//
//  Created by Azibai on 17/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import YoutubeKit

protocol LocalSongsYoutubeSectionDelegate: class {
    func deleteFileLocalSucces()
}

class LocalSongsYoutubeSectionModel: AziBaseSectionModel {
    
    override init() {
        super.init()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return LocalSongsYoutubeSectionController()
    }
}

class LocalSongsYoutubeSectionController: SectionController<LocalSongsYoutubeSectionModel>, InstrumentSuggestCellDelegate {
    func clickDownLoad(by: InstrumentSuggestCellModel?) {
        
    }
    
    func remove(by: InstrumentSuggestCellModel?) {
        guard let cellModel = by,
            let youtubeModel = cellModel.dataModel?.youtubeModel else { return }
        self.viewController?.showAlertCustomize(title: "Bạn thật sự muốn xoá?", message: "", buttonTitles: ["Xoá","Huỷ bỏ"], highlightedButtonIndex: 0, completion: { (value) in
            if value == 0 {
                LocalVideoManager.shared.removeObjectYoutube(object: youtubeModel)
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
    
    
    weak var delegate: LocalSongsYoutubeSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? LocalSongsYoutubeSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return LocalSongsYoutubeCellBuilder()
    }

    override func didSelectItem(at index: Int) {
        guard let cellModel = cellModels[index] as? InstrumentSuggestCellModel,
            let youtubeModel = cellModel.dataModel?.youtubeModel else { return }
        let vc = PianoCustomViewController()
        vc.config(link: LocalVideoManager.shared.getURLVideoLocal(key: youtubeModel.snippet.title),
                   nameSong: "YouTube",
                   typeCellInitViewController: TypeCell.CellYoutube)
         vc.modalTransitionStyle = .crossDissolve
         vc.modalPresentationStyle = .fullScreen
         viewController?.present(vc, animated: true, completion: nil)
    }
    
}

class LocalSongsYoutubeCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        let dataModels = LocalVideoManager.shared.getAllLocalSongYoutube()
        if dataModels.count == 0 {
            return
        }
        addBlankSpace(12, width: nil, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "Songs Youtube:", font: .HelveticaNeueBold16, color: .defaultText), height: nil, spaceWitdh: 30)
        addBlankSpace(12, width: nil, color: .clear)
        for i in dataModels {
            let cell = InstrumentSuggestCellModel()
            cell.dataModel = MusicModel(youtubeObject: i)
            cell.isHiddenBtnRemove = false
            cell.isHiddenImagePlay = true
            appendCell(cell)
            addBlankSpace(12, width: nil, color: .clear)
        }

    }
}
