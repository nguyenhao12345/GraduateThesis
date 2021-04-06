//
//  NSObject+Rx.swift
//  Azibai
//
//  Created by ToanHT on 5/20/19.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import Foundation
import RxSwift
import ObjectiveC
import RxCocoa

fileprivate var disposeBagContext: UInt8 = 0

extension Reactive {
    func synchronizedBag<T>(_ action: () -> T) -> T {
        objc_sync_enter(self.base)
        let result = action()
        objc_sync_exit(self.base)
        return result
    }
}

public extension Reactive  {
    /// a unique DisposeBag that is related to the Reactive.Base instance only for Reference type
    var disposeBag : DisposeBag {
        get {
            return synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(base, &disposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(base, &disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        set {
            synchronizedBag {
                objc_setAssociatedObject(base, &disposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

public extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    func rxPlus(_ subElement: [Element.Element]) {
        var newValue = value
        newValue.append(contentsOf: subElement)
        accept(newValue)
    }
    
    func rxAppend(_ subElement: Element.Element) {
        var newValue = value
        newValue.append(subElement)
        accept(newValue)
    }
    
    func rxRemove(at index: Element.Index) {
        var newValue = value
        newValue.remove(at: index)
        accept(newValue)
    }
    
    func rxInsert(_ subElement: Element.Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(subElement, at: index)
        accept(newValue)
    }
}

extension NSObject {
    // Static Class using
    static var string: String {
        return String.init(describing: self)
    }
    
    var classNameString: String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
    
}
