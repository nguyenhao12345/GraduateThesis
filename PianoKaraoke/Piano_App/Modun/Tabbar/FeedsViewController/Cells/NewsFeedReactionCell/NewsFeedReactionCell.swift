//
//  NewsFeedReactionCell.swift
//  Piano_App
//
//  Created by Azibai on 30/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol NewsFeedReactionCellDelegate: class {
    
}

class NewsFeedReactionCellModel: AziBaseCellModel {
    var isHiddenCountLike: Bool {
        return dataModel?.likes.count == 0
    }
    
    let like: String = "Thích"
    let comment: String = "Bình luận"
    let share: String = "Chia sẽ"
    var dataModel: NewsFeedModel? 
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        if dataModel?.likes.count ?? 0 > 0 {
            return 88
        }
        return 44
    }
    
    override func getCellName() -> String {
        return NewsFeedReactionCell.className
    }
}

class NewsFeedReactionCell: CellModelView<NewsFeedReactionCellModel> {
    
    weak var delegate: NewsFeedReactionCellDelegate?
    @IBOutlet weak var viewShowLike: UIView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var countLikeLbl: UILabel!
    @IBOutlet weak var imgLikeIcon: UIImageView!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? NewsFeedReactionCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.likeLbl.textColor = self?.cellModel?.dataModel?.isLike ?? false ? UIColor.hexStringToUIColor(hex: hex, alpha: 1): UIColor.defaultText
                self?.imgLikeIcon.tintColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

        initGesture()
    }
    
    override func bindCellModel(_ cellModel: NewsFeedReactionCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        viewShowLike.isHidden = cellModel.isHiddenCountLike
        
        likeLbl.text = cellModel.like
        commentLbl.text = cellModel.comment
        shareLbl.text = cellModel.share
        
        commentLbl.textColor = UIColor.defaultText
        shareLbl.textColor = UIColor.defaultText

        if let count = cellModel.dataModel?.likes.count {
            countLikeLbl.text = "\(count) Thích"
        }
        likeLbl.textColor = cellModel.dataModel?.isLike ?? false ? UIColor(hexString: AppColor.shared.colorBackGround.value): UIColor.defaultText
        likeLbl.font = cellModel.dataModel?.isLike ?? false ?  .HelveticaNeueBold16: .HelveticaNeueMedium16
    }
    
    func initGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.clickLike))
        likeLbl.isUserInteractionEnabled = true
        likeLbl.addGestureRecognizer(tap)
    }
    
    @objc func clickLike() {
        guard let news = cellModel?.dataModel else { return }
        if cellModel?.dataModel?.isLike ?? false {
            ServiceOnline.share.updateLikeNews(news: news, isLike: false)
            cellModel?.dataModel?.likes.removeEqualItems(item: AppAccount.shared.getUserLogin()?.uid ?? "")
        } else {
            ServiceOnline.share.updateLikeNews(news: news, isLike: true)
            cellModel?.dataModel?.likes.append(AppAccount.shared.getUserLogin()?.uid ?? "")
        }
        cellModel?.reloadCell(true)
    }    
}



