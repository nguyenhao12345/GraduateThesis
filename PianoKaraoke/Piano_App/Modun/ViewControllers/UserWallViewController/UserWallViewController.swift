//
//  UserWallViewController.swift
//  Piano_App
//
//  Created by Azibai on 31/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//


import UIKit
import IGListKit
import FirebaseDatabase
import FirebaseAnalytics
import FirebaseStorage
import Firebase

class UserWallViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleNameLbl: UILabel!
    @IBOutlet weak var nav: UIView!
    //MARK: Properties
    private var isFetchingMore: Bool = false
    private var stopLoadMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = []
    var currentScore: Int!
    var currentKey: String!
    var uidUser: String = ""
    //MARK: Init
    
    init(uidUser: String = "") {
        self.uidUser = uidUser
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initUIVariable() {
        super.initUIVariable()
        self.hidesNavigationbar = true
        self.hidesToolbar = true
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nav.addShadow(location: .bottom)
        dataSource = [HeaderUserWallSectionModel(uidUser: uidUser)]
        if AppAccount.shared.getUserLogin()?.uid == uidUser {
            dataSource.append(PostNewsSectionModel())
        }
        viewIsReady()
    }
    
    //MARK: Method
    func viewIsReady() {
        let layout = SectionBackgroundCardViewLayoutDefault()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
        adapter.scrollViewDelegate = self
        getPlayer()
    }
    
    override func loadMore() {
        getPlayer()
    }
    @IBAction func clickBack(_ sender: Any?) {
        self.dismiss()
    }
    
    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentKey = nil
        self.stopLoadMore = false
        self.dataSource.removeAll()
        dataSource = [HeaderUserWallSectionModel(uidUser: uidUser)]
        if AppAccount.shared.getUserLogin()?.uid == uidUser {
            dataSource.append(PostNewsSectionModel())
        }
        getPlayer()
    }
    
    override func getScrollView() -> UIScrollView? {
        return collectionView
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .LoadMoreAndRefresh
    }
    
    func removeLoading() {
        for i in self.dataSource {
            if i is LoadingSectionModel {
                dataSource.removeObject(i)
                self.adapter.performUpdates(animated: false, completion: nil)
                return
            }
        }
    }
    
    func addLoading() {
        dataSource.append(LoadingSectionModel())
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    func getPlayer() {
        isFetchingMore = true
        addLoading()
        if currentKey == nil {
            Database.database().reference().child("UserWalls").child(uidUser).queryOrdered(byChild: "ID").queryLimited(toLast: 5).observeSingleEvent(of: .value) { (snap:DataSnapshot) in
                self.isFetchingMore = false
                self.removeLoading()
                if snap.childrenCount > 0 {
                    
                    let first = snap.children.allObjects.first as! DataSnapshot
                    
                    for (index, s) in (snap.children.allObjects as! [DataSnapshot]).enumerated() {
                        let item = s.value as! Dictionary<String,AnyObject?>
                        self.dataSource.append(FeedsSectionModel(index: 0, dataModel: NewsFeedModel(data: s.value as! [String: Any])))
                    }
                    
                    self.currentKey = first.key
                    self.currentScore = first.childSnapshot(forPath: "ID").value as! Int
                    
                    self.adapter.performUpdates(animated: true, completion: nil)
                } else {
                    self.stopLoadMore = true
                    self.dataSource.append(EmptyDataSectionModel())
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        } else {
            
            Database.database().reference().child("UserWalls").child(uidUser).queryOrdered(byChild: "ID").queryEnding(atValue: self.currentScore).queryLimited(toLast: 6).observeSingleEvent(of: .value , with: { (snap:DataSnapshot) in
                self.isFetchingMore = false
                self.removeLoading()
                
                if snap.childrenCount > 0 {
                    
                    let first = snap.children.allObjects.first as! DataSnapshot
                    
                    for (indexS, s) in (snap.children.allObjects as! [DataSnapshot]).enumerated() {
                        
                        if s.key != self.currentKey{
                            self.dataSource.append(FeedsSectionModel(index: indexS, dataModel: NewsFeedModel(data: s.value as! [String: Any])))
                            
                        }
                        
                    }
                    
                    self.currentKey = first.key
                    self.currentScore = first.childSnapshot(forPath: "ID").value as! Int
                    
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
    
    
}

//MARK: ListAdapterDataSource
extension UserWallViewController: ListAdapterDataSource {
    
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

//MARK: IGListAdapterDelegate
extension UserWallViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore && !stopLoadMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}
extension UserWallViewController: FeedsSectionDelegate {
    func removeNews(by: AziBaseSectionModel) {
        dataSource.removeObject(by)
        adapter.performUpdates(animated: true, completion: nil)
    }
}
