//
//  DefaultIconTextCell.swift
//  Piano_App
//
//  Created by Azibai on 24/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol DefaultIconTextCellDelegate: class {
    
}
enum DefaultIconTextKey {
    case ChangePass
    case LocalSongs
    case ChangeColor
    case InfoSupport
    case Rule
    case Login
    case Logout
    case ChangeInfoUser
    case InfoUser
    case SearchYoutube
    case ActiveKey
    case Practice
    case ManagerUser
    case TestVoice
    case NONE
}
class DefaultIconTextCellModel: AziBaseCellModel {
    
    var att: NSMutableAttributedString?
    var iconStr: String?
    var type: DefaultIconTextKey = .NONE
    
    init(att: NSMutableAttributedString? = nil, iconStr: String? = nil, type: DefaultIconTextKey = .NONE) {
        self.att = att
        self.iconStr = iconStr
        self.type = type
        super.init()
    }
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 52
    }
    
    override func getCellName() -> String {
        return DefaultIconTextCell.className
    }
}

class DefaultIconTextCell: CellModelView<DefaultIconTextCellModel> {
    
    weak var delegate: DefaultIconTextCellDelegate?
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var textLbl: UILabel!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? DefaultIconTextCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: DefaultIconTextCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        icon.image = UIImage(named: cellModel.iconStr ?? "")
        textLbl.attributedText = cellModel.att
    }
    
}



