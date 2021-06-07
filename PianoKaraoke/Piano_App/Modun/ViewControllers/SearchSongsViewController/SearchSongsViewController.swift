//
//  SearchViewController.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit
import RxSwift
import RxCocoa

class SearchSongsViewController: AziBaseViewController, HotKeyWordSearchSectionDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var navigationView: SearchNavigationView!
    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var hotSection = HotKeyWordSearchSectionModel()
    private let searchingSection = SearchingSectionModel()
    var dataSource: [AziBaseSectionModel] = []


    
    override func initUIVariable() {
        super.initUIVariable()
    }
    
    func didSelectAtKeyWork(str: String) {
        var key = str
        key.capitalizeFirstLetter()
        key = removeSpace(key)
        AppRouter.shared.gotoDetailMusic(id: key.convertToEthnicLanguage(), viewController: self)
    }

    func rxSearch() {
        navigationView.textSearch
            .rx
            .text
            .skip(1)
            .debounce(0.2, scheduler : MainScheduler.instance).distinctUntilChanged().subscribe(onNext: { [weak self]  element in
            guard let self = self else { return }
                if element != "" {
                    self.hotSection.isHiddenSection = true
                    self.hotSection.sectionController?.reloadSection(animated: true, completion: { _ in
                        self.searchingSection.textSearch = element?.lowercased() ?? ""
                    })
                } else {
                    if self.hotSection.isHiddenSection {
                        self.searchingSection.textSearch = element ?? ""
                        self.hotSection.isHiddenSection = false
                        self.hotSection.sectionController?.reloadSection(animated: true, completion: nil)
                    }
                }

        }).disposed(by: rx.disposeBag)

    }
    func initDataSource() {
        dataSource = [hotSection, searchingSection]
    }
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
        viewIsReady()
        navigationView.showBtnCancel()
        navigationView.delegate = self
        
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.navigationView.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        navigationView.textSearch.becomeFirstResponder()

        rxSearch()
    }
    
    //MARK: Method
    func viewIsReady() {
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
        
    }
    
    override func getScrollView() -> UIScrollView? {
        return collectionView
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .None
    }
    
}

//MARK: ListAdapterDataSource
extension SearchSongsViewController: ListAdapterDataSource {
    
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
extension SearchSongsViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}
extension SearchSongsViewController: SearchNavigationViewDelegate {
    func clickSearch() {
//        let vc = SearchSongsViewController()
//        self.navigationController?.push(viewController: vc, transitionType: .fade, duration: 0.75)
//        self.navigationController?.isNavigationBarHidden = false

    }
    
    func clickDismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
}
