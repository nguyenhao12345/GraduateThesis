//
//  SectionController.swift
//  testIgList
//
//  Created by Azibai on 22/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import Foundation
import IGListKit

public protocol SectionBackGroundCardLayoutInterface {
    
}

open class SectionController<T:AziBaseModel>: ListSectionController, SectionControllerInterface, ListDisplayDelegate, ListScrollDelegate, ListSupplementaryViewSource {
    
    var isUseBackgroundCardView: Bool = false
    public func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader, UICollectionView.elementKindSectionFooter, "UICollectionElementKindSectionBackground"]
    }
    
    public func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return userHeaderView(atIndex: index)
        case UICollectionView.elementKindSectionFooter:
            return userFooterView(atIndex: index)
        case "UICollectionElementKindSectionBackground":
            if isUseBackgroundCardView {
                guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: "SectionBackgroundCardViewSectionBackgroundCardView",
                                                                                     for: self,
                                                                                     nibName: "MixMusicBackgroundCard",
                                                                                     bundle: nil,
                                                                                     at: index) else { return  UICollectionReusableView() }

                    
                return view

            } else {                
                guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: "SectionBackgroundCardViewSectionBackgroundCardView",
                                                                                     for: self,
                                                                                     nibName: "SectionBackgroundCardView",
                                                                                     bundle: nil,
                                                                                     at: index) else { return  UICollectionReusableView() }

                    
                return view
            }
            
        default:
            fatalError()
        }
    }
    
    public func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let maxW = collectionContext!.containerSize.width
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            guard let height = cellHeaderModel?.getCellHeight(maxWidth: maxW),
            let width = cellHeaderModel?.getCellWidth(maxWidth: maxW) else { return CGSize() }
            
            return CGSize(width: width, height: height)
        case UICollectionView.elementKindSectionFooter:
            guard let height = cellFooterModel?.getCellHeight(maxWidth: maxW),
                let width = cellFooterModel?.getCellWidth(maxWidth: maxW) else { return CGSize() }
            
            return CGSize(width: width, height: height)
        default:
            fatalError()
        }
    }
    // MARK: Private
    
    
    func userHeaderView(atIndex index: Int) -> UICollectionReusableView {
        guard let cellName = cellHeaderModel?.getCellName(),
            let cellModel = self.cellHeaderModel as? AziBaseCellModel else { return UICollectionReusableView() }
        
        
        let cellViewHeader = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                 for: self,
                                                                                 nibName: cellName,
                                                                                 bundle: nil,
                                                                                 at: index)
        if let cellViewInterface = cellViewHeader as? CellModelViewInterface{
            cellViewInterface.setCellModel(cellModel)
            cellViewInterface.setSectionController(self)
        }
        
        return cellViewHeader ?? UICollectionReusableView()
    }
    func userFooterView(atIndex index: Int) -> UICollectionReusableView {
        guard let cellName = cellFooterModel?.getCellName(),
            let cellModel = self.cellFooterModel?.getDataModel() as? AziBaseCellModel else { return UICollectionReusableView() }
        
        
        let cellViewFooter = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                 for: self,
                                                                                 nibName: cellName,
                                                                                 bundle: nil,
                                                                                 at: index)
        if let cellViewInterface = cellViewFooter as? CellModelViewInterface{
            cellViewInterface.setCellModel(cellModel)
            cellViewInterface.setSectionController(self)
        }
        
        return cellViewFooter ?? UICollectionReusableView()
    }
    
    
    
    
    public var cellBuilder: CellBuilderInterface?
    public weak var sectionModel: T?
    public var cellDecoration: CellModelInterface?
    public var cellHeaderModel: CellModelInterface?
    public var cellFooterModel: CellModelInterface?
    
    public var cellModels: [CellModelInterface] = []
    public weak var presenter: AnyObject?
    public var sectionDisplayCount = 0
    
    public override init() {
        super.init()
        self.cellBuilder = self.getCellBuilder()
        self.customInit()
        self.displayDelegate = self
        self.scrollDelegate = self
        self.supplementaryViewSource = self
        
    }
    
    //MARK: ListScrollDelegate
    public func listAdapter(_ listAdapter: ListAdapter, didEndDeceleratingSectionController sectionController: ListSectionController) {
        //       guard let clsView = collectionContext else { return }
        //        ASVideoPlayerController.sharedVideoPlayer.pausePlayVideoVertical(collectionContext: clsView,
        //                                    listSectionController: self)
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, didEndDragging sectionController: ListSectionController, willDecelerate decelerate: Bool) {
        //        if !decelerate {
        //        guard let clsView = collectionContext else { return }
        //        ASVideoPlayerController.sharedVideoPlayer.pausePlayVideoVertical(collectionContext: clsView,
        //                                    listSectionController: self)
        //        }
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, willBeginDragging sectionController: ListSectionController) {
        
    }
    
    //MARK: ListDisplayDelegate
    public func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, didScroll sectionController: ListSectionController) {
        self.sectionWillDisplay()
        self.sectionDisplayCount += 1
        //        guard let clsView = collectionContext else { return }
        //        ASVideoPlayerController.sharedVideoPlayer.pausePlayVideoVertical(collectionContext: clsView,
        //        listSectionController: self)
        //        print(collectionContext?.visibleCells(for: self))
        //        let cells = collectionContext.visibleCells(for: listSectionController).sorted(by: { (cell1, cell2) -> Bool in
        //            cell1.frame.maxY < cell2.frame.maxY
        //        }).compactMap({ $0 as? VideoPlayableViewContainer }).filter({ $0.canPlay && $0.isAutoPlayVideo
        //            })
        //        print(<#T##items: Any...##Any#>)
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        self.sectionDidEndDisplaying()
    }

    public func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        self.sectionWillDisplay()
        self.sectionDisplayCount += 1
        if let baseCell = cell as? CellModelViewInterface {
            baseCell.willDisplay()
        }
