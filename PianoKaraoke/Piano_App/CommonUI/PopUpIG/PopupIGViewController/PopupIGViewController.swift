//
//  PopupIGViewController.swift
//  gapoFeedClone
//
//  Created by Azibai on 30/07/2020.
//  Copyright © 2020 com.hieudev. All rights reserved.
//

import UIKit
import IGListKit

class PopupIGViewController: CommentChangeAuthorsViewController {
    
    //MARK: Outlets
    var completionHandle: ((String, Int) -> Void)? = nil
    //MARK: Properties
//    var titlePop: String = ""
    var txthightLight: String = ""
    //MARK: Init
    
    class func showAlert(viewController: UIViewController?,
                         title: String,
                         dataSource: [String],
                         hightLight: String = "",
                         attributes: [NSAttributedString.Key : Any]? = nil, completion: ((String, Int) -> Void)? = nil) {
        let vc = PopupIGViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.titlePop = title
        vc.txthightLight = hightLight
        vc.dataSource.append(PopupIGSectionModel(dataModels: dataSource, attributes: attributes, txthightLight: hightLight))
        vc.completionHandle = { (value, index) in
            vc.dismiss(animated: false) {
                DispatchQueue.main.async {
                    completion?(value, index)
                }
            }
        }
        viewController?.present(vc, animated: false, completion: nil)
    }
    
    override init() {
        super.init()
//        self.modalPresentationStyle = .overCurrentContext
//        self.titlePop = titlePop
//        dataSource.append(PopupIGSectionModel(dataModels: dataPopup))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.titleLbl.text = titlePop
    }
    
    //MARK: Method
    
    
}


