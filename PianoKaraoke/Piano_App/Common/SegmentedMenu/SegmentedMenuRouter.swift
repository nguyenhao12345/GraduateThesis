//
//  SegmentCustom.swift
//  LearnRxSwift
//
//  Created by Nguyen Hieu on 1/11/20.
//  Copyright © 2020 com.nguyenhieu.BaseProject. All rights reserved.
//

import UIKit

extension SegmentedMenuView: SegmentedMenuRouter {
    
    public func segmentedMenuSelected(_ index: Int){
        self.delegate?.segmentedMenu(self, index: index)
    }
    
}


extension SegmentedMenuView: SegmentedMenuModule {
    
    
    public func setDelegate(_ delegate: SegmentedMenuDelegate) {
        self.delegate = delegate
    }
    
    public func getDelegate() -> SegmentedMenuDelegate? {
        return self.delegate
    }
    
    public func getModuleData() -> SegmentedMenuDataPresenter{
        return self.presenter
    }
    public func selectIndex(_ index: Int) {
        self.presenter?.selectIndex(index)
    }
    public func scrollIndex(_ index: Int){
        self.presenter?.scrollIndex(index)
    }
}
