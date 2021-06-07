//
//  FeedsSectionController.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper
import FirebaseStorage
import Firebase
protocol FeedsSectionDelegate: class {
    func removeNews(by: AziBaseSectionModel)
}

class FeedsSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    var index: Int = 0
    var dataModel: NewsFeedModel?
    init(index: Int = 0, dataModel: NewsFeedModel?) {
        self.index = index
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
        return FeedsSectionController()
    }
}

class FeedsSectionController: SectionController<FeedsSectionModel> {
    
    weak var delegate: FeedsSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? FeedsSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return FeedsCellBuilder()
    }
    
    override func didSelectItem(at index: Int) {
        guard let viewController = viewController else { return }
        AppRouter.shared.gotoNewsFeedDetail(newsModel: sectionModel?.dataModel, viewController: viewController)
    }
}

extension FeedsSectionController: MeCommentCellDelegate {
    func sendMess(string: String) {
        guard let news = sectionModel?.dataModel else { return }
        let commentModel = BaseCommentModel(contentComment: string)
        ServiceOnline.share.comment(at: news, commentModel: commentModel)
//        autoAnimationHideButton()
//        uitextView.text = Const.plahoderComment
//        uitextView.endEditing(true)
        sectionModel?.dataModel?.firstComment = commentModel
        updateSection(animated: true)
    }
    
    
}
extension FeedsSectionController: NewsFeedInfoCellDelegate {
    func clickMoreBtn() {
        guard let viewController = viewController,
            let uidUser = sectionModel?.dataModel?.user?.uid else { return }
        var dataSource: [String] = []
        if uidUser != AppAccount.shared.getUserLogin()?.uid {
            dataSource = ["\tVào trang cá nhân","\tXem bài viết"]
        } else {
            dataSource = ["\tVào trang cá nhân","\tXem bài viết","\tXoá bài"]

        }
        PopupIGViewController.showAlert(viewController: viewController, title: "", dataSource: dataSource, hightLight: "", attributes: [NSAttributedString.Key.font : UIFont.HelveticaNeue16, NSAttributedString.Key.foregroundColor : UIColor.defaultText]) { (value, _) in
            switch value{
            case "\tVào trang cá nhân":
                if let userWall = viewController as? UserWallViewController {
                    if userWall.uidUser == uidUser {
                        userWall.view.shake(direction: .horizontal, duration: 0.5, animationType: .easeOut, completion: nil)
                    } else {
                        AppRouter.shared.gotoUserWall(uidUSer: uidUser, viewController: viewController)
                    }
                }
                else {
                    AppRouter.shared.gotoUserWall(uidUSer: uidUser, viewController: viewController)
                }
            case "\tXem bài viết":
                AppRouter.shared.gotoNewsFeedDetail(newsModel: self.sectionModel?.dataModel, viewController: viewController)
            case "\tXoá bài":
                guard let news = self.sectionModel?.dataModel else { return }
                ServiceOnline.share.deleteNews(news: news) { (isRemove) in
                    if isRemove {
                        self.delegate?.removeNews(by: self.sectionModel!)
                        self.viewController?.showToast(string: "Đã xoá bài viết", duration: 2.0, position: .bottom)
                    }
                }
            default: break

            }
        }
    }
}

extension FeedsSectionController: CommentUserCellDelegate {
    func commentUserCelldeleteComment(commentModel: CommentModel) {
        guard let baseComment = commentModel.baseComment,
            let news = sectionModel?.dataModel
        else { return }
        ServiceOnline.share.deleteComment(at: news, commentModel: baseComment, completionDeleCommentFirst: { isDeleteCommentFirst in
            if isDeleteCommentFirst {
//                self.parentViewController?.showToast(string: "Notifi delete CommentFirst", duration: 2.0, position: .top)

                self.sectionModel?.dataModel?.firstComment = nil
                self.updateSection(animated: true)
            }
        })
    }
}

class FeedsCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? FeedsSectionModel else { return }
        buildSc2(sectionModel: sectionModel)
        addBlankSpace(4, color: .clear)
    }
    
    func buildSc1(sectionModel: FeedsSectionModel) {
        buildInfo(sectionModel: sectionModel)
        addBlankSpace(4, width: Const.widthScreens, color: .clear)
        buildMedia(sectionModel: sectionModel)        
        buildReaction(sectionModel: sectionModel)
        buildFirstComment(sectionModel: sectionModel)
        buildComment(sectionModel: sectionModel)
    }
    
    func buildSc2(sectionModel: FeedsSectionModel) {
        buildInfo(sectionModel: sectionModel)
        buildText(sectionModel: sectionModel)
        addBlankSpace(4, width: Const.widthScreens, color: .clear)
        
        let cell = MediaDefaultCellModel()
        cell.newsModel = sectionModel.dataModel
        cell.urlImg = sectionModel.dataModel?.media?.urlImage ?? ""
        appendCell(cell)
        buildReaction(sectionModel: sectionModel)
        buildFirstComment(sectionModel: sectionModel)

        buildComment(sectionModel: sectionModel)

    }
    
    func buildFirstComment(sectionModel: FeedsSectionModel) {
        if let comment = sectionModel.dataModel?.firstComment {
            let cell = CommentUserCellModel(commentModel: CommentModel(baseComment: comment))
            cell.truncationString = Helper.getAttributesStringWithFontAndColor(string: "...Xem thêm", font: .HelveticaNeueMedium16, color: .lightGray)

            appendCell(cell)
        }
    }
    
    func buildInfo(sectionModel: FeedsSectionModel) {
        let cell = NewsFeedInfoCellModel()
        cell.userName = sectionModel.dataModel?.user?.name ?? ""
        cell.dateStr = sectionModel.dataModel?.timeAgoSinceNow ?? ""
        cell.avataStr = sectionModel.dataModel?.user?.avata ?? ""
        cell.id = sectionModel.dataModel?.user?.uid ?? ""
        cell.admin = sectionModel.dataModel?.user?.admin ?? 0
        appendCell(cell)
    }
    
    func buildText(sectionModel: FeedsSectionModel) {
        guard let text = sectionModel.dataModel?.content else { return }
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: text, font: .HelveticaNeue16, color: .defaultText), height: nil, spaceWitdh: 24, truncationString: Helper.getAttributesStringWithFontAndColor(string: "...Xem thêm", font: .HelveticaNeueMedium16, color: .lightGray), numberOfLine: 3)
    }
    
    func buildReaction(sectionModel: FeedsSectionModel) {
        let cell = NewsFeedReactionCellModel()
        cell.dataModel = sectionModel.dataModel
        appendCell(cell)
    }
    
    func buildMedia(sectionModel: FeedsSectionModel) {
        guard let text = sectionModel.dataModel?.content,
            let title = sectionModel.dataModel?.title,
            let media = sectionModel.dataModel?.media?.urlImage else { return }
        let cell = NewsFeedMediaCellModel(attributed: Helper.getAttributesStringWithFontAndColor(
            string: text, font: .HelveticaNeue16, color: .white),
                                          truncationString: Helper.getAttributesStringWithFontAndColor(string: "...Xem thêm", font: .HelveticaNeueMedium16, color: .lightGray),
                                          numberOfLine: 3,
                                          titleStr: title,
                                          urlImg: media)
        appendCell(cell)
    }
    func buildComment(sectionModel: FeedsSectionModel) {
        let cell = NewsFeedMeCommentCellModel()
        appendCell(cell)
    }
}
