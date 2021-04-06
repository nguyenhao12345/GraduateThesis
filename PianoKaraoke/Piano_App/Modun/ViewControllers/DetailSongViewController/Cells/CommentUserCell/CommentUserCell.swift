//
//  CommentUserCell.swift
//  Piano_App
//
//  Created by Azibai on 15/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import DTCoreText

protocol CommentUserCellDelegate: class {
    func commentUserCelldeleteComment(commentModel: CommentModel)
}

class CommentUserCellModel: AziBaseCellModel {
    var widthMaxText: CGFloat = 0
    var maxWText: CGFloat = 0
    var attributed: NSMutableAttributedString?
    var truncationString: NSAttributedString = Helper.getAttributesStringWithFontAndColor(string: "...Xem thêm", font: .HelveticaNeueItalic16, color: .lightGray)
    var numberOfLine = 3
    var commentModel: CommentModel?
    var backGroundColorContentComment: String = "F5F5F5"
    var tintColorDate: String = UIColor.defaultText.hexString
    var constRight: CGFloat = 12
    init(commentModel: CommentModel, backGroundColorContentComment: String = "F5F5F5", tintColorDate: String = UIColor.defaultText.hexString) {
        super.init()
        self.backGroundColorContentComment = backGroundColorContentComment
        self.tintColorDate = tintColorDate
        self.commentModel = commentModel
        self.attributed = Helper.getAttributesStringWithFontAndColor(string: commentModel.comment, font: .HelveticaNeue16, color: .defaultText)
    }
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        let w = getCellWidth(maxWidth: maxWidth)
        maxWText = w - 70 - 16
        let sizeUserName = sizeForView(textAtt: Helper.getAttributesStringWithFontAndColor(string: commentModel?.nameUserComment ?? "", font: .HelveticaNeueBold16, color: .clear), width: maxWText, numberOfline: 1)

        let sizeText = sizeForView(textAtt: attributed!, width: maxWText, numberOfline: numberOfLine)
        let heightImage: CGFloat = 38
        let heightRight: CGFloat = 8 + 20 + 4 + 8 + sizeText.height
        
        widthMaxText = max(sizeUserName.width, sizeText.width)
        constRight = (maxWText) - widthMaxText + 12
        return max(heightImage, heightRight) + 12 + 32
    }

    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth - 30
    }
    
    override func getCellName() -> String {
        return CommentUserCell.className
    }
}

class CommentUserCell: CellModelView<CommentUserCellModel> {
    
    weak var delegate: CommentUserCellDelegate?
    @IBOutlet weak var commentLabel: DTAttributedLabel!
    @IBOutlet weak var avtImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var trailingConst: NSLayoutConstraint!

    @IBOutlet weak var containerViewComment: UIView!
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? CommentUserCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initGesture()
//        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) i 


    }
    
    override func bindCellModel(_ cellModel: CommentUserCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        commentLabel.attributedString = cellModel.attributed
        commentLabel.truncationString = cellModel.truncationString
        commentLabel.numberOfLines = cellModel.numberOfLine
        avtImg.setImageURL(URL(string: cellModel.commentModel?.urlAvata ?? ""))
        userNameLbl.text = cellModel.commentModel?.nameUserComment
        timeLbl.text = cellModel.commentModel?.timeAgoSinceNow
        timeLbl.textColor = UIColor.init(hexString: cellModel.tintColorDate)
        containerViewComment.backgroundColor = UIColor.init(hexString: cellModel.backGroundColorContentComment)
//        containerViewComment.cornerRadius = 6
        trailingConst.constant = cellModel.constRight
        self.layoutIfNeeded()
        containerViewComment.roundCorners([.topRight, .bottomLeft, .bottomRight], radius: 6)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
//        trailingConst.constant = 12
    }
    
    func initGesture() {
        
        let tapAvt = UITapGestureRecognizer(target: self, action: #selector(self.clickAvata))
        avtImg.isUserInteractionEnabled = true
        avtImg.addGestureRecognizer(tapAvt)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clickLabel))
        commentLabel.addGestureRecognizer(tap)
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(self.longClickView))
        longTap.minimumPressDuration = 0.5
        containerViewComment.addGestureRecognizer(longTap)
    }
    
    @objc func longClickView(_ sender: UILongPressGestureRecognizer) {
        if cellModel?.commentModel?.baseComment?.user?.uid != AppAccount.shared.getUserLogin()?.uid {
            return
        }
        if sender.state == .began {
            containerViewComment.backgroundColor = UIColor.gray
            UIView.animate(withDuration: 0.5) {
                self.containerViewComment.backgroundColor = UIColor.init(hexString: self.cellModel!.backGroundColorContentComment)
            }
            self.parentViewController?.showDialogBottom(title: nil, message: nil, buttonTitles: ["Xoá", "Sao chép"], highlightedButtonIndex: nil, completion: { (value) in
                if value == 0 {
                    self.delegate?.commentUserCelldeleteComment(commentModel: (self.cellModel?.commentModel!)!)
                } else if value == 1 {
                    UIPasteboard.general.string = self.cellModel?.attributed?.string
                    self.parentViewController?.showToast(string: "Đã sao chép", duration: 2.0, position: .top)
                }
            })
        }
    }
    
    @objc func clickLabel(_ sender: Any) {
        if commentLabel.numberOfLines == 0 {
            cellModel?.numberOfLine = 3
        }
        else {
            cellModel?.numberOfLine = 0
        }
        cellModel?.reloadCell(true)
    }
    
    @objc func clickAvata(_ sender: Any) {
        guard let vc = parentViewController,
            let uidUser = cellModel?.commentModel?.baseComment?.user?.uid
        else { return }
        AppRouter.shared.gotoUserWall(uidUSer: uidUser, viewController: vc)
      }
}


