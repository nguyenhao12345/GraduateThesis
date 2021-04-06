//
//  SearchingSectionController.swift
//  Piano_App
//
//  Created by Azibai on 13/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Mapper

protocol SearchingSectionDelegate: class {
    
}

class SearchingSectionModel: AziBaseSectionModel {
    var dataSearch: [ModelSearch]?
    var dataSearched: [ModelSearch] = []

    var textSearch: String = "" {
        didSet {
            if textSearch == "" {
                dataSearched = []
            }
            else {
                dataSearched = dataSearch?.filter({$0.name.lowercased().prefix(textSearch.lowercased().count) == textSearch.lowercased() }) ?? [ModelSearch]()
            }
            self.sectionController?.reloadSection(animated: false, completion: nil)
        }
    }
    
    override init() {
        super.init()
        ServiceOnline.share.getDataSearch(param: "Search") { [weak self] (data) in
            guard let self = self
                ,let data = data as? [String: [String: String]]
                else { return }
            self.dataSearch = data.map{ ModelSearch(data: $0.value) }
        }
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return SearchingSectionController()
    }
}

class SearchingSectionController: SectionController<SearchingSectionModel> {
    
    weak var delegate: SearchingSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? SearchingSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return SearchingCellBuilder()
    }

    override func didSelectItem(at index: Int) {
        guard let cell = cellModelAtIndex(index) as? SearchKeyWordCellModel,
            let viewController = viewController else { return }        
        AppRouter.shared.gotoDetailMusic(id: cell.key, viewController: viewController)
    }
}

class SearchingCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? SearchingSectionModel else { return }
        
        for i in sectionModel.dataSearched {
            addBlankSpace(12, width: nil, color: .clear)
            let cell = SearchKeyWordCellModel()
            cell.key = i.key
            cell.attributed = Helper.getAttributesStringWithFontAndColor(string: "          \(i.name)", font: .HelveticaNeue16, color: .black)
            cell.attributed?.setAttributedStringReplaceWith(regex: sectionModel.textSearch, hexColor: AppColor.shared.colorBackGround.value, font: UIFont.HelveticaNeueMedium16)
            appendCell(cell)
        }
    }
}

extension NSMutableAttributedString {
    
    func setAttributedStringReplaceWith(regex parttern: String, hexColor: String = "FFFFFF", font: UIFont?) {
        if let regex = try? NSRegularExpression(pattern: parttern, options: .caseInsensitive)
        {
            let string = self.string as NSString
            let attributes: [NSAttributedString.Key:Any] =  [.foregroundColor: UIColor(hexString: hexColor) ?? UIColor.black,
                                                             .font: font ?? UIFont.systemFont(ofSize: 18)]
            let _ = regex.matches(in: string as String, options: [], range: NSRange(self.string.startIndex..., in: self.string)).map {
                self.addAttributes(attributes, range: $0.range)
            }
        }
    }
}
