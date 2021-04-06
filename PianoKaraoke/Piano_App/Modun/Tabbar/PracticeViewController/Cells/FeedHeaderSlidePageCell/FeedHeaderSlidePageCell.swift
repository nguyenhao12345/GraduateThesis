//
//  FeedHeaderSlidePageCell.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol FeedHeaderSlidePageCellDelegate: class {
    
}

class FeedHeaderSlidePageCellModel: AziBaseCellModel {
    var dataModels: [SongsLocalDetail]  = []
    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 240
    }
    
    override func getCellName() -> String {
        return FeedHeaderSlidePageCell.className
    }
    
    func callAPI() {
        
    }
}

class FeedHeaderSlidePageCell: CellModelView<FeedHeaderSlidePageCellModel> {
    
    weak var delegate: FeedHeaderSlidePageCellDelegate?
    
    private var _newsImageIndex = 0

    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var viewBottom: UIView!

    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? FeedHeaderSlidePageCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(UINib(nibName: "FeedHeaderDetailFSPagerCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        pagerView.transformer = FSPagerViewTransformer(type: .crossFading)
        pagerView.isInfinite = true
//        pagerView.durationAnimated = 2
//        pagerView.automaticSlidingInterval = 3
    }
    @IBAction func click() {
        cellModel?.callAPI()
    }
    
    
    override func bindCellModel(_ cellModel: FeedHeaderSlidePageCellModel) {
        super.bindCellModel(cellModel)
        //TODO
        viewBottom.roundCorners([.topLeft, .topRight], radius: 12)
        pagerView.dropShadow(color: .black, opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 6.5, scale: true)
    }
    
    
}




extension FeedHeaderSlidePageCell : FSPagerViewDelegate{
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool{
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int){
        
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool{
         return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int){
//        guard let _news = cellModel?.news else { return }
//        if let image = _news.newsMedia[index] as? NewsImage {
//            _showMediaDetail(mediaType: .image, id: image.id)
//        }
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int){
    }
    
    func pagerView(_ pagerView: FSPagerView, didEndDisplaying cell: FSPagerViewCell, forItemAt index: Int){
    }
    
    func pagerViewWillBeginDragging(_ pagerView: FSPagerView){
        
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int){
        _newsImageIndex = targetIndex
//        AppColor.shared.colorBackGround.accept(AppColor.shared.getColor())
//        AppColor.shared.colorBackGround.accept(AppColor.shared.getColor())
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView){
        
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView){
        _newsImageIndex = pagerView.currentIndex
//        getColor
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView){
    
    }
}

//MARK: FSPagerViewDataSource
extension FeedHeaderSlidePageCell: FSPagerViewDataSource{
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return cellModel?.dataModels.count ?? 0
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let object = cellModel?.dataModels[index],
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? FeedHeaderDetailFSPagerCell else { return FSPagerViewCell() }
        cell.configUI(object: object)
        return cell
    }
}
