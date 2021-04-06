//
//  AziBaseCellModel.swift
//  testIgList
//
//  Created by Azibai on 22/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import IGListKit

open class AziBaseCellModel: NSObject, CellModelInterface, DiffBaseModel {
    private weak var sectionControler: SectionControllerInterface?
    public var compactMode = false
    public var disable = false
    public var needUpdate = false
    public var customTag = 0
    public var index = 0
    public var diffID: String!
    public var enableBottomLine = false
    public var enableTopLine = false
    public var diffExtension: String = ""
    public var diffExtensionIndex: Int = 0
    public static var minHeaderHeight: CGFloat = 56
    
    public var topMargin: CGFloat = 0
    public var bottomMargin: CGFloat = 0
    public var leftMargin: CGFloat = 0
    public var rightMargin: CGFloat = 0

    private var _mVersion: Int = 0
    private var _mDiffID = Ultilities.randomStringKey()
    
    public override init() {
        super.init()
        self.generateDiffID()
    }
    deinit {
//        print("denit AziBaseCellModel \(String(describing: self))")
    }
    public var finalHeight: CGFloat = -1
    
    public weak var cellView: CellModelViewInterface?
    
    open func setCellView(_ view: CellModelViewInterface?) {
        self.cellView = view
    }
    
    open func getCellView() -> CellModelViewInterface?{
        return self.cellView
    }
    
    open func setDiffObject(_ obj: DiffBaseModel?){
        guard let diffID = obj?.getDiffID() else{
            return
        }
        self.updateDiffID(diffID)
        
    }
    
    open func updateDiffID(_ diffID: String){
        self._mDiffID = diffID
        self.generateDiffID()
    }
    
    private func generateDiffID(){
        self.diffID = "\(_mDiffID)_\(diffExtension)_\(diffExtensionIndex)_v\(_mVersion)"
    }
    
    open func diffIdentifier() -> NSObjectProtocol {
        return self.getDiffID() as NSObjectProtocol
    }
    
    open func updateDataVersion(){
        _mVersion += 1
        self.generateDiffID()
    }
    
    open func clearData(){
        finalHeight = -1
    }
    
    open func isNeedUpdate() -> Bool {
        return self.needUpdate
    }
    
    public func showBottomLine() -> Bool {
        return self.enableBottomLine
    }
    
    public func showTopLine() -> Bool {
        return self.enableTopLine
    }
    
    open func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        
        if let object = object as? AziBaseCellModel {
            return self.getDiffID() == object.getDiffID()
        }
        return false
    }
    
    public func getCustomtag() -> Int {
        return self.customTag
    }
    
    open func getDiffID() -> String{
        return self.diffID
    }
    
    open func reloadCell(_ animated: Bool = false){
        self.sectionControler?.reloadCell(cellModel: self, animated: animated)
    }
    open func invalidateCell(){
        self.sectionControler?.invalidateSection()
    }
    
    open func updateCell(){
        self.cellView?.update()
    }
    
    open func updateSection(animated: Bool = true){
        self.sectionControler?.updateSection(animated: animated)
    }
    open func reloadSection(animated: Bool = true){
        self.sectionControler?.reloadSection(animated: animated)
    }
    open func refreshSection(animated: Bool = true){
        self.sectionControler?.refreshSection(animated: animated)
    }
    
    open func invalidateSection(){
        self.sectionControler?.invalidateSection()
    }
    
    //    open func getCellView() -> UICollectionViewCell?{
    //
    //        if let model = self as? CellModelInterface{
    //            return self.baseDelegate?.getCellView(model:model)
    //        }
    //        return nil
    //    }
    
    open func getCompactFixedWidth() -> CGFloat{
        return self.compactMode ? 32 : 0
    }
    
    open func getCompactMode() -> Bool{
        return self.compactMode
    }
    
    @nonobjc open func setCompactMode(_ compact: Bool){
        self.compactMode = compact
    }
    
    
    open func getDataModel() -> Any?{
        return nil
    }
    
    open func setSectionController(_ section: Any?){
        self.sectionControler = section as? SectionControllerInterface
    }
    
    open func getSectionController() -> SectionControllerInterface?{
        return self.sectionControler
    }
    
    open func getCellHeight(maxWidth:CGFloat) -> CGFloat{
        return 0
    }
    
    open func getCellWidth(maxWidth:CGFloat) -> CGFloat{
        return maxWidth
    }
    open func getCellName() -> String{
        let modelName = String(describing: type(of: self)).replacingOccurrences(of: "Model", with: "")
        
        return modelName
    }
    open func getData() -> Any?{
        return nil
    }
    
    open func isDisable() -> Bool{
        return self.disable
    }
    
    @nonobjc open func setDisable(_ disable: Bool){
        self.disable = disable
        self.updateDataVersion()
    }
    
    
}

