//
//  HotKeyWordSearchSectionController.swift
//  Piano_App
//
//  Created by Azibai on 13/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol HotKeyWordSearchSectionDelegate: class {
    func didSelectAtKeyWork(str: String)
}

class HotKeyWordSearchSectionModel: AziBaseSectionModel {
    
    var keys: [String] = []
    var title: String = ""
    var isHiddenSection: Bool = true
    init(keys: [String] = ["Chắc ai đó sẽ về", "Chờ người nơi ấy", "Em gái mưa", "Thần thoại", "Kiếp đỏ đen", "Tình đơn phương"],
         title: String = "Từ khoá hot",
         isHiddenSection: Bool = true) {
        self.keys = keys
        self.title = title
        self.isHiddenSection = isHiddenSection
        super.init()
    }

    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return HotKeyWordSearchSectionController()
    }
}

class HotKeyWordSearchSectionController: SectionController<HotKeyWordSearchSectionModel> {
    
    weak var delegate: HotKeyWordSearchSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? HotKeyWordSearchSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return HotKeyWordSearchCellBuilder()
    }
    
    override func didSelectItem(at index: Int) {
        guard let cell = cellModelAtIndex(index) as? HotKeyWordCellModel else { return }
        delegate?.didSelectAtKeyWork(str: cell.text)
        
    }
}

class HotKeyWordSearchCellBuilder: CellBuilder {
    
    var widthScreenInLine: CGFloat = UIScreen.main.bounds.size.width

    func sizeFor(_ str: String, witdh: CGFloat, isSelect: Bool) -> CGSize {
        let extraIcon: CGFloat = (isSelect) ? 15 : 0
        let dumpLabel = UILabel(frame: .zero)
        dumpLabel.numberOfLines = 0
        dumpLabel.text = str
        dumpLabel.textAlignment = .left
        dumpLabel.font = UIFont.HelveticaNeueMedium14
        let size = dumpLabel.sizetWithMaxWidth(witdh - extraIcon - 16 - 8, lineLimit: 0)
        return CGSize(width: size.width + extraIcon + 16 + 8 , height: size.height + 10)
    }
    
    func addNewCell(str: String, hexColorBackground: String) {
        let sizeCell = sizeFor(str, witdh: UIScreen.main.bounds.size.width, isSelect: false)
        let cell = HotKeyWordCellModel(height: sizeCell.height + 8, width: sizeCell.width, text: str, hexColorBackground: hexColorBackground)
        appendCell(cell)
        widthScreenInLine -= sizeCell.width
    }
    func editWitdhAndAlignmentCellToLeft() {
        addBlankSpace(1, width: widthScreenInLine, color: .clear)
        widthScreenInLine -= widthScreenInLine
    }
    func formatWidthAndReturnNewLine() {
        widthScreenInLine = UIScreen.main.bounds.size.width
        addBlankSpace(8, width: UIScreen.main.bounds.size.width, color: .clear)
    }
    override func parseCellModels() {
        widthScreenInLine = UIScreen.main.bounds.size.width
        guard let sectionModel = sectionModel as? HotKeyWordSearchSectionModel else { return }
        if sectionModel.isHiddenSection {
            addBlankSpace(1, width: nil, color: .clear)
            return
        }
        addBlankSpace(24, width: nil, color: .clear)
        addSimpleText(Helper.getAttributesStringWithFontAndColor(
            string: "   \(sectionModel.title)", font: .HelveticaNeueBold16, color: .defaultText), height: 28)
        buildFlexCells(arr: sectionModel.keys)
        addBlankSpace(12, width: nil, color: .clear)
        addBlankSpace(800, width: nil, color: UIColor(hexString: "E5E5E5") ?? .black)
    }
    func buildFlexCells(arr: [String]) {
        for (index, value) in arr.enumerated() {
            addNewCell(str: value, hexColorBackground: "EBEBEB")
            if index + 1 < arr.count {
                let sizeCellNext = sizeFor(arr[index+1],
                                           witdh: UIScreen.main.bounds.size.width,
                                           isSelect: false)
                if widthScreenInLine < sizeCellNext.width {
                    editWitdhAndAlignmentCellToLeft()
                }
            }
            if index == arr.count - 1 { //last
                editWitdhAndAlignmentCellToLeft()
            }
            if widthScreenInLine <= 0 {
                formatWidthAndReturnNewLine()
            }
        }

    }
}

extension UILabel {
    public func sizeWithMaxWidth(_ width: CGFloat) -> CGSize {
        return self.sizetWithMaxWidth(width, lineLimit: self.numberOfLines)
    }
    
    public func sizetWithMaxWidth(_ width:CGFloat, lineLimit: NSInteger) -> CGSize {
        let frame = self.textRect(forBounds: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude), limitedToNumberOfLines: lineLimit)
        return frame.size
    }
    
    public func sizeWithMaxHeight(_ height:CGFloat) -> CGSize {
        return self.sizeWithMaxHeight(height, lineLimit: self.numberOfLines)
    }

    
    public func sizeWithMaxHeight(_ height:CGFloat, lineLimit: NSInteger) -> CGSize {
        let frame = self.textRect(forBounds: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height), limitedToNumberOfLines: lineLimit)
        return frame.size
    }

}
