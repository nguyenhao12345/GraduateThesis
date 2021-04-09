//
//  DetailSongSectionController.swift
//  Piano_App
//
//  Created by Azibai on 14/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol DetailSongSectionDelegate: class {
    
}

class DetailSongSectionModel: AziBaseSectionModel {
    var keyIdDetail: String = ""
    var dataModel: DetailInfoSong?
    var imageMusic: UIImage?
    let idCellCover: String = "idCellCover"
    var isLocalLoad: Bool = false
    var data: NSDictionary? = nil
    init(dataModel: DetailInfoSong? = nil, keyIdDetail: String = "", imageMusic: UIImage? = nil) {
        self.keyIdDetail = keyIdDetail
        self.imageMusic = imageMusic
        self.dataModel = dataModel
        isLocalLoad = dataModel == nil ? false: true
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return DetailSongSectionController()
    }
}

class DetailSongSectionController: SectionController<DetailSongSectionModel> {
    
    weak var delegate: DetailSongSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? DetailSongSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return DetailSongCellBuilder()
    }

    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        
        if sectionModel?.dataModel == nil {
            fetchData()
        }
    }
    func fetchData() {
        ServiceOnline.share.getDataInfoSong(param: sectionModel?.keyIdDetail ?? "") { (snapShot) in
            guard let data = snapShot as? NSDictionary else { return }
            let dataDetailInfoSOng = DetailInfoSong(data: data as? [String : Any] ?? [:])
            self.sectionModel?.dataModel = dataDetailInfoSOng
            self.sectionModel?.data = data
            self.reloadSection(animated: false, completion: nil)
            guard let viewController = self.viewController as? DetailSongViewController else { return }
            viewController.btnDownLoad.isHidden = false
        }
    }
    
    override func didSelectItem(at index: Int) {
        guard let _ = cellModelAtIndex(index) as? PlayButtonCellModel else { return }
        let vc = PianoCustomViewController()
        vc.config(link: (sectionModel?.isLocalLoad ?? false) ? sectionModel?.dataModel?.urlMp4Local: sectionModel?.dataModel?.urlMp4,
                  nameSong: sectionModel?.dataModel?.nameSong,
                  typeCellInitViewController: (sectionModel?.isLocalLoad ?? false) ? TypeCell.CellLocal : TypeCell.CellOnline)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        vc.youtubeModel = nil
        vc.detailSongModel = sectionModel?.dataModel
        viewController?.present(vc, animated: true, completion: nil)
    }
}

class DetailSongCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? DetailSongSectionModel else { return }
        buildCoverCell()
        buildNameSongCell(name: sectionModel.dataModel?.nameSong ?? "")
        buildNameCell(key: "Tác giả", name: sectionModel.dataModel?.author ?? "")
        buildNameCell(key: "Thể loại", name: sectionModel.dataModel?.category ?? "")
        buildLevelCell(level: sectionModel.dataModel?.level ?? 5)
        buildReactionCell()
        buildPlayCell()
        buildLyricCell(lyric: sectionModel.dataModel?.karaokeLyric ?? "")
        buildNoteCell(notes: sectionModel.dataModel?.contentKaraoke ?? "")
        addBlankSpace(24, width: nil, color: .clear)
    }
    
    func buildLyricCell(lyric: String) {
        addBlankSpace(8, width: nil, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "•Lyric:", font: .HelveticaNeueBold24, color: .defaultText), height: nil, spaceWitdh: 30)

        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "\(lyric)", font: .HelveticaNeue18, color: .defaultText), height: nil, spaceWitdh: 30, truncationString: Helper.getAttributesStringWithFontAndColor(string: "...Xem thêm", font: .HelveticaNeueItalic18, color: .gray), numberOfLine: 4)
    }
    
    func buildNoteCell(notes: String) {
        addBlankSpace(8, width: nil, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "•Cảm âm:", font: .HelveticaNeueBold24, color: .defaultText), height: nil, spaceWitdh: 30)
        
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "\(notes)", font: .HelveticaNeue18, color: .defaultText), height: nil, spaceWitdh: 30, truncationString: Helper.getAttributesStringWithFontAndColor(string: "...Xem thêm", font: .HelveticaNeueItalic18, color: .gray), numberOfLine: 4)

    }
    
    func buildReactionCell() {
        addBlankSpace(8, width: nil, color: .clear)
        let cell = ReactionMusicCellModel()
        appendCell(cell)
    }
    
    func buildCoverCell() {
        guard let sectionModel = sectionModel as? DetailSongSectionModel else { return }
        let cell = DetailMediaCellModel()
        cell.diffID = sectionModel.idCellCover
        cell.urlImage = sectionModel.dataModel?.imageSong ?? ""
        cell.imageMusic = sectionModel.imageMusic
        appendCell(cell)

    }
    
    func buildLevelCell(level: Int) {
        addBlankSpace(8, width: nil, color: .clear)
        let cell = LevelMediaCellModel()
        cell.numberStart = level
        appendCell(cell)
    }
    
    func buildNameSongCell(name: String) {
        addBlankSpace(8, width: nil, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "\(name)", font: .HelveticaNeueBold24, color: .defaultText), height: nil, spaceWitdh: 30)
    }
    
    func buildNameCell(key: String, name: String) {
        addBlankSpace(8, width: nil, color: .clear)
        
        let att = Helper.getAttributesStringWithFontAndColor(
            string: "\(key):  ", font: .HelveticaNeueBold18, color: .defaultText)
        att.append(NSAttributedString(string: name, attributes: [NSAttributedString.Key.font : UIFont.HelveticaNeue18, NSAttributedString.Key.foregroundColor : UIColor.defaultText]))
        addSimpleText(att, height: nil, spaceWitdh: 30)
    }

    func buildPlayCell() {
        let cell = PlayButtonCellModel()
        appendCell(cell)
        addBlankSpace(8, width: nil, color: .clear)
    }
}