public protocol CellModelInterface: ListDiffable, DiffBaseModel {
    func setSectionController(_ section: Any?)
    func getSectionController() -> SectionControllerInterface?
    func getCellHeight(maxWidth:CGFloat) -> CGFloat
    func getCellWidth(maxWidth:CGFloat) -> CGFloat
    func getCellName() -> String
    func getDataModel() -> Any?
    func getCompactMode() -> Bool
    func setCompactMode(_ compact: Bool)
    func isDisable() -> Bool
    func setDisable(_ disable: Bool)
    func setCellView(_ view: CellModelViewInterface?)
    func getCellView() -> CellModelViewInterface?
    func getCustomtag() -> Int
    func showBottomLine() -> Bool
    func showTopLine() -> Bool
    func updateDataVersion()
    func reloadCell(_ animated: Bool)
    func clearData()
    var topMargin: CGFloat { get set }
    var bottomMargin: CGFloat { get set }
    var leftMargin: CGFloat { get set }
    var rightMargin: CGFloat { get set }

}

public protocol CellModelViewInterface: class {
    func setCellModel(_ cellModel: Any?)
    func setSectionController(_ sectionController: SectionControllerInterface?)
    func update()
    func willDisplay()
    func didEndDisplaying()
}
public let CornerRadius_CardView: CGFloat = 18
public let Margin_Default: CGFloat = 9
public let Margin_Horizontal: CGFloat = 16

open class CellModelView<T:CellModelInterface>: UICollectionViewCell, CellModelViewInterface {
    
    var compactMode = false
    weak var bottomSeperatorLineView: UIView?
    weak var topSeperatorLineView: UIView?
    public weak var sectionController: SectionControllerInterface?
    
    var cellModel:T?
    
    public var isDisplay: Bool = false
    
    open func bindCellModel(_ cellModel: T){
        cellModel.setCellView(self)
        self.contentView.alpha = cellModel.isDisable() ? 0.5 : 1
        self.isUserInteractionEnabled = !cellModel.isDisable()
        self.cellModel = cellModel
        self.setCompactMode(cellModel.getCompactMode())
        
        if cellModel.getSectionController()?.getSectionModel() is SectionBackGroundCardLayoutInterface {
            setCompactMode2(cellModel.topMargin != 0 ||
            cellModel.bottomMargin != 0 ||
            cellModel.leftMargin != 0 ||
            cellModel.rightMargin != 0)
        }
        
        self.layoutIfNeeded()
        
        if cellModel.showBottomLine(){
            if self.bottomSeperatorLineView == nil{
                let line = UIView.init(frame: CGRect(x: 0, y: self.bounds.size.height - 0.5, width: self.bounds.size.width, height: 0.5))
                line.backgroundColor = UIColor.groupTableViewBackground
                self.addSubview(line)
                line.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
                self.bottomSeperatorLineView = line
            }
        }else{
            self.bottomSeperatorLineView?.removeFromSuperview()
        }
        
        if cellModel.showTopLine(){
            if self.topSeperatorLineView == nil{
                let line = UIView.init(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 0.5))
                line.backgroundColor = UIColor.groupTableViewBackground
                self.addSubview(line)
                line.autoresizingMask = [.flexibleTopMargin, .flexibleWidth]
                self.topSeperatorLineView = line
            }
        }else{
            self.topSeperatorLineView?.removeFromSuperview()
        }
    }
    
    @nonobjc open func setCompactMode2(_ mode: Bool){
        let topCst = self.contentView.subviews.first?.findConstraint(layoutAttribute: .top)
        let bottomCst = self.contentView.subviews.first?.findConstraint(layoutAttribute: .bottom)
        
        topCst?.constant = cellModel?.topMargin ?? 0
        bottomCst?.constant = cellModel?.bottomMargin ?? 0
        
        if cellModel?.bottomMargin == Margin_Default && cellModel?.topMargin == Margin_Default {
            layoutIfNeeded()
//            self.contentView.subviews.first?.roundCorners([.bottomLeft,
//                                                           .bottomRight,
//                                                           .topRight,
//                                                           .topLeft], radius: CornerRadius_CardView)
        } else {
            layoutIfNeeded()
            if cellModel?.bottomMargin == Margin_Default {
                self.contentView.subviews.first?.roundCorners([.bottomLeft,
                                                               .bottomRight], radius: CornerRadius_CardView)
                
                
            }
            if cellModel?.topMargin == Margin_Default {
                self.contentView.subviews.first?.roundCorners([.topRight,
                                                               .topLeft], radius: CornerRadius_CardView)
            }
            
        }
    }
    open override func prepareForReuse() {
        super.prepareForReuse()
//        let topCst = self.contentView.subviews.first?.findConstraint(layoutAttribute: .top)
//        let bottomCst = self.contentView.subviews.first?.findConstraint(layoutAttribute: .bottom)
//        topCst?.constant = 0
//        bottomCst?.constant = 0
//        self.contentView.subviews.first?.cornerRadius = 0
    }

    open func setCellModel(_ cellModel: Any?) {
        if let cellModel = cellModel as? T {
            self.bindCellModel(cellModel)
        }
    }
    
    open func setSectionController(_ sectionController: SectionControllerInterface?) {
        self.sectionController = sectionController
        if let delegate = sectionController{
            self.setCustomDelegate(delegate)
        }
    }
    
    @nonobjc open func setCompactMode(_ mode: Bool){
        if mode != self.compactMode {
            self.compactMode = mode
            
            if let containerView = self.viewWithTag(119){
                if let containerSuperView = containerView.superview{
                    var trailing: NSLayoutConstraint?
                    var leading: NSLayoutConstraint?
                    for cts in containerSuperView.constraints{
                        if cts.identifier == "ctnl"{
                            leading = cts
                        }
                        if cts.identifier == "ctnt"{
                            trailing = cts
                        }
                        
                    }
                    if self.compactMode {
//                        containerView.leftLineColor = UIColor.lightGray
//                        containerView.rightLineColor = UIColor.lightGray
                        leading?.constant = 16
                        trailing?.constant = 16
                    }else{
                        
//                        containerView.leftLineColor = UIColor.clear
//                        containerView.rightLineColor = UIColor.clear
                        leading?.constant = 0
                        trailing?.constant = 0
                    }
                }
                
            }
        }
    }
    
    
    open func willDisplay() {
        self.isDisplay = true
    }
    
    open func didEndDisplaying() {
        self.isDisplay = false
        
    }
    
    open func getCellModel() -> T?{
        return self.cellModel
    }
    
    open func setCustomDelegate(_ section: Any){
        
    }
    open func update(){
        if let cellModel = self.cellModel{
            self.setCellModel(cellModel)
        }
    }
    
    
    open func getCellIndex(){
        
    }
    
    
    open func getContainerView() -> UIView?{
        return nil
    }
    
    open func getContainerLeftCst() -> NSLayoutConstraint?{
        return nil
    }
    
    open func getContainerRightCst() -> NSLayoutConstraint?{
        return nil
    }
    
    open func didSelectedMe(){
        if let collection = self.getParentCollectionView(){
            if let index = collection.indexPath(for: self){
                collection.delegate?.collectionView?(collection, didSelectItemAt: index)
            }
        }
    }
    
    public func getCellIndexPath() -> IndexPath?{
        
        if let collection = self.getParentCollectionView(){
            
            if let index = collection.indexPath(for: self){
                return index
            }
        }
        
        return nil
    }
    public func getParentCollectionView() -> UICollectionView?{
        
        var superview = self.superview
        
        while true {
            if let collection = superview as? UICollectionView{
                return collection
            }
            superview = superview?.superview
            if superview == nil {
                break
            }
        }
        return nil
    }
}

