//
//  AziBaseModel.swift
//  testIgList
//
//  Created by Azibai on 22/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import Foundation
import Mapper
import IGListKit

public protocol IBaseModel: class, Mappable{
    
}

public protocol DiffBaseModel: class{
    func getDiffID() -> String
    func isNeedUpdate() -> Bool
}

extension AziBaseModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        
        if let object = object as? AziBaseModel {
            return self.getDiffID() == object.getDiffID()
        }
        return false
    }
    
    public func mergeDif(){
//        var setResult = Set<AziBaseModel>()
    }
}

extension NSObject {
    
    public static var classIdentifier: String {
        return String(describing: self)
    }
}

open class AziBaseModel: NSObject, IBaseModel, DiffBaseModel {
    //Base
    public var uid : String?
    public var diffID: String = Ultilities.randomStringKey()
    public var cellDiffID: String?
    public var needUpdate = false
    
    public required init(map: Mapper) {
        
    }
    
    open func mapping(map: Mapper) {
        uid = map.optionalFrom("msg")
    }
    
    public override init() {
        super.init()
        self.customInit()
    }
    
    open func getID() -> String?{
        return self.uid
    }
    
    open func customInit(){
        
    }
    open func getDiffID() -> String{
        return self.uid ?? self.diffID
    }
    
    open func isNeedUpdate() -> Bool {
        return self.needUpdate
    }
    
    
    
    open func propertyNames() -> [String] {
        var properties = [String]()
        
        var mirror: Mirror? = Mirror(reflecting: self)
        while mirror != nil {
            
            let keys = mirror?.children.compactMap { $0.label }
            properties.safeAppend(sequence: keys)
            if (keys?.contains("cellDiffID") ?? false){
                break
            }
            mirror = mirror?.superclassMirror
            
        }
        
        return properties
    }
    
}


public class Ultilities: NSObject {
    public static func randomKey() -> Int {
        return Int(arc4random_uniform(UInt32(100000)))
    }
    public static func randomStringKey() -> String {
        return UUID().uuidString
    }
    
}


public extension Array {
    
    @discardableResult
    func objectAtIndex(_ index:Int) -> Element?{
        if index < 0 || index >= self.count {
            return nil
        }
        return self[index]
    }
    
    @discardableResult
    func at(_ index:Int) -> Element?{
        return self.objectAtIndex(index)
    }
    
    
    @discardableResult
    func indexOfObject(_ object: Element?) -> Int?{
        guard let object = object else{
            return nil
        }
        return self.firstIndex(where: { (item) -> Bool in
            if let a = object as? NSObject,
                let b = item as? NSObject {
                return a == b
            }
            
            return false
        })
    }
    
    
    @discardableResult
    mutating func safeRemoveObject(_ object:Element?) -> Bool {
        if object == nil {
            return false
        }
        return self.removeObject(object!)
    }
    
    @discardableResult
    mutating func safeRemoveObjectID(_ object:Element?) -> Bool {
        guard let object = object as? AziBaseModel,
            let objects = self as? [AziBaseModel] else {
                return false
        }
        
        var removed = [Element]()
        objects.forEach { (item) in
            if item.getID() == object.getID(){
                removed.safeAppend(item as? Element)
            }
        }
        return self.removeObjects(removed)
    }
    
    @discardableResult
    func indexOfObjectID(_ object:Element?) -> Int? {
        guard let object = object as? AziBaseModel,
            let objects = self as? [AziBaseModel] else {
                return nil
        }
        
        var index = 0
        for item in objects{
            if item.getID() == object.getID(){
                return index
            }
            index += 1
        }
        return nil
    }
    
    @discardableResult
    mutating func safeRemoveClass<T>(_ classType:T.Type) -> [Element] {
        var remove:[Element] = []
        for item in self{
            if item is T{
                remove.append(item)
            }
        }
        self.removeObjects(remove)
        return remove
    }
    
    
    
    @discardableResult
    mutating func removeObject(_ object:Element) -> Bool {
        var result = false
        if let index = self.indexOfObject(object){
            self.remove(at: index)
            result = true
        }
        return result
    }
    
    @discardableResult
    mutating func removeObjectAndGetIndex(_ object:Element) -> (Bool,Int?) {
        var result = false
        var _index: Int?
        if let index = self.indexOfObject(object){
            self.remove(at: index)
            result = true
            _index = index
        }
        return (result, _index)
    }
    
    @discardableResult
    mutating func removeObjects(_ objects:[Element]) -> Bool  {
        var result = false
        
        for item in objects{
            self.removeObject(item)
            result = true
        }
        return result
    }
    
    mutating func safeAppend(_ object:Element?){
        if object != nil {
            self.append(object!)
        }
    }
    
    mutating func safeAppend(sequence:[Element]?){
        if sequence != nil {
            self.append(contentsOf: sequence!)
        }
    }
    
    func count(query: (Element) -> Bool) -> Int{
        var count  = 0
        
        for item in self{
            if query(item){
                count += 1
            }
        }
        return count
    }
    
    func search(query: (Element) -> Bool) -> [Element]?{
        let arrs = self.compactMap { (item) -> Element? in
            if query(item){
                return item
            }
            return nil
        }
        return arrs
    }
    
    
}
extension Array {
    //convenient NewsFeed
    
}


