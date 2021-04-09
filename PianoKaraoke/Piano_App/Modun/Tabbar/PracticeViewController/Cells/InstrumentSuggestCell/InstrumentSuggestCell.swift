//
//  InstrumentSuggestCell.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol InstrumentSuggestCellDelegate: class {
    func remove(by: InstrumentSuggestCellModel?)
    func clickDownLoad(by: InstrumentSuggestCellModel?)
}

class InstrumentSuggestCellModel: AziBaseCellModel {
    var dataModel: MusicModel?
    var isHiddenBtnRemove: Bool = true
    var isHiddenImagePlay: Bool = false
    var isHiddenDownLoad: Bool = true
    var isSwiping: Bool = false
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 88
    }
    
    override func getCellWidth(maxWidth: CGFloat) -> CGFloat {
        return maxWidth - 44
    }
    override func getCellName() -> String {
        return InstrumentSuggestCell.className
    }
}

class InstrumentSuggestCell: CellModelView<InstrumentSuggestCellModel>, UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let swipe = gestureRecognizer as? UIPanGestureRecognizer {
            if swipe.direction == PanDirection.left ||
                swipe.direction == PanDirection.right {
                return false
            }
            return true
        }
        if let swipe2 = otherGestureRecognizer as? UIPanGestureRecognizer {
            if swipe2.direction == PanDirection.left ||
                swipe2.direction == PanDirection.right {
                return false
            }
            return true
        }
        return false
    }
    weak var delegate: InstrumentSuggestCellDelegate?
    @IBOutlet weak var imagePlay: UIImageView!
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var nameSongLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var viewLevel: Level!
    @IBOutlet weak var text3Lbl: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var viewRemove: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var rightConst: NSLayoutConstraint!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? InstrumentSuggestCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initGesture()
        imagePlay.tintColor = UIColor.hexStringToUIColor(hex: AppColor.shared.colorBackGround.value, alpha: 1)
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.imagePlay.tintColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)
    }
    
    override func bindCellModel(_ cellModel: InstrumentSuggestCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        imageSong.setImageURL(URL(string: cellModel.dataModel?.imageSong ?? ""))
        nameSongLbl.text = cellModel.dataModel?.nameSong
        authorLbl.text = cellModel.dataModel?.author
        viewLevel.config(numberStars: cellModel.dataModel?.level ?? 0)
        btnRemove.isHidden = true
        btnDownload.isHidden = cellModel.isHiddenDownLoad
        viewLevel.layoutIfNeeded()
        
        if ((cellModel.dataModel?.youtubeModel) != nil) {
            imagePlay.isHidden = true
            viewLevel.isHidden = true
            text3Lbl.text = ""
            nameSongLbl.numberOfLines = 3
        } else {
            imagePlay.isHidden = false
            viewLevel.isHidden = false
            text3Lbl.text = "Độ khó"
            nameSongLbl.numberOfLines = 2
        }
        imagePlay.isHidden = cellModel.isHiddenImagePlay
        rightConst.constant = -self.height
//        self.viewRemove.isHidden = true
        viewRemove.roundCorners([.topRight, .bottomRight], radius: 12)
    }
    
    @IBAction func clickRemove(_ sender: Any) {
        delegate?.remove(by: self.cellModel)
    }
    @IBAction func clickDownload(_ sender: Any) {
        delegate?.clickDownLoad(by: self.cellModel)
    }
    
    func initGesture() {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(swipeToLeft))
        viewContent.isUserInteractionEnabled = true
        swipe.delegate = self
        viewContent.addGestureRecognizer(swipe)
    }
    
    @objc func swipeToLeft(recognizer: UIPanGestureRecognizer) {
        
        if cellModel?.isHiddenBtnRemove ?? false {
            return
        }
        
        switch recognizer.state {
        case .possible:
            break
        case .began:
            cellModel?.isSwiping = true
        case .changed:
            cellModel?.isSwiping = true
        case .ended:
            if viewContent.x >= -viewRemove.width/2 {
                UIView.animate(withDuration: 0.3) {
                    self.hiddenRemoveView()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.showRemoveView()
                }
            }

        case .cancelled:
            cellModel?.isSwiping = false
        case .failed:
            cellModel?.isSwiping = false
        @unknown default:
            cellModel?.isSwiping = false
        }
        
        
        let translation = recognizer.translation(in: self)
        
        if recognizer.direction == .left {
            let newX: CGFloat = viewContent.center.x + translation.x
            let newY: CGFloat = viewContent.center.y
            
            viewContent.center = CGPoint(x: newX, y: newY)
            viewRemove.center = CGPoint(x: viewRemove.center.x + translation.x, y: viewRemove.center.y)
            if viewContent.width - viewRemove.width <= viewRemove.x {
                print("=====K Xoá")
            } else {
                print("===== Xoá")
                showRemoveView()
            }
        } else if recognizer.direction == .right {
            let newX: CGFloat = viewContent.center.x + translation.x
            let newY: CGFloat = viewContent.center.y
            
            viewContent.center = CGPoint(x: newX, y: newY)
            viewRemove.center = CGPoint(x: viewRemove.center.x + translation.x, y: viewRemove.center.y)
            
            if viewContent.x >= 0 {
                hiddenRemoveView()
            }
        }
       
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    func showRemoveView() {
        let x = viewContent.width - viewRemove.width + viewRemove.width/2
        let xContent = viewContent.width - viewRemove.width - viewContent.width/2
        viewRemove.center = CGPoint(x: x, y: viewRemove.center.y)
        viewContent.center = CGPoint(x: xContent, y: viewContent.center.y)
        self.delegate?.remove(by: cellModel)
    }
    
    func hiddenRemoveView() {
        viewRemove.center = CGPoint(x: viewContent.width + viewRemove.width/2 , y: viewRemove.center.y)
        viewContent.center = CGPoint(x: viewContent.width/2, y: viewContent.center.y)
    }
}



