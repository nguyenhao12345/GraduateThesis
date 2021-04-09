//
//  CellBuilder.swift
//  Azibai
//
//  Created by Azibai on 22/11/2019.
//  Copyright © 2019 Azi IOS. All rights reserved.
//

import Foundation
import IGListKit
extension ListSectionController {
//    func getCellsDisplay() -> [UICollectionViewCell]? {
//        return collectionContext?.visibleCells(for: self)
//    }
}
public class SectionBuilder: NSObject, SectionBuilderInterface{
    
    public func getSection(object: Any?, view: AnyObject?) -> ListSectionController {
           if let section = self.getSectionInterface(object: object){
               section.setPresenter(view)
               if let sectionModel = object as? AziBaseSectionModel{
                   sectionModel.sectionController = section
               }
               return section.getSectionController()
           }
           
           if let sectionModel = object as? AziBaseSectionModel{
               if let section = sectionModel.getSectionInit(){
                   section.setPresenter(view)
                   sectionModel.sectionController = section
                   return section.getSectionController()
               }
           }
           
           return ListSectionController()
       }
    public func getSection(object: Any?, presenter: AnyObject?) -> ListSectionController {
        if let section = self.getSectionInterface(object: object){
            section.setPresenter(presenter)
            if let sectionModel = object as? AziBaseSectionModel{
                sectionModel.sectionController = section
            }
            return section.getSectionController()
        }
        
        if let sectionModel = object as? AziBaseSectionModel{
            if let section = sectionModel.getSectionInit(){
                section.setPresenter(presenter)
                sectionModel.sectionController = section
                return section.getSectionController()
            }
        }
        
        return ListSectionController()
    }
    
    public func getSectionInterface(object: Any?) -> SectionControllerInterface?{
        
        if let section = self.getLoadingSection(object){
            return section
        }
        if let section = self.getManualLoadingSection(object){
            return section
        }
        if let section = self.getBlankSection(object){
            return section
        }
        if let section = self.getEmptyDataSection(object){
            return section
        }
        return nil
    }
    
    public func getLoadingSection(_ object: Any?) -> SectionControllerInterface?{
        if object is LoadingSectionModel{
            let section = LoadingSection()
            return section
        }
        return nil
    }
    
    public func getManualLoadingSection(_ object: Any?) -> SectionControllerInterface?{
        if object is ManualLoadingSectionModel{
            let section = ManualLoadingSection()
            return section
        }
        return nil
    }
    
    public func getBlankSection(_ object: Any?) -> SectionControllerInterface?{
        if object is BlankSectionModel{
            let section = BlankSection()
            return section
        }
        return nil
    }
    
    public func getEmptyDataSection(_ object: Any?) -> SectionControllerInterface?{
        if object is EmptyDataSectionModel{
            let section = EmptyDataSection()
            return section
        }
        return nil
    }
}

open class CellBuilder: BaseCellBuilder {
    public var containerInset: UIEdgeInsets {
        return  sectionController?
                .getSectionController()
                .collectionContext?
                .containerInset ?? .zero
    }
    
    public func addProcessViewCell(heightCellView: CGFloat = 2, width: CGFloat = UIScreen.main.bounds.width) {
        let cellModel = ProcessViewCellModel()
        cellModel.height = heightCellView
        cellModel.width = width
        self.cellModels.safeAppend(cellModel)
    }
    
    public func addBottomViewCornerRadius(heightCellView: CGFloat = 12) {
        
    }
    
    public func addBlockShadow(_ height: CGFloat = 8){
        let cellModel = BlockShadowCellModel()
        self.cellModels.safeAppend(cellModel)
    }
    
    public func addEditButtonRight() {
        let cellModel = EditButtonRightCellModel()
        self.cellModels.safeAppend(cellModel)
    }
    public func addBlankSpace(_ height: CGFloat = 8, width: CGFloat? = nil, color: UIColor = UIColor.white){
        let cellModel = BlankSpaceCellModel(height: height, _width: width)
        cellModel.color = color
        
        self.cellModels.safeAppend(cellModel)
    }
    
    public func addSingleLine(_ compactMode: Bool = false){
        let cellModel = SingleLineCellModel()
        cellModel.compactMode = compactMode
        self.cellModels.safeAppend(cellModel)
    }
    
    public func addFullSingleLine(_ compactMode: Bool = false){
        let cellModel = FullLineCellModel()
        cellModel.compactMode = compactMode
        self.cellModels.safeAppend(cellModel)
    }
    
    public func addLoading(){
        let cellModel = LoadingCellModel()
        self.cellModels.safeAppend(cellModel)
    }
    
    public func addManualLoading(){
        let cellModel = ManualLoadingCellModel()
        self.cellModels.safeAppend(cellModel)
    }
    
    public func addEmpyData(_ content: String = "", background:UIColor = UIColor.clear){
        let cellModel = EmptyDataCellModel()
        cellModel.content = content
        cellModel.background = background
        self.cellModels.safeAppend(cellModel)
    }
    
    public func addSimpleText(_ att: NSMutableAttributedString, height: CGFloat? = 44, spaceWitdh: CGFloat = 0, truncationString: NSAttributedString? = nil, numberOfLine: Int = 0) {
        guard let _truncationString = truncationString else {
            let cellModel = HeaderSimpleCellModel(attributed: att, height: height, spaceWitdh: spaceWitdh, truncationString: nil, numberOfLine: numberOfLine)
            self.cellModels.safeAppend(cellModel)

            return
        }
        let cellModel = HeaderSimpleCellModel(attributed: att, height: height, spaceWitdh: spaceWitdh, truncationString: NSMutableAttributedString(attributedString: _truncationString), numberOfLine: numberOfLine)
        self.cellModels.safeAppend(cellModel)
    }
    
    open func addTopViewCornerRadius(_ height: CGFloat) {
    }
    
    open func addBottomViewCornerRadius(_ height: CGFloat) {
    }
    
    open func removeCell(at index: Int) {
        if index < 0 || index > cellModels.count - 1 {
            return
        }
        self.cellModels.remove(at: index)
    }
    
    open func removeCell(_ cell: CellModelInterface) {
        self.cellModels.removeObject(cell)
    }
    
    
    
}
