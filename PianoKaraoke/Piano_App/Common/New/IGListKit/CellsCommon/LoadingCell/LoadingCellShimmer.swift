//
//  LoadingCell.swift
//  testIgList
//
//  Created by Azibai on 18/11/2019.
//  Copyright © 2019 Azibai. All rights reserved.
//

import Foundation
import Mapper
import Shimmer

open class LoadingCellShimmer: CellModelView<LoadingCellModel> {
    @IBOutlet weak var shimmeringView: FBShimmeringView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    @IBOutlet var view5: UIView!

    open override func awakeFromNib() {
        super.awakeFromNib()
        let contentView = self.containerView
        self.shimmeringView.contentView = containerView
        contentView?.frame = self.shimmeringView.bounds
        contentView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.shimmeringView.isShimmering = true
    }
    
    open override func bindCellModel(_ cellModel: LoadingCellModel) {
        containerView.backgroundColor = cellModel.containerBackgroundColor
    }
    
}

public class LoadingCellModel: AziBaseCellModel {
    open var containerBackgroundColor: UIColor = .clear
    public override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 124 + 60
    }
    public override func getCellName() -> String {
        return "LoadingCellShimmer"
    }
    
}
open class LoadingSectionModel: AziBaseSectionModel, SectionBackGroundCardLayoutInterface {
    open var numberLoading: Int = 1
    open var backgroundColor: UIColor = .clear
    public init(numberLoading: Int = 1, backgroundColor: UIColor = .clear) {
        self.numberLoading = numberLoading
        self.backgroundColor = backgroundColor
        super.init()
    }

    required public init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    open override func getSectionInit() -> SectionControllerInterface? {
        return LoadingSection()
    }
}
