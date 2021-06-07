//
//  ManagerPaymentViewController.swift
//  Piano_App
//
//  Created by Azibai on 09/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class ManagerPaymentViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navigationView: NavigationViewPayment!
    //MARK: Properties
    private var isFetchingMore: Bool = false
    private var typeSelect: ManagerPaymentSectionFactory.TYPE = .Real
    var currentPage: Int = 1
    var fromDate: Double? = 100.0
    var endDate: Double?  = 100.0

    
    var sectionFactory: ManagerPaymentSectionFactory = ManagerPaymentSectionFactory()
    
    func configSelect(type: ManagerPaymentSectionFactory.TYPE) {
        self.typeSelect = type
    }
    
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = []
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
    }
    
    //MARK: Method
    func viewIsReady() {
        let layout = SectionBackgroundCardViewLayoutPayment()
        collectionView.collectionViewLayout = layout
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
        adapter.scrollViewDelegate = self
        navigationView.delegate = self
        navigationView.config(title: "Quản lý dòng tiền", typeSelect: self.typeSelect, dataSource: sectionFactory.getListType())
    }
    
    override func loadMore() {
        isFetchingMore = true
        sectionFactory.getSectionsController(type: navigationView.getCurrentType(), currentPage: currentPage, fromDate: fromDate, endDate: endDate) { (sections) in
            self.isFetchingMore = false
            self.dataSource.append(contentsOf: sections)
            self.currentPage += 1
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        currentPage = 1
        isFetchingMore = false
        dataSource = []
        loadMore()
    }
    
    override func getScrollView() -> UIScrollView? {
        return collectionView
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .LoadMoreAndRefresh
    }
    
}

//MARK: ListAdapterDataSource
extension ManagerPaymentViewController: ListAdapterDataSource {
    
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
extension ManagerPaymentViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}
extension ManagerPaymentViewController: NavigationViewPaymentDelegate {
    
    func selectedAt(typeSection: ManagerPaymentSectionFactory.TYPE) {
        typeSelect = typeSection
        handleRefresh(refreshControl)
    }
    
    func selectedAt(index: Int) {
        
    }
    
}

extension ManagerPaymentViewController: SearchDatePaymentSectionDelegate {
    
    func searchHistory() {
        AppRouter.shared.gotoPaymentFiterHistory(viewController: self,
                                                 filter: sectionFactory.filter,
                                                 delegate: self)
    }
    
    func viewAllHistory() {
        navigationView.collectionView(navigationView.collectionView, didSelectItemAt: IndexPath(item: 2, section: 0))
    }
    
}

extension ManagerPaymentViewController: CURDPaymentAccountViewControllerDelegate {
    func updateAccountSuccess() {
        handleRefresh(self.refreshControl)
    }
}

extension ManagerPaymentViewController: AccountPaymentSectionDelegate {
    func delete(section: AziBaseSectionModel) {
        dataSource.removeObject(section)
        adapter.performUpdates(animated: true, completion: nil)
    }
}

extension ManagerPaymentViewController: PaymentFilterHistoryViewControllerDelegate {
    func updateFilter(filter: PaymentFilterHistory) {
        sectionFactory.filter = filter
        print(filter.getParam())
        handleRefresh(refreshControl)
    }
}
