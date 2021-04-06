//
//  NewsDetailNewsFeedCommentSectionController.swift
//  Piano_App
//
//  Created by Azibai on 02/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import IGListKit
import FirebaseDatabase
import FirebaseAnalytics
import FirebaseStorage
import Firebase

protocol NewsDetailNewsFeedCommentSectionDelegate: class {
    func deleteComment(commentModel: CommentModel, sectionModel: NewsDetailNewsFeedCommentSectionModel)
}

class NewsDetailNewsFeedCommentSectionModel: AziBaseSectionModel {
    var newsFeedModel: NewsFeedModel? = nil
    var comment: BaseCommentModel? = nil
    
    init(newsFeedModel: NewsFeedModel?) {
        self.newsFeedModel = newsFeedModel
        super.init()
    }
    init(comment: BaseCommentModel?, newsFeedModel: NewsFeedModel? = nil) {
        self.comment = comment
        self.newsFeedModel = newsFeedModel
        super.init()
    }

    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return NewsDetailNewsFeedCommentSectionController()
    }
}

class NewsDetailNewsFeedCommentSectionController: SectionController<NewsDetailNewsFeedCommentSectionModel> {
    
    weak var delegate: NewsDetailNewsFeedCommentSectionDelegate?

    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? NewsDetailNewsFeedCommentSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return NewsDetailNewsFeedCommentCellBuilder()
    }
    
    override func didUpdate(to object: Any) {
        super.didUpdate(to: object)
//        fetchDataComment()
    }

    

}
extension NewsDetailNewsFeedCommentSectionController: CommentUserCellDelegate {
    func commentUserCelldeleteComment(commentModel: CommentModel) {
        delegate?.deleteComment(commentModel: commentModel, sectionModel: sectionModel!)
    }
}

class NewsDetailNewsFeedCommentCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? NewsDetailNewsFeedCommentSectionModel else { return }
        let comment = CommentModel(baseComment: sectionModel.comment!)
        let cell = CommentUserCellModel(commentModel: comment,
                             backGroundColorContentComment: "E5E5E5",
                             tintColorDate: "F5F5F5")
        cell.truncationString = Helper.getAttributesStringWithFontAndColor(string: "...Xem thêm", font: .HelveticaNeueMedium16, color: .lightGray)
        appendCell(cell)
    }
}
