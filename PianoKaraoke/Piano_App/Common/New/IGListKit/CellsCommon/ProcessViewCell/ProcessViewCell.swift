//
//  ProcessViewCell.swift
//  NewsFeed
//
//  Created by Azibai on 06/01/2020.
//  Copyright © 2020 AzibaiNewFeed. All rights reserved.
//

import UIKit
import Mapper

protocol ProcessViewCellDelegate: class {
    func clickRemoveFakeNews()
    func success()
    func fail()
}

class ProcessViewCellModel: AziBaseCellModel {
    var height: CGFloat = 2
    var width = UIScreen.main.bounds.width
    var isHiddenRemoveButton: Bool = true
    var textMes: String = "Đang đăng tin..."
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return height
    }
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return width
    }
    
    override func getCellName() -> String {
        return "ProcessViewCell"
    }
}

class ProcessViewCell: CellModelView<ProcessViewCellModel> {
//    @IBOutlet weak var loadImage: UIImageView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mesStatus: UILabel!
    @IBOutlet weak var buttonRemove: UIButton!

    weak var delegate: ProcessViewCellDelegate?
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? ProcessViewCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(fail), name: Notification.Name(rawValue: "failAPIPostNews"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(success), name: Notification.Name(rawValue: "successAPIPostNews"), object: nil)
    }
    
    override func bindCellModel(_ cellModel: ProcessViewCellModel) {
        super.bindCellModel(cellModel)
        loadIndicator.startAnimating()
        buttonRemove.isHidden = cellModel.isHiddenRemoveButton
        mesStatus.text = cellModel.textMes
    }
    
    @objc func fail() {
        cellModel?.textMes = "Đăng tin thất bại"
        cellModel?.isHiddenRemoveButton = false
        delegate?.fail()
    }
    @objc func success() {
        cellModel?.textMes = "Tin của bạn đang được xử lý..."
        cellModel?.isHiddenRemoveButton = true
        delegate?.success()
    }

    @IBAction func clickRemove(_ sender: Any?) {
        delegate?.clickRemoveFakeNews()
    }
    
}



public class ProcessSectionModel: AziBaseSectionModel {
    var height: CGFloat
    var witdh: CGFloat
    init(height: CGFloat = 2, witdh: CGFloat = UIScreen.main.bounds.width) {
        self.witdh = witdh
        self.height = height
        super.init()
        self.uid = Ultilities.randomStringKey()
    }
    
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    public override func getSectionInit() -> SectionControllerInterface? {
        return ProcessSection()
    }
}

public class ProcessCellBuilder: CellBuilder{
    public override func parseCellModels() {
        guard let sectionModel = self.sectionModel as? ProcessSectionModel else { return }
        self.addProcessViewCell(heightCellView: sectionModel.height, width: sectionModel.witdh)
    }
}

public class ProcessSection: SectionController<AziBaseModel> {
    
    public override func getCellBuilder() -> CellBuilderInterface? {
        return ProcessCellBuilder()
    }
}
