//
//  InfoUserViewController.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class InfoUserViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nav: UIView!
    @IBOutlet weak var btnEdit: UIButton!
        
    var userModel: UserModel?
    var isEdit: Bool = false {
        didSet {
            if self.view == nil || self.collectionView == nil { return }
            guard userModel != nil else { return }
            self.dataSource = [
                InfoUserDetailSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                InfoUserSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                InfoUserAddressSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                InfoUserEducationSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                InfoUserJobSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                SendOutPutEditSectionModel(userModel: self.userModel, isEdit: self.isEdit)
            ]
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }

    @IBAction func clickEdit(_ sender: Any?) {
//        self.dismiss(animated: true, completion: nil)
        isEdit = !isEdit
    }

    @IBAction func clickBack(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = [LoadingSectionModel()]
    var uidUser: String = ""
    //MARK: Init
    
    override func initUIVariable() {
        super.initUIVariable()
//        self.allowAutoPlay = true
        self.hidesNavigationbar = true
        self.hidesToolbar = true
        self.addPansGesture = true
//        self.colorStatusBar = .black
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
        fetchData()
    }
    
    //MARK: Method
    func viewIsReady() {
        nav.addShadow(location: .bottom)
        let layout = SectionBackgroundCardViewLayoutDefault()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
        adapter.scrollViewDelegate = self
        if uidUser == AppAccount.shared.getUserLogin()?.uid {
            btnEdit.isHidden = false
        } else {
            btnEdit.isHidden = true
        }
    }
    
    override func loadMore() {
        
    }
    
    func fetchData() {
        ServiceOnline.share.getDataUser(uid: uidUser) { (data) in
            guard let data = data as? [String: Any] else { return }
            self.userModel = UserModel(data: data)
            self.dataSource = [
                InfoUserDetailSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                InfoUserSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                InfoUserAddressSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                InfoUserEducationSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                InfoUserJobSectionModel(userModel: self.userModel, isEdit: self.isEdit),
                SendOutPutEditSectionModel(userModel: self.userModel, isEdit: self.isEdit)
            ]
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        dataSource = [LoadingSectionModel()]
        self.adapter.performUpdates(animated: true, completion: nil)
        fetchData()
    }
    
    override func getScrollView() -> UIScrollView? {
        return collectionView
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .LoadMoreAndRefresh
    }
    
}

//MARK: ListAdapterDataSource
extension InfoUserViewController: ListAdapterDataSource {
    
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
extension InfoUserViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}
extension InfoUserViewController: SendOutPutEditSectionDelegate {
    func done() {
        guard let uid = AppAccount.shared.getUserLogin()?.uid, let userModel = userModel else { return }
        ServiceOnline.share.changeInfoUser(uid: uid, data: userModel)
        isEdit = false
        showToast(string: "Đã cập nhật thông tin cá nhân", duration: 2.0, position: .top)
        handleRefresh(refreshControl)
    }
    
    func cancel() {
        isEdit = false
    }
    
    
}
