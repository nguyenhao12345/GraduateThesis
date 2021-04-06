//
//  DetailSongViewController.swift
//  Piano_App
//
//  Created by Azibai on 14/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

class DetailSongViewController: AziBaseViewController {
    
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnDownLoad: UIButton!
    let layout = CustomFlowLayout()

    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = []
    var keyIdDetail: String = ""
    var dataModel: DetailInfoSong?
    var oldFrameAnimation: CGRect? = nil
    var currentFrameAnimation: CGRect? = nil
    var imageMusic: UIImage?
    
    
    //MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
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
        if keyIdDetail == "" {
            dataSource = [DetailSongSectionModel(dataModel: dataModel, keyIdDetail: keyIdDetail, imageMusic: imageMusic)]
        } else {
            dataSource = [DetailSongSectionModel(dataModel: dataModel, keyIdDetail: keyIdDetail, imageMusic: imageMusic),
                          CommentDetailSongSectionModel(keyIdDetail: keyIdDetail, dataModels: [])
            ]
        }
        viewIsReady()

        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.viewContainer.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }
    
    @IBAction func clickDownLoad(_ sender: Any?) {
        guard let sectionFirst = dataSource.first as? DetailSongSectionModel else { return }
        guard let dataDic = sectionFirst.data,
                let key = sectionFirst.dataModel?.nameSong,
                let mp4 = sectionFirst.dataModel?.urlMp4 else { return }
        
        if LocalVideoManager.shared.getAllLocalSongs().map({ $0.nameSong }).contains(key) {
            self.showToast(string: "Bạn đã tải xuống bài hát này", duration: 2.0, position: .top)
            return
        }
        
        LocalVideoManager.shared.cacheObjectLocal(data: dataDic, key: key, mp4: mp4)
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        guard let oldF = oldFrameAnimation,
            let currentF = currentFrameAnimation,
            let img = imageMusic else {
                self.dismiss(animated: false, completion: nil)
                return }
        
        guard let sectionFirst = dataSource.first as? DetailSongSectionModel,
            let cellModel = sectionFirst.sectionController?.cellModelByDiffID(sectionFirst.idCellCover) as? DetailMediaCellModel,
            let cellView = cellModel.getCellView() as? DetailMediaCell else {
                self.dismiss(animated: true, completion: nil)
                return }

        if !cellView.isDisplay {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        cellView.alpha = 0
        AppRouter.shared.dismissAnimation(currentFrame: cellView.globalFrame ?? currentF, oldFrame: oldF, image: img, viewController: self)
    }
    //MARK: Method
    func viewIsReady() {
        collectionView.collectionViewLayout = layout
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
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
        return .HaveLoadMore
    }
    
}

//MARK: ListAdapterDataSource
extension DetailSongViewController: ListAdapterDataSource {
    
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
extension DetailSongViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}
