//
//  HeaderMixMusicCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol HeaderMixMusicCellDelegate: class {
    func segmentedMenu(_ text: String, index: Int)
}

class HeaderMixMusicCellModel: AziBaseCellModel {
    
    var indexSegment: Int = 0
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 44
    }
    
    override func getCellName() -> String {
        return HeaderMixMusicCell.className
    }
}

class HeaderMixMusicCell: CellModelView<HeaderMixMusicCellModel> {
    let titles = ["Nhạc Việt", "Nhạc Hoa", "Nhạc Hàn", "Bolerooooooo", "Bolero2", "Bolero3", "Bolero4", "Bolero5", "Bolero6"]

    weak var delegate: HeaderMixMusicCellDelegate?
    var segmeted = SegmentedMenuFactory.create()
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? HeaderMixMusicCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
        
        initSegmented()
    }
    
    func initSegmented() {
        self.segmeted.getModuleData().setDataSources(titles)
        self.segmeted.getModuleData().setFullItemWidth(false)
        self.segmeted.setDelegate(self)
        self.contentView.addSubViewAndBoundMaskPin(self.segmeted.getView())
    }

    override func bindCellModel(_ cellModel: HeaderMixMusicCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        segmeted.scrollIndex(cellModel.indexSegment)
    }
    
}



extension HeaderMixMusicCell: SegmentedMenuDelegate {
    func segmentedMenu(_ segmenteg: SegmentedMenuModule, index: Int) {
        cellModel?.indexSegment = index
        delegate?.segmentedMenu(titles[index], index: index)
    }
    
    
}
