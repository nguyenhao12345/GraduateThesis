//
//  PaymentBlockFilterCell.swift
//  Piano_App
//
//  Created by Azibai on 04/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol PaymentBlockFilterCellDelegate: class {
    func showModeDateFilter()
    func hiddenModeDateFilter()
    func updateFilter(filter: PaymentFilterField)
}

class PaymentBlockFilterCellModel: AziBaseCellModel {
    var filter: PaymentFilterField
    var title: String = ""
    
    init(filter: PaymentFilterField, title: String = "") {
        self.filter = filter
        self.title = title
        super.init()
    }
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 115.5
    }
    
    override func getCellName() -> String {
        return PaymentBlockFilterCell.className
    }
}

class PaymentBlockFilterCell: CellModelView<PaymentBlockFilterCellModel> {
    
    weak var delegate: PaymentBlockFilterCellDelegate?
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var viewBlock: UIView!
    var viewSelected = UIView(frame: CGRect.zero)
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? PaymentBlockFilterCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewSelected.borderColor = #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1)
        viewSelected.borderWidth = 1
        viewSelected.cornerRadius = 11
        viewBlock.addSubview(viewSelected)

    }
    
    override func bindCellModel(_ cellModel: PaymentBlockFilterCellModel) {
        super.bindCellModel(cellModel)
        viewSelected.frame = CGRect(x: 0, y: label1.superview?.origin.y ?? 0, width: label1.superview?.width ?? 0, height: label1.superview?.height ?? 0)

        titleLbl.text = cellModel.title
        setUpUI(cellModel: cellModel)
    }
    
    func setUpUI(cellModel: PaymentBlockFilterCellModel) {
        label1.text = cellModel.filter.getDatas()[safe: 0]?.name
        label2.text = cellModel.filter.getDatas()[safe: 1]?.name
        label3.text = cellModel.filter.getDatas()[safe: 2]?.name
        
        var xViewSelected: CGFloat?

        if let filter1 = cellModel.filter.getDatas()[safe: 0] {
            label1.textColor = filter1.name == cellModel.filter.name ? #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1): #colorLiteral(red: 0.5411764706, green: 0.6078431373, blue: 0.6549019608, alpha: 1)
            xViewSelected = filter1.name == cellModel.filter.name ? label1.superview?.origin.x: xViewSelected
        }
        if let filter2 = cellModel.filter.getDatas()[safe: 1] {
            label2.textColor = filter2.name == cellModel.filter.name ? #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1): #colorLiteral(red: 0.5411764706, green: 0.6078431373, blue: 0.6549019608, alpha: 1)
            xViewSelected = filter2.name == cellModel.filter.name ? label2.superview?.origin.x: xViewSelected
        }
        if let filter3 = cellModel.filter.getDatas()[safe: 2] {
            label3.textColor = filter3.name == cellModel.filter.name ? #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1): #colorLiteral(red: 0.5411764706, green: 0.6078431373, blue: 0.6549019608, alpha: 1)
            xViewSelected = filter3.name == cellModel.filter.name ? label3.superview?.origin.x: xViewSelected
        }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.viewSelected.x = xViewSelected ?? 0
        }, completion: nil)
    }
    
    @IBAction func clickView1(_ sender: Any?) {
        guard let cellModel = cellModel else { return }
        cellModel.filter = cellModel.filter.getDatas()[safe: 0] ?? cellModel.filter
        delegate?.updateFilter(filter: cellModel.filter)
        setUpUI(cellModel: cellModel)
        if cellModel.filter.getDatas()[safe: 2]?.name == "Khoảng thời gian" {
            delegate?.hiddenModeDateFilter()
        }
    }
    
    @IBAction func clickView2(_ sender: Any?) {
        guard let cellModel = cellModel else { return }
        cellModel.filter = cellModel.filter.getDatas()[safe: 1] ?? cellModel.filter
        delegate?.updateFilter(filter: cellModel.filter)
        setUpUI(cellModel: cellModel)
        if cellModel.filter.getDatas()[safe: 2]?.name == "Khoảng thời gian" {
            delegate?.hiddenModeDateFilter()
        }
    }
    
    @IBAction func clickView3(_ sender: Any?) {
        guard let cellModel = cellModel else { return }
        cellModel.filter = cellModel.filter.getDatas()[safe: 2] ?? cellModel.filter
        delegate?.updateFilter(filter: cellModel.filter)
        setUpUI(cellModel: cellModel)
        if cellModel.filter.getDatas()[safe: 2]?.name == "Khoảng thời gian" {
            delegate?.showModeDateFilter()
        }
    }
    
}



