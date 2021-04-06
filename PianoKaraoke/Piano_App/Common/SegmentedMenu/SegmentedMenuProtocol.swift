//
//  SegmentCustom.swift
//  LearnRxSwift
//
//  Created by Nguyen Hieu on 1/11/20.
//  Copyright © 2020 com.nguyenhieu.BaseProject. All rights reserved.
//

import Foundation
import UIKit

public class SegmentedMenuDataModel: NSObject{
    public var title: String
    public var icon: String?
    public var fullImage: Bool = false
    public var data: Any?
    
    public init(title: String, icon: String? = nil) {
        self.title = title
        super.init()
        self.icon = icon
    }
}

public protocol SegmentedMenuViewInput: class {
    // Any -> View
    // TODO: Declare view methods
    
    func getView() -> UIView
    func reloadData()
    func reloadIndex()
    func setLineHeight(_ height: CGFloat)
}


public protocol SegmentedMenuDataPresenter: class {
    // Outsite -> Presenter
    // TODO: Declare presentation methods
    func setDataSources(_ datas: [String])
    func setDataSources(models: [SegmentedMenuDataModel])
    func setFullItemWidth(_ full:Bool)
    func setLineHeight(_ height: CGFloat)
    func setDefaultIndex(_ index: Int)
    func setBadge(_ content: String?, index: Int)
    func setEnableBadge(_ enable: Bool)
    func getEnableBadge() -> Bool
    func setHeight(_ height: CGFloat)
    func getHeight() -> CGFloat
    
}


public protocol SegmentedMenuViewPresenter: SegmentedMenuDataPresenter {
    // View -> Presenter
    // TODO: Declare presentation methods
    
    func viewIsReady()
    func viewDealloc()
    func viewReappear()
    func selectIndex(_ index: Int)
    func scrollIndex(_ index: Int)
    func xForCurrentIndex() -> CGFloat
    func widthCurrentIndex() -> CGFloat
    func widthForIndex(_ index: NSInteger) -> CGFloat
    func numberOfItem() -> NSInteger
    func itemAtIndex(_ index: NSInteger) -> SegmentedMenuDataModel
    func getIndex() -> NSInteger
    func getBadgeIndex(_ index: Int) -> String?
}


public protocol SegmentedMenuInteractorInput: class {
    // Any -> Interactor
    // TODO: Declare use case methods
    
}


public protocol SegmentedMenuInteractorPresenter: class {
    // Interactor -> Presenter
    // TODO: Declare interactor output methods
    
}


public protocol SegmentedMenuRouter: class {
    // Any -> Router
    // TODO: Declare router methods
    
    func segmentedMenuSelected(_ index: Int)
    
}



public protocol SegmentedMenuDelegate: class {
    // Any -> Wireframe
    // TODO: Declare wireframe methods
    func segmentedMenu(_ segmenteg: SegmentedMenuModule, index: Int)
    
}


public protocol SegmentedMenuModule: class {
    // Any -> Module
    // TODO: Declare module methods
    
    func setDelegate(_ delegate: SegmentedMenuDelegate)
    func getDelegate() -> SegmentedMenuDelegate?
    func getView() -> UIView
    func getModuleData() -> SegmentedMenuDataPresenter
    func selectIndex(_ index: Int)
    func scrollIndex(_ index: Int)
    func reloadData()
}


public class SegmentedMenuFactory: NSObject {
    public static func create() -> SegmentedMenuModule {
        
        let module: SegmentedMenuView = SegmentedMenuView.init(frame: CGRect.zero)
        let presenter = SegmentedMenuPresenter()
        let interactor = SegmentedMenuInteractor()
        
        module.presenter =  presenter
        
        interactor.presenter = presenter
        
        presenter.view = module
        presenter.router = module
        presenter.interactor = interactor
        
        return module
    }
}
