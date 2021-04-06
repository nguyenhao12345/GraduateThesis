//
//  TopMusicsCell.swift
//  Piano_App
//
//  Created by Azibai on 12/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
//import Koloda

protocol TopMusicsCellDelegate: class {
    
}

class TopMusicsCellModel: AziBaseCellModel {
    
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 271
    }
    
    override func getCellName() -> String {
        return TopMusicsCell.className
    }
}

class TopMusicsCell: CellModelView<TopMusicsCellModel> {
    
    weak var delegate: TopMusicsCellDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? TopMusicsCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(nibWithCellClass: TopMusicCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    override func bindCellModel(_ cellModel: TopMusicsCellModel) {
        super.bindCellModel(cellModel)
        //TODO
    }
    
}

extension TopMusicsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopMusicCell", for: indexPath) as? TopMusicCell else { return UICollectionViewCell() }
        cell.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: 1, height: 1), radius: 4, scale: true)

        cell.config()
        return cell
    }
    
    
}

extension TopMusicsCell: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        cellModel?.contentOffset = scrollView.contentOffset
//    }
}

extension TopMusicsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width - 80, height: (collectionView.height - 12*2)/3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}



