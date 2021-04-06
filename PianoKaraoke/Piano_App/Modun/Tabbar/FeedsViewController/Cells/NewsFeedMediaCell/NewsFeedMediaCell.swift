//
//  NewsFeedMediaCell.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import DTCoreText

protocol NewsFeedMediaCellDelegate: class {
    
}

class NewsFeedMediaCellModel: AziBaseCellModel {
    let heightImg: CGFloat = 120
    
    var titleStr: String = ""
    let margin: CGFloat = 156
    var attributed: NSMutableAttributedString?
    var truncationString: NSAttributedString?
    var numberOfLine: Int = 3
    var urlImg: String = ""
    init(attributed: NSMutableAttributedString, truncationString: NSAttributedString? = nil, numberOfLine: Int = 0, titleStr: String, urlImg: String = "") {
        self.attributed = attributed
        self.truncationString = truncationString
        self.numberOfLine = numberOfLine
        self.titleStr = titleStr
        self.urlImg = urlImg
        super.init()
    }

    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        let heightTitle = heightForView(textAtt: Helper.getAttributesStringWithFontAndColor(string: titleStr, font: .HelveticaNeueBold16, color: .clear), width: maxWidth - margin, numberOfline: 2)
        let heightContent = heightForView(textAtt: attributed!, width: maxWidth - margin, numberOfline: numberOfLine)
        return max(heightImg, heightTitle + heightContent + 4) + 24
    }
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth 
    }
    override func getCellName() -> String {
        return NewsFeedMediaCell.className
    }
}

class NewsFeedMediaCell: CellModelView<NewsFeedMediaCellModel> {
    
    weak var delegate: NewsFeedMediaCellDelegate?
    @IBOutlet weak var coreText: DTAttributedLabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mediaImg: HImageView!
    @IBOutlet weak var backGroundImg: UIImageView!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? NewsFeedMediaCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initGesture()
//        img.conf
        mediaImg.config(HImageViewConfigure(backgroundColor: .clear,
                                               durationDismissZoom: 0.2,
                                               maxZoom: 4,
                                               minZoom: 0.8,
                                               vibrateWhenStop: false,
                                               autoStopWhenZoomMin: false,
                                               isUpdateAlphaWhenHandle: true,
                                               backgroundColorWhenZoom: .clear))
    }
    
    override func bindCellModel(_ cellModel: NewsFeedMediaCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        self.coreText.attributedString = cellModel.attributed
        self.coreText.numberOfLines = cellModel.numberOfLine
        self.coreText.truncationString = cellModel.truncationString
        self.titleLbl.text = cellModel.titleStr
        self.mediaImg.setImageURL(URL(string: cellModel.urlImg))
        self.backGroundImg.setImageURL(URL(string: cellModel.urlImg))
    }
    
    func initGesture() {
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.clickLabel))
           coreText.addGestureRecognizer(tap)
       }
       
       @objc func clickLabel(_ sender: Any) {
           if cellModel?.truncationString == nil {
               return
           }
           if coreText.numberOfLines == 0 {
               cellModel?.numberOfLine = 3
           }
           else {
               cellModel?.numberOfLine = 0
           }
           cellModel?.reloadCell(true)
       }
    
}



