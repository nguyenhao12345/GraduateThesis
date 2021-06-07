//
//  LocalSongsViewController.swift
//  Piano_App
//
//  Created by Azibai on 15/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class LocalSongsViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = [LocalSongsSectionModel(), LocalSongsYoutubeSectionModel()]

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navLbl: UILabel!
    //MARK: Init

    
    override func initUIVariable() {
        super.initUIVariable()
//        self.allowAutoPlay = true
        self.hidesNavigationbar = true
        self.hidesToolbar = true
//        self.addPansGesture = true
//        self.colorStatusBar = .black
    }
    
    func updateLblTitle() {
        do {
            let filePath = FileManager.documentsDir()
            var fileSize : UInt64

            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
        
            fileSize = attr[FileAttributeKey.size] as! UInt64

            //if you convert to NSDictionary, you can get file size old way as well.
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            navLbl.text = "Đã tải xuống: \(fileSize) Mb"
        } catch {
            print("Error: \(error)")
        }
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
        
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.navView.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

        navLbl.text = "Đã tải xuống"
        updateLblTitle()

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
extension LocalSongsViewController: ListAdapterDataSource {
    
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
extension LocalSongsViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}

extension LocalSongsViewController: LocalSongsSectionDelegate, LocalSongsYoutubeSectionDelegate {
    func deleteFileLocalSucces() {
        updateLblTitle()
    }
    
}
