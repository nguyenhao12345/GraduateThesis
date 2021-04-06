//
//  CommentDetailSongSectionController.swift
//  Piano_App
//
//  Created by Azibai on 15/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol CommentDetailSongSectionDelegate: class {
    
}

class CommentDetailSongSectionModel: AziBaseSectionModel {
    var keyIdDetail: String = ""
    var dataModels: [CommentModel] = []
    
    init(keyIdDetail: String = "", dataModels: [CommentModel] = []) {
        self.keyIdDetail = keyIdDetail
        self.dataModels = dataModels
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return CommentDetailSongSectionController()
    }
}

class CommentDetailSongSectionController: SectionController<CommentDetailSongSectionModel> {
    
    weak var delegate: CommentDetailSongSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? CommentDetailSongSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return CommentDetailSongCellBuilder()
    }

    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
        if sectionModel?.dataModels.count == 0 {
            fetchData()
        }
    }
    
    func fetchData() {
        guard let param = sectionModel?.keyIdDetail else { return }
        if param == "" { return }
        ServiceOnline.share.getDataComment(param: param) { (snapShot) in
            guard let data = snapShot as? NSDictionary else { return }
            self.sectionModel?.dataModels.removeAll()
            
            for (_, value) in data {
                self.sectionModel?.dataModels.append(CommentModel(data: value as! [String : Any]))
            }
            self.reloadSection(animated: false, completion: nil)
        }
    }

    public override func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return userHeaderView(atIndex: index)
        case UICollectionView.elementKindSectionFooter:
            return userFooterView(atIndex: index)
        case "UICollectionElementKindSectionBackground":
            guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: "SectionBackgroundCardViewSectionBackgroundCardView",
                                                                                 for: self,
                                                                                 nibName: "CommentBackgroundCardCell",
                                                                                 bundle: nil,
                                                                                 at: index) else { return  UICollectionReusableView() }
            
            
            return view

            
        default:
            fatalError()
        }
    }
    

}
extension CommentDetailSongSectionController: MeCommentCellDelegate {
    func sendMess(string: String) {
        guard let id = sectionModel?.keyIdDetail else { return }
        ServiceOnline.share.addComment(id: id, comment: string) { _ in
            
        }
    }
    
    
}

class CommentDetailSongCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? CommentDetailSongSectionModel else { return }

        setHeaderCell(HeaderCommentDetailSongCellModel())
        for i in sectionModel.dataModels {
            let cell = CommentUserCellModel(commentModel: i)
            appendCell(cell)
        }
        
        addBlankSpace(8, width: nil, color: .clear)
        
        let meCommentCell = MeCommentCellModel()
        appendCell(meCommentCell)
        
        addBlankSpace(800, width: nil, color: .clear)

    }
}
