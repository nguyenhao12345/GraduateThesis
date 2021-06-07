//
//  SearchSongYoutubeViewController.swift
//  Piano_App
//
//  Created by Azibai on 16/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//
import UIKit
import IGListKit
import RxSwift
import RxCocoa
import YoutubeKit
import Toast_Swift

class SearchSongYoutubeViewController: SearchSongsViewController {
    
    //MARK: Outlets
    
    //MARK: Properties
    private var isFetchingMore: Bool = false
//    let hotSection = HotKeyWordSearchSectionModel()

    override func initDataSource() {
        dataSource = []
    }
    override init() {
        super.init()
    }
    
    func getSectionLocalSearch() -> AziBaseSectionModel {
        let keys = LocalVideoManager.shared.getCacheLocalSearch()
        return HotKeyWordSearchSectionModel(keys: keys, title: LocalVideoManager.shared.keyLocalKeyWorkSearch, isHiddenSection: keys.count == 0)
    }
    
    override func rxSearch() {
        navigationView.textSearch
            .rx
            .text
            .skip(1)
            .debounce(1, scheduler : MainScheduler.instance).distinctUntilChanged()
            .subscribe(onNext: { [weak self]  element in
            guard let self = self else { return }
                
                if element == "" {
                    self.dataSource.removeAll()
                    self.dataSource.append(self.getSectionLocalSearch())
                    self.adapter.performUpdates(animated: true, completion: nil)
                    return
                }
                
                if self.isFetching {
                    return
                } else {
                    self.requestAPIYoutubeSearch(key: element ?? "") { (dataModels) in
                      let sections = dataModels.map({ ResultSearchYoutubeSectionModel(dataModel: $0)})
                        self.dataSource.removeAll()
                        self.dataSource.append(contentsOf: sections)
                        self.adapter.performUpdates(animated: true, completion: nil)
                    }
                }

        }).disposed(by: rx.disposeBag)

    }
    
    var isFetching: Bool = false
    
    func requestAPIYoutubeSearch(key: String, completion: @escaping ([SearchResult])->()) {
        isFetching = true
        let search = SearchListRequest(part: [.id,.snippet], searchQuery: key + " cảm âm")
        YoutubeAPI.shared.send(search) { result in
            self.isFetching = false
            switch result {
            case .success(let response):
                LocalVideoManager.shared.cacheLocalKeyWorkSearch(str: key)
                completion(response.items)
            case .failed(let error):
                self.showToast(string: "Key đã hết hạn, vui lòng liên hệ Admin để gia hạn key", duration: 3.0, position: .top)
                print(error)
            }
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func loadMore() {
        
    }
    
    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        
    }
    
    override func didSelectAtKeyWork(str: String) {
        navigationView.textSearch.text = str
        navigationView.textSearch.sendActions(for: .valueChanged)
    }
}