public protocol CellBuilderInterface: class{
    
    func setSectionModel(_ sectionModel: Any?, sectionController: SectionControllerInterface?)
    func getCellModels() -> [CellModelInterface]
    func getCellHeader() -> CellModelInterface?
    func getCellFooter() -> CellModelInterface?
    func parseCellModels()
    func clearCellModels()
}

open class BaseCellBuilder: NSObject, CellBuilderInterface {
    public func getCellHeader() -> CellModelInterface? {
        return cellHeader
    }
    
    public func getCellFooter() -> CellModelInterface? {
        return cellFooter
    }
    
    public func getDecorationView() -> CellModelInterface? {
        return cellDecoration
    }
    public var cellModels:[CellModelInterface] = []
    public var cellHeader: CellModelInterface?
    public var cellFooter: CellModelInterface?
    public var cellDecoration: CellModelInterface?

    public var sectionModel: Any?
//    public var sectionController: Any?
    public weak  var sectionController: SectionControllerInterface?

    
    open func setSectionModel(_ sectionModel: Any?, sectionController: SectionControllerInterface?){
        self.sectionModel = sectionModel
        self.sectionController = sectionController
    }
    open func parseCellModels(){
        
    }
    
    open func clearCellModels(){
        self.cellModels.removeAll()
        self.cellHeader = nil
        self.cellFooter = nil
    }
    
    open func getCellModels() ->  [CellModelInterface]{
        for item in cellModels{
            item.setSectionController(self.sectionController)
        }
        return self.cellModels
    }
    
    open func appendCell(_ cell: CellModelInterface?){
        self.cellModels.safeAppend(cell)
    }
    open func appendCells(_ cells: [CellModelInterface]?){
        self.cellModels.safeAppend(sequence: cells)
    }
    open func setHeaderCell(_ cell: CellModelInterface?) {
        self.cellHeader = cell
    }
    open func setFooterCell(_ cell: CellModelInterface?) {
        self.cellFooter = cell
    }
    
}
