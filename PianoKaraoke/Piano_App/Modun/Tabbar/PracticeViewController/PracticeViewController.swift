//
//  PracticeViewController.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class PracticeViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigationView: SearchNavigationView!
    
    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = [
        FeedHeaderSectionModel(),
        FeedStyleInstrumentSectionModel(),
        VietSongsSectionModel(key: "DanhChoNguoiMoiBatDau"),
        TopMussicSectionModel(),
        MixMusicSectionModel(),
    ]


    
    override func initUIVariable() {
        super.initUIVariable()
        self.hidesNavigationbar = true
        self.hidesToolbar = true
    }
    lazy var viewBackgroundCls: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.hexStringToUIColor(hex: AppColor.shared.colorBackGround.value, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    var heightConstraint: NSLayoutConstraint!
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewIsReady()
        navigationView.hiddenBtnCancel()
        navigationView.delegate = self

        collectionView.clipsToBounds = false
        
        collectionView.backgroundColor = .clear
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true

        containerView.addSubview(viewBackgroundCls)
        viewBackgroundCls.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        heightConstraint = viewBackgroundCls.heightAnchor.constraint(equalToConstant: 280)
        heightConstraint.isActive = true
        viewBackgroundCls.rightAnchor.constraint(equalTo: collectionView.rightAnchor, constant: 0).isActive = true
        viewBackgroundCls.leftAnchor.constraint(equalTo: collectionView.leftAnchor, constant: 0).isActive = true
        viewBackgroundCls.layer.zPosition = -1

        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.navigationView.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.viewBackgroundCls.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
    
        heightConstraint.constant = 280 - scrollView.contentOffset.y

    }
    let layout = CustomFlowLayout()

    //MARK: Method
    func viewIsReady() {
        collectionView.collectionViewLayout = layout
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
        dataSource.removeAll()
        adapter.performUpdates(animated: true, completion: nil)

        dataSource = [
            FeedHeaderSectionModel(),
            FeedStyleInstrumentSectionModel(),
            VietSongsSectionModel(key: "DanhChoNguoiMoiBatDau"),
            TopMussicSectionModel(),
            MixMusicSectionModel(),
        ]
        
        adapter.performUpdates(animated: true, completion: nil)
        
    }
    
    override func getScrollView() -> UIScrollView? {
        return collectionView
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .LoadMoreAndRefresh
    }
    
}

//MARK: ListAdapterDataSource
extension PracticeViewController: ListAdapterDataSource {
    
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
extension PracticeViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}

extension PracticeViewController: SearchNavigationViewDelegate {
    func clickSearch() {
        let vcOld = self
        let vc = SearchSongsViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false) {
            vcOld.navigationView.hiddenBtnCancel()
        }
    }
    
    func clickDismiss() {
        
    }
    
}
extension PracticeViewController: MixMusicSectionDelegate {
    func scrollToTop() {
        guard let obj = dataSource[safe: dataSource.count - 1] else { return }
        adapter.scroll(to: obj, supplementaryKinds: [UICollectionView.elementKindSectionHeader], scrollDirection: .vertical, scrollPosition: .top, animated: true)
    }
}
    


