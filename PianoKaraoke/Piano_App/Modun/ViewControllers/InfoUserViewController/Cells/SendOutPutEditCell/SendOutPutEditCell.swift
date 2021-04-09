//
//  SendOutPutEditCell.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol SendOutPutEditCellDelegate: class {
    func done()
    func cancel()
}

class SendOutPutEditCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 48
    }
    
    override func getCellName() -> String {
        return SendOutPutEditCell.className
    }
}

class SendOutPutEditCell: CellModelView<SendOutPutEditCellModel> {
    
    weak var delegate: SendOutPutEditCellDelegate?
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? SendOutPutEditCellDelegate
    }
    @IBAction func clickDone(_ sender: Any?) {
        delegate?.done()
    }
    @IBAction func clickCancel(_ sender: Any?) {
        delegate?.cancel()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.btnDone.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                self?.btnCancel.setTitleColor(UIColor.hexStringToUIColor(hex: hex, alpha: 1)
                    , for: .normal)

            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }
    
    override func bindCellModel(_ cellModel: SendOutPutEditCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
}



