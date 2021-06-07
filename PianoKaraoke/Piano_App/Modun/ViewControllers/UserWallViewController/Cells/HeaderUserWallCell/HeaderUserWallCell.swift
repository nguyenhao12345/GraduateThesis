//
//  HeaderUserWallCell.swift
//  Piano_App
//
//  Created by Azibai on 31/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol HeaderUserWallCellDelegate: class {
    
}

class HeaderUserWallCellModel: AziBaseCellModel {
    var user: UserModel?
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        let heightImg: CGFloat = 120
        let heightViewMore: CGFloat = 38
        let marginTop: CGFloat = 80
        
        let heightName = heightForView(textAtt: Helper.getAttributesStringWithFontAndColor(string: user?.name ?? "", font: .HelveticaNeueBold20, color: .clear), width: maxWidth - 40, numberOfline: 0)
        let introText = """
        "\(user?.infoIntro ?? "")"
        """
        let heightIntro = heightForView(textAtt: Helper.getAttributesStringWithFontAndColor(string: introText, font: .HelveticaNeueLight12, color: .clear), width: maxWidth - 40, numberOfline: 0)
        
        return heightViewMore + 12 + heightIntro + 4 + heightName + 12 + heightImg/2 + marginTop
    }
    
    override func getCellName() -> String {
        return HeaderUserWallCell.className
    }
}

class HeaderUserWallCell: CellModelView<HeaderUserWallCellModel> {
    
    weak var delegate: HeaderUserWallCellDelegate?
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewMoreLbl: UILabel!
    @IBOutlet weak var introLbl: UILabel!
    @IBOutlet weak var avtImg: HImageView!
    @IBOutlet weak var adminButton: UIButton!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? HeaderUserWallCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avtImg.config(HImageViewConfigure(backgroundColor: .clear,
                                          durationDismissZoom: 0.2,
                                          maxZoom: 4,
                                          minZoom: 0.8,
                                          vibrateWhenStop: false,
                                          autoStopWhenZoomMin: false,
                                          isUpdateAlphaWhenHandle: true,
                                          backgroundColorWhenZoom: .clear))
        
    }
    
    @IBAction func clickViewMoreUser(_ sender: Any?) {
        guard let viewController = parentViewController,
            let uidUser = cellModel?.user?.uid else { return }
        AppRouter.shared.gotoInfoUser(uidUser: uidUser, viewController: viewController)
    }
    
    override func bindCellModel(_ cellModel: HeaderUserWallCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        // border
        adminButton.isHidden = cellModel.user?.admin != 1
        avtImg.setImageURL(URL(string: cellModel.user?.avata ?? ""))
        nameLbl.text = cellModel.user?.name
        let introText = """
        "\(cellModel.user?.infoIntro ?? "")"
        """
        if let name = cellModel.user?.name {
            let name2 = """
            "\(name)"
            """
            viewMoreLbl.text = "Xem thêm về \(name2)."
        }
        introLbl.text = introText
        
        self.viewContent.dropShadow(color: .black, opacity: 0.1, offSet: CGSize(width: 1, height: 1), radius: 6, scale: true)
    }
    
    @IBAction func clickAvata(_ sender: Any?) {
        guard let user = cellModel?.user else { return }
        let media = MediaModel()
        media.urlImage = user.avata
        DetailMediaViewController.gotoMe(with: parentViewController, media: media)
    }
}