//        if let cellVideo = cell as? VideoPlayableViewContainer {
//            cellVideo.playVideo()
//        }
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        self.sectionDidEndDisplaying()
        if let baseCell = cell as? CellModelViewInterface {
            baseCell.didEndDisplaying()
        }
        if let cellVideo = cell as? VideoPlayableViewContainer {
            cellVideo.deactive()
        }
    }
    
    open func customInit() {
        
    }
    
    deinit {
        print("\(String(describing: self)) section controller model deinit")
    }
    
    
    open func getCellBuilder() -> CellBuilderInterface?{
        return BaseCellBuilder()
    }
    
    // MARK: - SectionControllerInterface
    // custom set prensenter delegate
    @nonobjc  public func setPresenter(_ presenter: AnyObject?){
        self.presenter = presenter
    }
    
    public func getPresenter() -> AnyObject? {
        return self.presenter
    }
    
    open func getSectionController() -> ListSectionController {
        return self
    }
    
    public func getCellModels() -> [CellModelInterface] {
        return self.cellModels
    }
    
    public func indexOf(cellModel: CellModelInterface?) -> Int? {
        guard let cellModel = cellModel else { return nil }
        return self.cellModels.indexOfObject(cellModel)
    }
    
    public func indexOf(dataModel: AziBaseModel?) -> Int? {
        guard let dataModel = dataModel else { return nil }
        var index = 0
        for item in self.cellModels{
            if let itemModel = item.getDataModel() as? AziBaseModel {
                if itemModel == dataModel {
                    return index
                }
            }
            index += 1
        }
        return nil
    }
    
    open func getSectionModel() -> Any? {
        return self.sectionModel
    }
    
    public func cellModelAtIndex(_ index:Int) -> CellModelInterface? {
        return self.cellModels.objectAtIndex(index)
    }
    
    public func reloadCellByDIffID(_ diffID: String?, animated: Bool = false) {
        if let index = self.cellModelIndexByDiffID(diffID){
            self.reloadCell(index: index, animated: animated)
        }
    }
    
    public func cellModelByDiffID(_ diffID: String?) -> CellModelInterface? {
        guard let diffID = diffID else { return nil }
        let cells = self.getCellModels()
        
        for cell in cells {
            if cell.getDiffID() == diffID {
                return cell
            }
        }
        return nil
    }
    
    public func cellModelIndexByDiffID(_ diffID: String?) -> Int? {
        guard let diffID = diffID else { return nil }
        let cells = self.getCellModels()
        var count = 0
        for cell in cells {
            if cell.getDiffID() == diffID {
                return count
            }
            count += 1
        }
        return nil
    }
    
    public func indexOf(diffID: String?) -> Int? {
        guard let diffID = diffID else { return nil }
        var index = 0
        for item in self.cellModels{
            if item.getDiffID() == diffID {
                return index
            }
            index += 1
        }
        return nil
    }
    
    public func reloadCellByDiffID(_ diffID: String?, animated: Bool = false) {
        if let index = self.cellModelIndexByDiffID(diffID) {
            self.reloadCell(index: index, animated: animated)
        }
    }
    
    public func reloadCell(cellModel: CellModelInterface?, animated: Bool = false) {
        self.reloadCell(cellModel: cellModel, animated: animated, completion: nil)
    }
    
    public func reloadCell(cellModel: CellModelInterface?, animated: Bool, completion: ((Bool) -> Void)?) {
        if let index = self.indexOf(cellModel: cellModel) {
            self.reloadCell(index: index, animated: animated, completion: completion)
        }
    }
    
    public func reloadCells(cellModels: [CellModelInterface], animated: Bool = false) {
        self.reloadCells(cellModels: cellModels, animated: animated, completion: nil)
    }
    
    public func reloadCells(cellModels: [CellModelInterface], animated: Bool, completion: ((Bool) -> Void)?) {
        var indexs = [Int]()
        cellModels.forEach { (item) in
            if let index = self.indexOf(cellModel: item) {
                indexs.append(index)
            }
        }
        if indexs.count > 0 {
            self.reloadCells(indexs: indexs, animated: animated, completion: completion)
        }
    }
    
    public func reloadCell(diffID: String?) {
        guard let diffID = diffID else { return }
        if let index = self.indexOf(diffID: diffID) {
            self.collectionContext?.performBatch(animated: true, updates: { (context) in
                context.reload(in: self, at: IndexSet(integer: index))
            }, completion: nil)
        }
    }
    
    public func refreshSection(animated: Bool) {
        self.refreshSection(animated: animated, completion: nil)
    }
    
    public func refreshSection(animated: Bool, completion: ((Bool) -> Void)?) {
        self.reloadSection(animated: animated, completion: completion)
    }
    
    public func reloadSection(animated: Bool, completion: ((Bool) -> Void)?) {
        self.parseCellModels()
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(self)
        }, completion: completion)
    }
    
    public func updateSection() {
        self.updateSection(animated: true)
    }
    
    
    public func insertLastCell(_ cell: CellModelInterface?, animated: Bool = false) {
        let index = cellModels.count
        self.insertCell(cell, index: index, animated: animated)
    }
    
    public func insertCell(_ cell: CellModelInterface?, index: Int, animated: Bool) {
        guard let cell = cell else { return }
        if index < 0 { return }
        if cellModels.count < index { return }
        
        cellModels.insert(cell, at: index)
        let indxs = IndexSet([index])
        
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.insert(in: self, at: indxs)
        }, completion: nil)
    }
    
    public func removeCell(_ cell: CellModelInterface?, animated: Bool) {
        guard let cell = cell else { return }
        
        let indxs = IndexSet([(cellModels.indexOfObject(cell) ?? 0)])
        cellModels.removeObject(cell)
        
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.delete(in: self, at: indxs)
        }, completion: nil)
    }
    
    
    public func updateSection(animated: Bool) {
        self.updateSection(animated:animated, completion: nil)
    }
    
    public func updateSection(animated: Bool, completion: ((Bool) -> Void)?) {
        
        var oldArray: [CellModelInterface] = []
        oldArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        self.parseCellModels()
        
        var newArray: [CellModelInterface] = []
        newArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        let diff = ListDiff(oldArray: oldArray, newArray: self.cellModels, option: .equality)
        let deletes = diff.deletes
        let inserts = diff.inserts
        let updates = diff.updates
        let moves = diff.moves
        //Những cell model cũ vẫn phải giữ lại, vì nó đang được sử dụng để hiển thị ở section
        var merges: [CellModelInterface] = []
        for n in newArray {
            var add = true
            for o in oldArray {
                if n.getDiffID() == o.getDiffID() {
                    merges.append(o)
                    add = false
                    break
                }
            }
            if add {
                merges.append(n)
            }
        }
        self.cellModels = merges
        
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(in: self, at: updates)
            context.delete(in: self, at: deletes)
            context.insert(in: self, at: inserts)
            moves.forEach({ (index) in
                context.move(in: self, from: index.from, to: index.to)
            })
        }, completion: completion)
    }
    
    public func updateSectionOld(animated: Bool, completion: ((Bool) -> Void)?) {
        var oldArray: [CellModelInterface] = []
        oldArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        var needUpdates: [Int] = []
        var count = 0
        for item in oldArray{
            if item.isNeedUpdate(){
                needUpdates.append(count)
            }
            count += 1
        }
        if needUpdates.count > 0 {
            let indexset = IndexSet(needUpdates)
            self.collectionContext?.performBatch(animated: animated, updates: { (context) in
                context.reload(in: self, at: indexset)
            }, completion: { (finished) in
                self.updateSectionWithOutUpdate(animated: animated, completion: completion)
            })
        }
        else {
            self.updateSectionWithOutUpdate(animated: animated, completion: completion)
        }
    }
    
    func updateSectionWithOutUpdate(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        
        var oldArray: [CellModelInterface] = []
        oldArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        self.parseCellModels()
        
        var newArray: [CellModelInterface] = []
        newArray.safeAppend(sequence: self.cellBuilder?.getCellModels())
        
        var merges: [CellModelInterface] = []
        for n in newArray{
            var add = true
            for o in oldArray{
                if n.getDiffID() == o.getDiffID() {
                    merges.append(o)
                    add = false
                    break
                }
            }
            if add { merges.append(n) }
        }
        self.cellModels = merges
        
        let diff = ListDiff(oldArray: oldArray, newArray: self.cellModels, option: .equality)
        let deletes = diff.deletes//self.createIndexSetFromPaths(diff.deletes)
        let inserts = diff.inserts//self.createIndexSetFromPaths(diff.inserts)
        let updates = diff.updates//self.createIndexSetFromPaths(diff.updates)
        
        let deleteArray = Array(deletes)
        for item in deleteArray{
            if item > (oldArray.count - 1) || item < 0 { return }
        }
        let updateArray = Array(updates)
        for item in updateArray{
            if item > (merges.count - 1) || item < 0 { return }
        }
        
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.delete(in: self, at: deletes)
            context.insert(in: self, at: inserts)
            context.reload(in: self, at: updates)
        }, completion: completion)
    }
    
    public func createIndexSetFromPaths(_ paths: [IndexPath]) -> IndexSet{
        let cmp = paths.compactMap { (item) -> Int? in
            return item.item
        }
        let set = IndexSet(cmp)
        return set
    }
    
    public func parseCellModels() {
        self.cellBuilder?.clearCellModels()
        self.cellBuilder?.parseCellModels()
//        if let cellModels = self.cellBuilder?.getCellModels() {
//            self.cellModels = cellModels
//        }
        if let cellHeader = self.cellBuilder?.getCellHeader() {
            self.cellHeaderModel = cellHeader
        }
        if let cellFooter = self.cellBuilder?.getCellFooter() {
            self.cellFooterModel = cellFooter
        }
        
        if let cellModels = self.cellBuilder?.getCellModels() {
            cellModels.first?.topMargin = Margin_Default
            cellModels.last?.bottomMargin = Margin_Default
            self.cellModels = cellModels
        }
    }
    
    // MARK: - Datasources
    open override func didUpdate(to object: Any) {
        self.sectionModel = object as? T
        self.cellBuilder?.setSectionModel(object, sectionController: self)
        self.parseCellModels()
        if let obj = self.sectionModel{
            self.didUpdateSectionModel(obj)
        }
    }
    
    open func didUpdateSectionModel(_ object: T) {
        
    }
    
    open override func numberOfItems() -> Int {
        return cellModels.count
    }
    
