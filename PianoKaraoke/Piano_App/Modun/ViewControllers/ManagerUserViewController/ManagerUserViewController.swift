//
//  ManagerUserViewController.swift
//  Piano_App
//
//  Created by Azibai on 23/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class ManagerUserViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: ViewRound!

    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var searchSection: AziBaseSectionModel = ManagerUserSearchSectionModel(textSearch: "")
    var dataSource: [AziBaseSectionModel] = []
    @IBOutlet weak var navView: UIView!
    //MARK: Init

    
    override func initUIVariable() {
        super.initUIVariable()
//        self.allowAutoPlay = true
//        self.hidesNavigationbar = true
//        self.hidesToolbar = true
//        self.addPansGesture = true
//        self.colorStatusBar = .black
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = [searchSection, LoadingSectionModel()]
        viewIsReady()
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor

        // shadow
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 4.0

        ServiceOnline.share.getAllUser { (arr) in
            self.dataSource.removeAll()
            let arrSection = arr.map({ ManagerUserSectionModel(userModel: $0) })
            self.dataSource.append(self.searchSection)
            self.dataSource.append(contentsOf: arrSection)
            self.adapter.performUpdates(animated: true, completion: nil)
        }
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
    }
    
    override func loadMore() {
        
    }
    
    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        dataSource = [LoadingSectionModel()]
        self.adapter.performUpdates(animated: true, completion: nil)
        ServiceOnline.share.getAllUser { (arr) in
            self.dataSource.removeAll()
            let arrSection = arr.map({ ManagerUserSectionModel(userModel: $0) })
            self.dataSource.append(self.searchSection)
            self.dataSource.append(contentsOf: arrSection)
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    override func getScrollView() -> UIScrollView? {
        return collectionView
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .LoadMoreAndRefresh
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: ListAdapterDataSource
extension ManagerUserViewController: ListAdapterDataSource {
    
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
extension ManagerUserViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}
extension ManagerUserViewController: ManagerUserSectionDelegate {
    func remove(sectionModel: AziBaseSectionModel) {
        dataSource.removeObject(sectionModel)
        adapter.performUpdates(animated: true, completion: nil)
    }
}
