//
//  SegmentCustom.swift
//  LearnRxSwift
//
//  Created by Nguyen Hieu on 1/11/20.
//  Copyright © 2020 com.nguyenhieu.BaseProject. All rights reserved.
//

import UIKit

public class SegmentedMenuView: BaseView {
    // MARK: Core Properties
    weak var delegate : SegmentedMenuDelegate?
    var presenter: SegmentedMenuViewPresenter!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    let lineView = UIView(frame: CGRect.zero)
    
    
    var normalColor = UIColor.black
    var lineColor = UIColor(hexString: "334669")
    var loaded = false
    private var priViewDidLoaded = false
    
    var lineHeight: CGFloat = 2

    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.priViewDidLoaded {
            self.priViewDidLoaded = true
            self.viewDidLoad()
        }
    }
    
    func viewDidLoad() {
        presenter?.viewIsReady()
        self.initCollection()
        self.initLine()
        self.loaded = true
        self.reloadIndex()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    deinit {
        presenter?.viewDealloc()
    }
    
    func initLine() {
        self.lineView.frame = CGRect(x: 0, y: self.height - self.lineHeight, width: self.widthForIndex(0), height: lineHeight)
        self.lineView.backgroundColor = self.lineColor
        self.collectionView.addSubview(self.lineView)
    }
    
    func initCollection() {
        self.collectionView.register(UINib.init(nibName: "SegmentedMenuCell", bundle: nil), forCellWithReuseIdentifier: "SegmentedMenuCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.updateLineView()
    }
    
    func updateLineView(){
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.lineView.width = self.presenter!.widthCurrentIndex()
            self.lineView.x = self.presenter!.xForCurrentIndex()
        }, completion: nil)
    }
    
    func widthForIndex(_ index: NSInteger) -> CGFloat{
        return self.presenter!.widthForIndex(index)
    }
}

extension SegmentedMenuView: SegmentedMenuViewInput {
    
    // Any -> View
    // TODO: Declare view methods
    
    
    public func getView() -> UIView {
        return self
    }
    
    public func reloadData(){
        self.collectionView.reloadData()
    }
    
    public func reloadIndex(){
        if self.loaded{
            self.updateLineView()
            self.collectionView.scrollToItem(at: IndexPath(item: self.presenter!.getIndex(), section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
            self.reloadData()
        }
    }
    
    public func setLineHeight(_ height: CGFloat) {
        self.lineHeight = height
    }
}

extension SegmentedMenuView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter!.numberOfItem()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: SegmentedMenuCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentedMenuCell", for: indexPath) as? SegmentedMenuCell

        
        let selected = indexPath.row == self.presenter!.getIndex()
        //334669
        cell.titleLabel?.textColor = UIColor(hexString: "334669")
        if selected {
            cell.titleLabel?.font = UIFont.HelveticaNeueBold16
        } else {
            cell.titleLabel?.font = UIFont.HelveticaNeue14
        }
//        cell.titleLabel?.font = selected ? self.lineColor : self.normalColor
        if let data = self.presenter?.itemAtIndex(indexPath.item) {
            cell.titleLabel.text = data.title
        }
        return cell
    }
}

extension SegmentedMenuView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter?.selectIndex(indexPath.item)
    }
}

extension SegmentedMenuView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.widthForIndex(indexPath.item), height: self.presenter.getHeight())
        return size
    }
}
