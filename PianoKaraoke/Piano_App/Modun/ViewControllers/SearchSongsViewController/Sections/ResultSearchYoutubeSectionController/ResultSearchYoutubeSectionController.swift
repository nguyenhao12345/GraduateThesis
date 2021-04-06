//
//  ResultSearchYoutubeSectionController.swift
//  Piano_App
//
//  Created by Azibai on 16/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import YoutubeKit
import Alamofire
import Alamofire_SwiftyJSON

protocol ResultSearchYoutubeSectionDelegate: class {
    
}

class ResultSearchYoutubeSectionModel: AziBaseSectionModel {
    var dataModel: SearchResult? = nil
    
    init(dataModel: SearchResult? = nil) {
        self.dataModel = dataModel
        super.init()
    }
    
    override init() {
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return ResultSearchYoutubeSectionController()
    }
}

class ResultSearchYoutubeSectionController: SectionController<ResultSearchYoutubeSectionModel>,
InstrumentSuggestCellDelegate {
    func remove(by: InstrumentSuggestCellModel?) {
        
    }
    
    func clickDownLoad(by: InstrumentSuggestCellModel?) {
        guard let cellModel = by else { return }
        if let model = cellModel.dataModel?.youtubeModel {
            converYoutubeObjectToVideoLocal(object: model, isSaveTmpLocal: false)
            requestSaveTmp = false
        }
    }
    
    
    weak var delegate: ResultSearchYoutubeSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? ResultSearchYoutubeSectionDelegate
    }
    var requestSaveTmp: Bool = false
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return ResultSearchYoutubeCellBuilder()
    }

    override func didSelectItem(at index: Int) {
        guard let cellModel = cellModels[index] as? InstrumentSuggestCellModel else { return }
        if let model = cellModel.dataModel?.youtubeModel {
            converYoutubeObjectToVideoLocal(object: model, isSaveTmpLocal: true)
            requestSaveTmp = true
        }
    }
    
    func converYoutubeObjectToVideoLocal(object: SearchResult, isSaveTmpLocal: Bool) {
        LocalVideoManager.shared.delegate = self
        YoutubeService.shared.downLoadVideoYoutubeToLocal(object: object, isSaveTmpLocal: isSaveTmpLocal)
    }
    
}

extension ResultSearchYoutubeSectionController: LocalVideoManagerDelegate {
    func doneRequest() {
        guard let key = sectionModel?.dataModel?.snippet.title else { return }
        
        if requestSaveTmp {
            //LocalTmp
            let vc = PianoCustomViewController()
            vc.config(link: LocalVideoManager.shared.getURLVideoLocal(key: LocalVideoManager.shared.VideoYoutube),
                       nameSong: "YouTube",
                       typeCellInitViewController: TypeCell.CellYoutube)
             vc.modalTransitionStyle = .crossDissolve
             vc.modalPresentationStyle = .fullScreen
             viewController?.present(vc, animated: true, completion: nil)
        } else {
            let vc = PianoCustomViewController()
             vc.config(link: LocalVideoManager.shared.getURLVideoLocal(key: key),
                       nameSong: "YouTube",
                       typeCellInitViewController: TypeCell.CellYoutube)
             vc.modalTransitionStyle = .crossDissolve
             vc.modalPresentationStyle = .fullScreen
             viewController?.present(vc, animated: true, completion: nil)
        }
    }
}

class ResultSearchYoutubeCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? ResultSearchYoutubeSectionModel else { return }
        addBlankSpace(12, width: nil, color: .clear)
        let cell = InstrumentSuggestCellModel()
        cell.isHiddenImagePlay = true
        cell.isHiddenDownLoad = false
        cell.dataModel = MusicModel(youtubeObject: sectionModel.dataModel!)
        appendCell(cell)
    }
}
