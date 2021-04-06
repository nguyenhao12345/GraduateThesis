//
//  DetailMediaCell.swift
//  Piano_App
//
//  Created by Azibai on 14/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol DetailMediaCellDelegate: class {
    
}

class DetailMediaCellModel: AziBaseCellModel {
    
    var isLike: Bool = false
    var urlImage: String = ""
    var imageMusic: UIImage?
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return maxWidth*3/4
    }
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth - 24
    }
    
    override func getCellName() -> String {
        return DetailMediaCell.className
    }
}

class DetailMediaCell: CellModelView<DetailMediaCellModel> {
    
    weak var delegate: DetailMediaCellDelegate?
    @IBOutlet weak var viewHeart: ViewRound!
    @IBOutlet weak var imageView: HImageView!
    @IBOutlet weak var imageHeart: UIImageView!
    @IBOutlet weak var imageHeartFlag: UIImageView!


    @IBAction func clickLike(_ sender: Any?) {
        cellModel?.isLike = true
        imageHeart.image = UIImage(named: "heartLike")
        viewHeart.pulsateView()
    }
    
    func initGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(like))
        tap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func like() {
        viewHeart.alpha = 0
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.7, animations: {
            self.imageHeartFlag.transform = CGAffineTransform(
                translationX: -(self.contentView.width/2 - 28),
                y: -(self.contentView.height/2 - 24))
                .scaledBy(x: 4, y: 4)
            self.imageHeartFlag.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.imageHeartFlag.alpha = 0
                self.imageHeartFlag.transform = self.imageHeartFlag.transform.scaledBy(x: 3, y: 3)
            }) { _ in
                self.imageHeartFlag.transform = .identity
                self.imageHeartFlag.alpha = 1
                self.viewHeart.alpha = 1
                self.cellModel?.isLike = true
                self.imageHeart.image = UIImage(named: "heartLike")
                self.viewHeart.pulsateView()
                self.isUserInteractionEnabled = true

            }
        }
    }
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? DetailMediaCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initGesture()
    }
    
    override func bindCellModel(_ cellModel: DetailMediaCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        viewHeart.dropShadow(color: .white, opacity: 0.5, offSet: CGSize(width: 1, height: -1), radius: 18, scale: true)
        imageHeart.image = UIImage(named: cellModel.isLike ? "heartLike" : "heartunLike")
        if cellModel.imageMusic != nil {
            imageView.image = cellModel.imageMusic
        } else {
            imageView.setImageURL(URL(string: cellModel.urlImage))
        }
    }
    
}



//UIColor(hexString: AppColor.shared.colorBackGround.value)
