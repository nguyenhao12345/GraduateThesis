//
//  VietSongsCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol VietSongsCellDelegate: class {
    
}

class VietSongsCellModel: AziBaseCellModel {
    var dataModels: [MusicModel] = []
    var contentOffset: CGPoint = CGPoint(x: -24, y: 0)
    
    var title: String = ""
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 240
    }
    
    override func getCellName() -> String {
        return VietSongsCell.className
    }
}

class VietSongsCell: CellModelView<VietSongsCellModel> {
    
    weak var delegate: VietSongsCellDelegate?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? VietSongsCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.register(nibWithCellClass: VietSongDetailCell.self)
        collectionView.register(nibWithCellClass: LoadingSongCell.self)

        containerView.backgroundColor = UIColor.hexStringToUIColor(hex: AppColor.shared.colorBackGround.value, alpha: 1)
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.containerView.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }
    
    override func bindCellModel(_ cellModel: VietSongsCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        titleLbl.text = cellModel.title
        collectionView.reloadData()
        collectionView.contentOffset = cellModel.contentOffset
        
    }
    
}

extension VietSongsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellModel?.dataModels.count == 0 {
          return 3
        } else {
            return cellModel?.dataModels.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellModel?.dataModels.count == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingSongCell", for: indexPath) as? LoadingSongCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VietSongDetailCell", for: indexPath) as? VietSongDetailCell else { return UICollectionViewCell() }
            cell.config(object: cellModel?.dataModels[indexPath.item])
            return cell
        }
    }
    
    
}

extension VietSongsCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath)
                as? VietSongDetailCell,
            let imageView = selectedCell.imageView
            else { return }
        
        guard let dataModel = cellModel?.dataModels[indexPath.item],
            let viewController = parentViewController else { return }
        AppRouter.shared.gotoDetailMusic(id: dataModel.idDetail ?? "", viewController: viewController, frameAnimation: imageView.globalFrame, viewAnimation: imageView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        cellModel?.contentOffset = scrollView.contentOffset
    }
}

extension VietSongsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width / 3, height: collectionView.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
