//
//  NavigationViewPayment.swift
//  Piano_App
//
//  Created by Azibai on 09/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

protocol NavigationViewPaymentDelegate: class {
    func selectedAt(index: Int)
    func selectedAt(typeSection: ManagerPaymentSectionFactory.TYPE)
    func clickBack()
}
extension NavigationViewPaymentDelegate {
    func clickBack() {}
}

class NavigationViewPayment: BaseView {
    weak var delegate: NavigationViewPaymentDelegate?

    @IBOutlet weak var containerView: ViewRound!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryView: UIView!

    @IBOutlet weak var titleLbl: UILabel!
    var isSelectectIndex: Int = 0
    var typeSelect: ManagerPaymentSectionFactory.TYPE = .Real
    var dataSource: [ManagerPaymentSectionFactory.TYPE] = []
    
    @IBAction func clickBack(_ sender: Any?) {
        delegate?.clickBack()
        parentViewController?.dismiss()
    }
    
    func getCurrentType() -> ManagerPaymentSectionFactory.TYPE {
        return typeSelect
    }
    
    func config(title: String, typeSelect: ManagerPaymentSectionFactory.TYPE = .None, dataSource: [ManagerPaymentSectionFactory.TYPE] = []) {
        self.titleLbl.text = title
        self.typeSelect = typeSelect
        if typeSelect == .None {
            categoryView.isHidden = true
            return
        }
        self.dataSource = dataSource
        collectionView.reloadData {
            self.collectionView.scrollToItem(at: IndexPath(item: dataSource.indexOfObject(typeSelect) ?? 0, section: 0), at: .centeredHorizontally, animated: true)
            self.delegate?.selectedAt(index: dataSource.indexOfObject(typeSelect) ?? 0)
            self.delegate?.selectedAt(typeSection: typeSelect)
        }
    }
    
    override func loadingViewComplete(childView: UIView) {
        super.loadingViewComplete(childView: childView)
        // shadow
        shawDowNav(view: containerView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib: UINib(nibName: "HeaderPaymentTextCollectionViewCell", bundle: nil), forCellWithClass: HeaderPaymentTextCollectionViewCell.self)
    }
    func shawDowNav(view: UIView) {
        view.layer.shadowColor = #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 13.0
    }
    
    func sizeFor(_ str: String, witdh: CGFloat) -> CGSize {
        let dumpLabel = UILabel(frame: .zero)
        dumpLabel.numberOfLines = 0
        dumpLabel.text = str
        dumpLabel.textAlignment = .left
        dumpLabel.font = UIFont.kohoRegular12
        let size = dumpLabel.sizetWithMaxWidth(witdh, lineLimit: 0)
        return CGSize(width: size.width, height: size.height)
    }

}
extension NavigationViewPayment: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: HeaderPaymentTextCollectionViewCell.self, for: indexPath)
        cell.titleLbl.text = dataSource[indexPath.item].nameString
        cell.titleLbl.textColor = dataSource[indexPath.item] == typeSelect ? #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1): #colorLiteral(red: 0.537254902, green: 0.537254902, blue: 0.537254902, alpha: 1)
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = dataSource[indexPath.item] == typeSelect ? #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1): UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = #colorLiteral(red: 0.7882352941, green: 0.6588235294, blue: 0.4196078431, alpha: 1).cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 10
        return cell
    }
    
    
}

extension NavigationViewPayment: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelectectIndex = indexPath.item
        typeSelect = self.dataSource[indexPath.item]
        collectionView.reloadData {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.delegate?.selectedAt(index: indexPath.item)
            self.delegate?.selectedAt(typeSection: self.typeSelect)
        }
    }
}

extension NavigationViewPayment: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sizeFor(dataSource[indexPath.item].nameString, witdh: Const.widthScreens).width + 32, height: 36)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
