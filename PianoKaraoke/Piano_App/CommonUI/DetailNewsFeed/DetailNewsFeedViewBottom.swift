
//
//  DetailNewsFeedViewBottom.swift
//  Piano_App
//
//  Created by Azibai on 02/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseDatabase
import FirebaseAnalytics
import FirebaseStorage

    
class DetailNewsFeedViewBottom: BaseView {
    public let sectionBuilder = SectionBuilder()
    @IBOutlet weak var viewAlpha: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var isFetchingMore: Bool = false
    private var stopLoadMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = []
    var currentScore: Int!
    var currentKey: String!
    var newsFeedModel: NewsFeedModel? = nil
    weak var viewController: UIViewController?
    
    func updateViewAlpha(alpha: CGFloat) {
        viewAlpha.alpha = alpha + 0.3
    }
    
    func sendComment(comment: BaseCommentModel) {
        dataSource.append(NewsDetailNewsFeedCommentSectionModel(comment: comment, newsFeedModel: newsFeedModel))
        adapter.performUpdates(animated: true) { _ in
            self.scrollToBottom(animated: true)
        }
    }
    
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(
            x: 0,
            y: self.collectionView.contentSize.height
                - self.collectionView.bounds.size.height
                + self.collectionView.contentInset.bottom)
        self.collectionView.setContentOffset(bottomOffset, animated: animated)
    }

    func viewDidLoad(newsFeedModel: NewsFeedModel?) {
        self.newsFeedModel = newsFeedModel
        viewIsReady()
    }
    
    func viewIsReady() {
        dataSource = [NewsDetailNewsFeedHeaderSectionModel(newsFeedModel: newsFeedModel)]
        viewController = self.parentViewController
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: viewController, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
        adapter.scrollViewDelegate = self
    }
    
    func fetchDataComment() {
        guard let commentId = newsFeedModel?.commentId else { return }
        isFetchingMore = true
        if currentKey == nil {
            Database.database().reference().child("CommentNews").child(commentId).queryOrdered(byChild: "ID").queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snap:DataSnapshot) in
                self.isFetchingMore = false
                if snap.childrenCount > 0 {
                    
                    let first = snap.children.allObjects.first as! DataSnapshot
                    
                    for (_, s) in (snap.children.allObjects as! [DataSnapshot]).enumerated() {
                        self.dataSource.append(NewsDetailNewsFeedCommentSectionModel(comment: BaseCommentModel(data: s.value as? [String: Any] ?? [:]), newsFeedModel: self.newsFeedModel))
                    }
                    
                    self.currentKey = first.key
                    self.currentScore = first.childSnapshot(forPath: "ID").value as? Int
                    self.adapter.performUpdates(animated: true, completion: nil)
                } else {
                    self.stopLoadMore = true
                    self.dataSource.append(EmptyDataSectionModel())
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        } else {
            
            Database.database().reference().child("CommentNews").child(commentId).queryOrdered(byChild: "ID").queryEnding(atValue: self.currentScore).queryLimited(toLast: 6).observeSingleEvent(of: .value , with: { (snap:DataSnapshot) in
                self.isFetchingMore = false
                
                if snap.childrenCount > 0 {
                    
                    let first = snap.children.allObjects.first as! DataSnapshot
                    
                    for (_, s) in (snap.children.allObjects as! [DataSnapshot]).enumerated() {
                        
                        if s.key != self.currentKey{
                            self.dataSource.append(NewsDetailNewsFeedCommentSectionModel(comment: BaseCommentModel(data: s.value as? [String: Any] ?? [:]), newsFeedModel: self.newsFeedModel))
                        }
                        
                    }
                    
                    self.currentKey = first.key
                    self.currentScore = first.childSnapshot(forPath: "ID").value as? Int
                    
                    self.adapter.performUpdates(animated: true, completion: nil)
                } else {
                    self.stopLoadMore = true
                }
                if snap.childrenCount <= 5 {
                    self.stopLoadMore = true
                }
            })
        }
    }
    
    func loadMore() {
        fetchDataComment()
    }
    
}

//MARK: IGListAdapterDelegate
extension DetailNewsFeedViewBottom: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore && !stopLoadMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}

//MARK: ListAdapterDataSource
extension DetailNewsFeedViewBottom: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return sectionBuilder.getSection(object: object, presenter: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

extension DetailNewsFeedViewBottom: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            //            let pan = scrollView.panGestureRecognizer
            scrollView.isScrollEnabled = false
            if #available(iOS 13.0, *) {
                if let vc = viewController as? DetailNewsFeedViewController {
                    vc.panGestureHandle(scrollView.panGestureRecognizer)
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    
}

extension DetailNewsFeedViewBottom: NewsDetailNewsFeedCommentSectionDelegate {
    func deleteComment(commentModel: CommentModel, sectionModel: NewsDetailNewsFeedCommentSectionModel) {
        guard let baseComment = commentModel.baseComment,
            let news = sectionModel.newsFeedModel else { return }

        ServiceOnline.share.deleteComment(at: news, commentModel: baseComment) { (isDeleteCommentFirst) in
            if isDeleteCommentFirst {
                self.parentViewController?.showToast(string: "Notifi delete CommentFirst", duration: 2.0, position: .top)
            }
            self.dataSource.removeObject(sectionModel)
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
}