//    open override func sizeForItem(at index: Int) -> CGSize {
//        let maxWidth = collectionContext!.containerSize.width
//        guard  let cellModel = self.cellModels.objectAtIndex(index)else{
//            return CGSize(width: maxWidth, height: 0)
//        }
//        let height = cellModel.getCellHeight(maxWidth: maxWidth)
//        let width = cellModel.getCellWidth(maxWidth: maxWidth)
//        return CGSize(width: width, height: height)
//    }
    
    open override func sizeForItem(at index: Int) -> CGSize {
        let inset = collectionContext!.containerInset
        let maxWidth = (collectionContext?.containerSize.width)!
            - inset.left - inset.right
        
        guard  let cellModel = self.cellModels.objectAtIndex(index)else{
            return CGSize(width: collectionContext?.containerSize.width ?? 0, height: 0)
        }

        if sectionModel is SectionBackGroundCardLayoutInterface {
            
            var width = cellModel.getCellWidth(maxWidth: maxWidth)
            if width >= maxWidth {
                width = maxWidth
            }
            let height = cellModel.getCellHeight(maxWidth: maxWidth) + cellModel.topMargin + cellModel.bottomMargin
            return CGSize(width: width, height: height)

        }
        else {
            var width = cellModel.getCellWidth(maxWidth: (collectionContext?.containerSize.width)!)
            if width >= maxWidth {
                width = maxWidth
            }
            let height = cellModel.getCellHeight(maxWidth: (collectionContext?.containerSize.width)!)
            return CGSize(width: width, height: height)
        }
        
    }

    
    open override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellModel = self.cellModels.objectAtIndex(index) ?? AziBaseCellModel()
        let cellName = cellModel.getCellName()
        let cellView = collectionContext!.dequeueReusableCell(withNibName: cellName, bundle: nil, for: self, at: index)
        if let cellViewInterface = cellView as? CellModelViewInterface{
            cellViewInterface.setCellModel(cellModel)
            cellViewInterface.setSectionController(self)
        }
        return cellView
    }
    
    open func sectionWillDisplay() {
        
    }
    
    open func sectionDidEndDisplaying() {
        
    }
}

