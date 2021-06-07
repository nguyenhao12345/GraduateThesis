//
//  PaymentTextFieldInputCell.swift
//  Piano_App
//
//  Created by Azibai on 14/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol PaymentTextFieldInputCellDelegate: class {
    func contentUpdate(string: String, id: Int?)
}

class PaymentTextFieldInputCellModel: AziBaseCellModel {
    enum TypeInPut {
        enum DropDownType {
            case Bank
            case City
            case Date
            case Momo
        }
        case DropDown(DropDownType)
        case Keyboard(KeyBoardType)
        
        enum KeyBoardType {
            case number
            case character
        }
    }
    var title: String = ""
    var content: String = ""
    var placeholder: String = ""
    var type: TypeInPut = .Keyboard(.number)
    init(title: String = "", content: String = "", placeholder: String = "", type: TypeInPut = .Keyboard(.number)) {
        self.title = title
        self.content = content
        self.placeholder = placeholder
        self.type = type
        super.init()
    }
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 21 + 18.5  + 13  + 34 + 21
    }
    
    override func getCellName() -> String {
        return PaymentTextFieldInputCell.className
    }
}

class PaymentTextFieldInputCell: CellModelView<PaymentTextFieldInputCellModel> {
    
    weak var delegate: PaymentTextFieldInputCellDelegate?
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            inputTextField.delegate = self
        }
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var btnTapDrop: UIButton!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? PaymentTextFieldInputCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: PaymentTextFieldInputCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        switch cellModel.type {
        case .DropDown(_):
            btnTapDrop.isHidden = false
            dropDownBtn.isHidden = false
        case .Keyboard(let type):
            switch type {
            case .character: inputTextField.keyboardType = .default
            case .number: inputTextField.keyboardType = .decimalPad
            }
            btnTapDrop.isHidden = true
            dropDownBtn.isHidden = true
        }
        inputTextField.placeholder = cellModel.placeholder
        inputTextField.text = cellModel.content
        titleLbl.text = cellModel.title
        print(cellModel.content)
    }
    
    @IBAction func clickDropDown(_ sender: Any?) {
        print("aaaa")
        switch cellModel?.type {
        case .Keyboard: break
        case .DropDown(let type):
            switch type {
            case .Bank:
                PaymentService.shared.getBanks { [weak self] (banks) in
                    let dataSource: [String] = banks.map({ "\t" + $0.short_name + " - " + $0.name })
                    PopupIGViewController.showAlert(viewController: self?.parentViewController, title: "Chọn ngân hàng", dataSource: dataSource, hightLight: "", attributes: nil) { (str, index) in
                        let _str = str.replacingOccurrences(of: "\t", with: "")
                        self?.delegate?.contentUpdate(string: str,
                                                      id: banks.filter({ ($0.short_name + " - " + $0.name) ==  _str}).first?.id)
                        self?.cellModel?.content = _str
                        self?.cellModel?.reloadCell(true)
                    }
                }
            case .City:
                self.delegate?.contentUpdate(string: "Tp Hồ Chí Minh", id: 65)
                self.cellModel?.content = "Tp Hồ Chí Minh"
                self.cellModel?.reloadCell(true)
            case .Date, .Momo: break
            }
        default:
            break
        }
    }
}



extension PaymentTextFieldInputCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentString: NSString = textField.text as NSString? else { return false }
        let newString = currentString.replacingCharacters(in: range, with: string)
        cellModel?.content = newString
        cellModel?.updateCell()
        delegate?.contentUpdate(string: newString, id: nil)
        return false
    }

}