//
//  CommentChangeAuthorsViewController.swift
//  Azibai
//
//  Created by Azibai on 05/06/2020.
//  Copyright © 2020 Azi IOS. All rights reserved.
////
//
//import UIKit
//import IGListKit
//import Mapper
//import SwiftyJSON
//
//protocol CommentChangeAuthorsDelegate: class {
////    func changeAuthorComment(object: UserShop)
//}
//
//class CommentChangeAuthorsViewController: UIViewController {
//    
//    //MARK: Outlets
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var heightConst: NSLayoutConstraint!
//    @IBOutlet weak var viewContainer: UIView!
//    @IBOutlet weak var viewPan: UIView!
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var viewTitle: UIView!
//    @IBOutlet weak var viewTmp: UIView!
//
//    
//    //MARK: Properties
//    let MAX_HEIGHT: CGFloat = Const.heightScreen*0.9
//    var MIN_HEIGHT: CGFloat = Const.heightScreen*0.5
//    lazy var extraHeight: CGFloat = {
//        if titlePop == "" {
//            return 0
//        }
//        return 56
//    }()
//    
//    var MEDIUM_HEIGHT: CGFloat {
//        return (MAX_HEIGHT + MIN_HEIGHT)/2
//    }
//    
//    var delegate: CommentChangeAuthorsDelegate?
//    private var isFetchingMore: Bool = false
//    var adapter: ListAdapter!
////    var object: UserShop?
//    var dataSource: [AziBaseSectionModel] = []
//    let sectionBuilder = SectionBuilder()
//    private var nearestIndex: CGFloat = 0.0
//    var panCls: UIPanGestureRecognizer!
//    var titlePop: String = "Chọn tư cách bình luận"
//
//    //MARK: Init
//    init() {
//        super.init(nibName: "CommentChangeAuthorsViewController", bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: Life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        viewIsReady()
//        self.titleLbl.text = titlePop
//        viewTitle.isHidden = titlePop == ""
////        if titlePop == "" {
////            collectionView.cornerRadius = 20
//////            collectionView.roundCorners([.topRight, .topLeft], radius: 10)
////        }
//    }
//    
//    //MARK: Method
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        viewTmp.roundCorners([.topRight, .topLeft], radius: 20)
//        let h = adapter.collectionView?.collectionViewLayout.collectionViewContentSize.height
//        heightConst.constant = min(MIN_HEIGHT, ((h ?? MIN_HEIGHT) + extraHeight))
//        MIN_HEIGHT = heightConst.constant
//        UIView.animate(withDuration: 0.2, animations: {
//            self.view.layoutIfNeeded()
//        })
//    }
//    func initGesture() {
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandle(_:)))
//        view.addGestureRecognizer(pan)
//        
//        panCls = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandle(_:)))
//        panCls.delegate = self
//        collectionView.addGestureRecognizer(panCls)
//    }
//    var lastConstraint: CGFloat = 0
//    var startPanLocationY: CGFloat = 0
//    
//    @objc func panGestureHandle(_ sender: UIPanGestureRecognizer) {
//        let currentLocation = sender.location(in: self.view)
//
//        switch sender.state {
//        case .changed:
//            let a = Float(currentLocation.y)
//            let b = Float(startPanLocationY)
//            if a > b {
//                let distance = a - b
//                if heightConst.constant < 0 {}
//                else { self.heightConst.constant -= CGFloat(distance) }
//            }
//            else {
//                if heightConst.constant < MAX_HEIGHT {
//                    let distance = b - a
//                    self.heightConst.constant += CGFloat(distance)
//                }
//                else {
//                    if panCls.isEnabled {
//                        collectionView.setContentOffset(.init(x: 0, y: collectionView.contentOffset.y + CGFloat(b - a)), animated: false)
//                    }
//                }
//            }
//            self.startPanLocationY = currentLocation.y
//            self.lastConstraint = heightConst.constant
//
//        case .began:
//            startPanLocationY = currentLocation.y
//        case .ended:
//            if heightConst.constant >= MEDIUM_HEIGHT {
//                self.heightConst.constant = MAX_HEIGHT
//                panCls.isEnabled = false
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.view.layoutIfNeeded()
//                })
//            }
//            else {
//                if heightConst.constant >= MIN_HEIGHT {
//                    heightConst.constant = MIN_HEIGHT
//                    panCls.isEnabled = true
//                    UIView.animate(withDuration: 0.2, animations: {
//                        self.view.layoutIfNeeded()
//                    })
//                }
//                else {
//                    tapToDismiss()
//                }
//            }
//            startPanLocationY = 0
//        default: break
//        }
//    }
//    
//    @objc func tapToDismiss() {
//        
//        self.heightConst.constant = 0
//        UIView.animate(withDuration: 0.2, animations: {
//            self.view.layoutIfNeeded()
//        }) { (finished) in
//            self.dismiss(animated: false, completion: nil)
//        }
//    }
//    
//    func viewIsReady() {
//        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
//        adapter.collectionView = collectionView
//        adapter.dataSource = self
//        adapter.delegate = self
//        adapter.scrollViewDelegate = self
//        adapter.collectionView?.bouncesZoom = false
//        initGesture()
//    }
//    
//    var isScroll: Bool = false
//}
//
////MARK: ListAdapterDataSource
//extension CommentChangeAuthorsViewController: ListAdapterDataSource {
//    
//    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//        return dataSource
//    }
//    
//    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//        return sectionBuilder.getSection(object: object, presenter: self)
//    }
//    
//    func emptyView(for listAdapter: ListAdapter) -> UIView? {
//        return nil
//    }
//    
//}
//
////MARK: IGListAdapterDelegate
//extension CommentChangeAuthorsViewController: IGListAdapterDelegate {
//    
//    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
//        
//    }
//    
//    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
//        
//    }
//    
//}
//
////MARK: UIScrollViewDelegate
//extension CommentChangeAuthorsViewController: UIScrollViewDelegate {
//    
//    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
//        panCls.isEnabled = true
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //        print(scrollView.contentOffset)
//        let currentLocation = scrollView.panGestureRecognizer.location(in: self.view)
//        if scrollView.panGestureRecognizer.direction == .down && collectionView.contentOffset.y <= 0 {
//            panCls.isEnabled = true
////            scrollView.setContentOffset(.zero, animated: false)
//            print("scrollViewDidScroll \(currentLocation)")
//            isScroll = true
//            if startPanLocationY == 0 {
//                startPanLocationY = currentLocation.y
//                return
//            }
//            if isScroll {
//                scrollView.setContentOffset(.zero, animated: false)
//                let a = Float(currentLocation.y)
//                let b = Float(startPanLocationY)
//                if a > b {
//                    let distance = a - b
//                    if heightConst.constant < 0 {}
//                    else { self.heightConst.constant -= CGFloat(distance) }
//                }
//                else {
//                    if heightConst.constant < MAX_HEIGHT {
//                        let distance = b - a
//                        self.heightConst.constant += CGFloat(distance)
//                    }
//                    else {
//                        if panCls.isEnabled {
//                            collectionView.setContentOffset(.init(x: 0, y: collectionView.contentOffset.y + CGFloat(b - a)), animated: false)
//                        }
//                    }
//                }
//                self.startPanLocationY = currentLocation.y
//                self.lastConstraint = heightConst.constant
//            }
//        }
//        else {
//            if isScroll {
//                scrollView.setContentOffset(.zero, animated: false)
//                let a = Float(currentLocation.y)
//                let b = Float(startPanLocationY)
//                if a > b {
//                    let distance = a - b
//                    if heightConst.constant < 0 {}
//                    else { self.heightConst.constant -= CGFloat(distance) }
//                }
//                else {
//                    if heightConst.constant < MAX_HEIGHT {
//                        let distance = b - a
//                        self.heightConst.constant += CGFloat(distance)
//                    }
//                    else {
//                        if panCls.isEnabled {
//                            collectionView.setContentOffset(.init(x: 0, y: collectionView.contentOffset.y + CGFloat(b - a)), animated: false)
//                        }
//                    }
//                }
//                self.startPanLocationY = currentLocation.y
//                self.lastConstraint = heightConst.constant
//            }
//
//        }
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if panCls.isEnabled {
//            startPanLocationY = 0
//            if heightConst.constant >= MEDIUM_HEIGHT {
//                self.heightConst.constant = MAX_HEIGHT
//                panCls.isEnabled = false
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.view.layoutIfNeeded()
//                })
//            }
//            else {
//                if heightConst.constant >= MIN_HEIGHT {
//                    heightConst.constant = MIN_HEIGHT
//                    panCls.isEnabled = true
//                    UIView.animate(withDuration: 0.2, animations: {
//                        self.view.layoutIfNeeded()
//                    })
//                }
//                else {
//                    tapToDismiss()
//                }
//            }
//
//        }
//    }
//}
//
//extension CommentChangeAuthorsViewController : UIGestureRecognizerDelegate {
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
//
//        print("gestureRecognizer: \(gestureRecognizer) -------- otherGestureRecognizer: \(otherGestureRecognizer)")
//        return false
//    }
//}
//
//