extension ListSectionController {
    
    public func invalidateSection() {
        self.collectionContext?.invalidateLayout(for: self, completion: nil)
    }
    
    public func reloadSection(animated: Bool = true){
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(self)
        }, completion: nil)
    }
    
    public func reloadCell(index: Int, animated: Bool) {
        self.reloadCell(index: index, animated: animated, completion: nil)
    }
    
    public func reloadCell(index: Int, animated: Bool = false, completion: ((Bool) -> Void)?) {
        self.reloadOneCell(index: index, animated: animated, completion: completion)
    }
    
    public func reloadCells(indexs: [Int], animated: Bool) {
        self.reloadCells(indexs: indexs, animated: animated, completion: nil)
    }
    
    public func reloadOneCell(index: Int, animated: Bool = false, completion: ((Bool) -> Void)?) {
        if index < 0 {
            return
        }
        if let section = self as? SectionControllerInterface,
            let cell = section.cellModelAtIndex(index) {
            cell.clearData()
        }
        let indexSet = IndexSet(arrayLiteral: index)
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(in: self, at: indexSet)
        }, completion: completion)
        
    }
    
    public func reloadCells(indexs: [Int], animated: Bool = false, completion: ((Bool) -> Void)?) {
        for index in indexs {
            if index < 0 {
                return
            }
        }
        if let section = self as? SectionControllerInterface{
            let cells = section.getCellModels()
            indexs.forEach { (index) in
                cells.objectAtIndex(index)?.clearData()
            }
        }
        let indexSet = IndexSet(integer: 0)
        self.collectionContext?.performBatch(animated: animated, updates: { (context) in
            context.reload(in: self, at: indexSet)
        }, completion: completion)
    }
}



class CustomFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)
        
        for section in 0..<collectionView!.numberOfSections{
            let backgroundLayoutAttributes:UICollectionViewLayoutAttributes = layoutAttributesForSupplementaryView(ofKind: "UICollectionElementKindSectionBackground", at: IndexPath(item: 0, section: section)) ?? UICollectionViewLayoutAttributes()
            attributes?.append(backgroundLayoutAttributes)
        }
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        if elementKind == "UICollectionElementKindSectionBackground"{
            attrs.size = collectionView!.contentSize
            
            //calculate frame here
            let items = collectionView!.numberOfItems(inSection: indexPath.section)
            let totalSectionHeight:CGFloat = CGFloat(items * 200)
            let cellAttr = collectionView!.layoutAttributesForItem(at: indexPath)
            attrs.frame = CGRect(x: 0, y: cellAttr!.frame.origin.y - 12, width: collectionView!.frame.size.width, height: totalSectionHeight)

            
//            let first = IndexPath(item: 0, section: indexPath.section)
//            var lastIndex = indexPath.item - 1
//            if lastIndex < 0 {
//                lastIndex = 0
//            }
//            let last = IndexPath(item: lastIndex, section: indexPath.section)
//            let firstFrame = collectionView?.layoutAttributesForItem(at: first)?.frame ?? .zero
//            let lastFrame = collectionView?.layoutAttributesForItem(at: last)?.frame ?? .zero
//
//
//            let sectionFrame = firstFrame.union(lastFrame)
////            attrs.frame = sectionFrame
//            attrs.frame = CGRect(x: 0, y: 0, width: collectionView!.frame.size.width, height: sectionFrame.height)

            attrs.zIndex = -10
            return attrs
        }else{
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
    }
}
