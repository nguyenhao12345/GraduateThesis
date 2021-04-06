//
//  MeCommentCell.swift
//  Piano_App
//
//  Created by Azibai on 23/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol MeCommentCellDelegate: class {
    func sendMess(string: String)
}

class MeCommentCellModel: AziBaseCellModel {
    var margin: CGFloat = 20
    let defaultHeightComment: CGFloat = 34
    
    var heightTextView: CGFloat = 34
    
    let maxHeight: CGFloat = 200
    var nameText: String = Const.plahoderComment
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return min(maxHeight, heightTextView) + margin
    }
    
    override func getCellName() -> String {
        return MeCommentCell.className
    }
}

class MeCommentCell: CellModelView<MeCommentCellModel> {
    
    weak var delegate: MeCommentCellDelegate?
    @IBOutlet weak var marginRightViewBackgroundTextView: NSLayoutConstraint!
    @IBOutlet private weak var btnSendMess: UIButton!
    @IBOutlet private weak var viewBackgroundTextView: UIView!
    @IBOutlet private weak var uitextView: UITextView!
    @IBOutlet private weak var avtImg: ImageViewRound!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? MeCommentCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpObserver()
        uitextView.delegate = self
        uitextView.font = UIFont.HelveticaNeue16
        uitextView.textColor = UIColor.defaultText
    }
    
    override func bindCellModel(_ cellModel: MeCommentCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        
        if cellModel.nameText == "" {
            cellModel.nameText = Const.plahoderComment
        }
        
        uitextView.text = cellModel.nameText
        
        if cellModel.nameText == Const.plahoderComment {
            autoAnimationHideButton()
        } else {
            autoAnimationNotHideButton()
        }
        avtImg.setImageURL(URL(string: AppAccount.shared.getUserLogin()?.avata ?? ""))
    }
    
    @IBAction func clickSendRequest(_ sender: Any?) {
        guard let text = cellModel?.nameText else { return }
        if text == "" || text == Const.plahoderComment {
            return
        }
        delegate?.sendMess(string: text)
    }
    
    private func setUpObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc fileprivate func keyboardWillShow(notification:NSNotification) {
//        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
//            if uitextView.text == Const.plahoderComment {
//                uitextView.text = ""
//               autoAnimationNotHideButton()
//            }
//            UIView.animate(withDuration: 0.5) {
//                self.layoutIfNeeded()
//            }
//        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
//        if uitextView.text == "" {
//            uitextView.text = Const.plahoderComment
//            autoAnimationHideButton()
//        }
//        UIView.animate(withDuration: 0.5) {
//            self.layoutIfNeeded()
//        }
    }
    
    private func autoAnimationHideButton() {
        btnSendMess.isHidden = true
        marginRightViewBackgroundTextView.priority = UILayoutPriority(rawValue: 999.5)
    }
    
    private func autoAnimationNotHideButton() {
        btnSendMess.isHidden = false
        marginRightViewBackgroundTextView.priority = UILayoutPriority(rawValue: 998)
    }
    
    private func autoSizeFor(textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if textView.text == "" || textView.text == Const.plahoderComment {
                cellModel?.heightTextView = 38
                constraint.constant = 38
                cellModel?.invalidateCell()
                return
            }
            
            if constraint.firstAttribute == .height {
                cellModel?.heightTextView = max(min(estimatedSize.height, cellModel?.maxHeight ?? 0), 38)
                constraint.constant = max(min(estimatedSize.height, cellModel?.maxHeight ?? 0), 38)
                cellModel?.invalidateCell()
            }
        }
    }
    
    @IBAction func clickAvt(_ sender: Any?) {
        guard let uid = AppAccount.shared.getUserLogin()?.uid,
            let vc = parentViewController else { return }
        AppRouter.shared.gotoUserWall(uidUSer: uid, viewController: vc)
    }

}

extension MeCommentCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            autoAnimationHideButton()
        } else {
            autoAnimationNotHideButton()
        }
        cellModel?.nameText = textView.text
        autoSizeFor(textView: textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if uitextView.text == Const.plahoderComment {
            uitextView.text = ""
            autoAnimationNotHideButton()
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if uitextView.text == "" {
            uitextView.text = Const.plahoderComment
            autoAnimationHideButton()
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}


