//
//  TextFieldInputCell.swift
//  Piano_App
//
//  Created by Azibai on 14/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol TextFieldInputCellDelegate: class {
    func selectedBank(bankModel: BankModel?)
    func selectedMomo(momoModel: WalletModel?)
    func updateTextFieldInputFromKeyboard(string: String)
}

class TextFieldInputCellModel: AziBaseCellModel {
    
    var content: String = ""
    var placeholder: String = ""
    var type: PaymentTextFieldInputCellModel.TypeInPut = .Keyboard(.number)
    
    init(content: String = "", placeholder: String = "", type: PaymentTextFieldInputCellModel.TypeInPut = .Keyboard(.number)) {
        self.content = content
        self.placeholder = placeholder
        self.type = type
        super.init()
    }
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 34
    }
    
    override func getCellName() -> String {
        return TextFieldInputCell.className
    }
}

class TextFieldInputCell: CellModelView<TextFieldInputCellModel> {
    
    weak var delegate: TextFieldInputCellDelegate?
    @IBOutlet weak var inputTextField: UITextField! {
        didSet {
            inputTextField.delegate = self
        }
    }
    
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var btnTapDrop: UIButton!


    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? TextFieldInputCellDelegate
    }
    
    override func bindCellModel(_ cellModel: TextFieldInputCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        
        inputTextField.placeholder = cellModel.placeholder
        inputTextField.text = cellModel.content
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
    }
    
    @IBAction func clickDropDown(_ sender: Any?) {
        switch cellModel?.type {
        case .Keyboard: break
        case .DropDown(let type):
            switch type {
            case .Momo:
                PaymentService.shared.getAllAccountMomo {  [weak self] (momos) in
                    let dataSource: [String] = momos.map({ "\t" + $0.account_name })
                    PopupIGViewController.showAlert(viewController: self?.parentViewController, title: "Chọn tài khoản Momo", dataSource: dataSource, hightLight: "", attributes: nil) { (str, index) in
                        let _str = str.replacingOccurrences(of: "\t", with: "")
                        self?.delegate?.selectedMomo(momoModel: momos[safe: index])
                        self?.cellModel?.content = _str
                        self?.cellModel?.reloadCell(true)
                    }
                }
            case .Bank:
                PaymentService.shared.getBanks { [weak self] (banks) in
                    let dataSource: [String] = banks.map({ "\t" + $0.short_name + " - " + $0.name })
                    PopupIGViewController.showAlert(viewController: self?.parentViewController, title: "Chọn ngân hàng", dataSource: dataSource, hightLight: "", attributes: nil) { (str, index) in
                        let _str = str.replacingOccurrences(of: "\t", with: "")
                        self?.delegate?.selectedBank(bankModel: banks[safe: index])
                        self?.cellModel?.content = _str
                        self?.cellModel?.reloadCell(true)
                    }
                }
            case .City, .Date: break
            }
        default:
            break
        }
    }

    
}



extension TextFieldInputCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentString: NSString = textField.text as NSString? else { return false }
        let newString = currentString.replacingCharacters(in: range, with: string)
        cellModel?.content = newString
        cellModel?.updateCell()
        delegate?.updateTextFieldInputFromKeyboard(string: newString)
        print(newString)
        return false
    }

}

