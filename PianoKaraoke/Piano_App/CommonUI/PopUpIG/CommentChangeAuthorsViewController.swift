//
//  CommentChangeAuthorsViewController.swift
//  Azibai
//
//  Created by Azibai on 05/06/2020.
//  Copyright © 2020 Azi IOS. All rights reserved.
//

import UIKit
import IGListKit
import Mapper
import SwiftyJSON

protocol CommentChangeAuthorsDelegate: class {
    //    func changeAuthorComment(object: UserShop)
}

class CommentChangeAuthorsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewPan: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewTmp: UIView!
    
    
    //MARK: Properties
    let MAX_HEIGHT: CGFloat = Const.heightScreen*0.9
    var MIN_HEIGHT: CGFloat = Const.heightScreen*0.5
    lazy var extraHeight: CGFloat = {
        if titlePop == "" {
            return 0
        }
        return 56
    }()
    
    var MEDIUM_HEIGHT: CGFloat {
        return (MAX_HEIGHT + MIN_HEIGHT)/2
    }
    
    var delegate: CommentChangeAuthorsDelegate?
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    //    var object: UserShop?
    var dataSource: [AziBaseSectionModel] = []
    let sectionBuilder = SectionBuilder()
    private var nearestIndex: CGFloat = 0.0
    var panCls: UIPanGestureRecognizer!
    var titlePop: String = "Chọn tư cách bình luận"
    
    //MARK: Init
    init() {
        super.init(nibName: "CommentChangeAuthorsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
        self.titleLbl.text = titlePop
        viewTitle.isHidden = titlePop == ""
//        collectionView.isScrollEnabled = false
    }
    
    //MARK: Method
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewTmp.roundCorners([.topRight, .topLeft], radius: 20)
        let h = adapter.collectionView?.collectionViewLayout.collectionViewContentSize.height
        heightConst.constant = min(MIN_HEIGHT, ((h ?? MIN_HEIGHT) + extraHeight))
        MIN_HEIGHT = min(MIN_HEIGHT, ((h ?? MIN_HEIGHT) + extraHeight))
        
        print("viewDidAppear MIN_HEIGHT \(MIN_HEIGHT)")
        print("viewDidAppear heightConst.constant \(heightConst.constant)")
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func initGesture() {
    }
    var startPanLocationY: CGFloat = 0
    
    @objc func tapToDismiss() {
        
        self.heightConst.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func viewIsReady() {
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
        adapter.scrollViewDelegate = self
        adapter.collectionView?.bouncesZoom = false
        initGesture()
    }
    
    var isScroll: Bool = false
}

//MARK: ListAdapterDataSource
extension CommentChangeAuthorsViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return dataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return sectionBuilder.getSection(object: object, presenter: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

//MARK: IGListAdapterDelegate
extension CommentChangeAuthorsViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}

//MARK: UIScrollViewDelegate
extension CommentChangeAuthorsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let currentLocation = scrollView.panGestureRecognizer.location(in: self.view)

        print("currentLocation \(currentLocation.y)")
//        if startPanLocationY == 0 {
//            startPanLocationY = currentLocation.y
//        }
//
//        if (collectionView.contentOffset.y <= 0 && scrollView.panGestureRecognizer.direction == .down) ||
//            (scrollView.panGestureRecognizer.direction == .up && collectionView.contentOffset.y > 0)
//            {
//            if !isScroll {
//                isScroll = true
//                scrollView.setContentOffset(.zero, animated: false)
//                return
//            }
//
//            if isScroll {
//                scrollView.setContentOffset(.zero, animated: false)
//                let end = Float(currentLocation.y)
//                let start = Float(startPanLocationY)
//                self.heightConst.constant += CGFloat(start - end)
//                self.startPanLocationY = currentLocation.y
//            }
//        }
        

        //////////////
        if collectionView.contentOffset.y <= 0 {
            if scrollView.panGestureRecognizer.direction == .down {
                isScroll = true
                if startPanLocationY == 0 {
                    startPanLocationY = currentLocation.y
                    scrollView.setContentOffset(.zero, animated: false)
                    return
                }

                if isScroll {
                    scrollView.setContentOffset(.zero, animated: false)
                    let end = Float(currentLocation.y)
                    let start = Float(startPanLocationY)
                    self.heightConst.constant += CGFloat(start - end)
                }
                self.startPanLocationY = currentLocation.y

            }

        } else {    //lon hon 0
            if scrollView.panGestureRecognizer.direction == .up {
                if heightConst.constant == MIN_HEIGHT {
                    isScroll = true
                    if startPanLocationY == 0 {
                        startPanLocationY = currentLocation.y
                        heightConst.constant = MIN_HEIGHT
                        scrollView.setContentOffset(.zero, animated: false)
                        return
                    }
                }
                if heightConst.constant >= MAX_HEIGHT {
                    heightConst.constant = MAX_HEIGHT
                    return
                }

                if isScroll {
                    scrollView.setContentOffset(.zero, animated: false)
                    let end = Float(currentLocation.y)
                    let start = Float(startPanLocationY)
                    self.heightConst.constant += CGFloat(start - end)
                }
                self.startPanLocationY = currentLocation.y

            }
        }

    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("================================")

        startPanLocationY = 0
        isScroll = false
        
        if heightConst.constant >= MEDIUM_HEIGHT - 50 {
            self.heightConst.constant = MAX_HEIGHT
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
//            print("heightConst.constant >= MEDIUM_HEIGHT \(heightConst.constant)")
        }
        else {
            if heightConst.constant >= MIN_HEIGHT {
                heightConst.constant = MIN_HEIGHT
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
//                print("heightConst.constant >= MIN_HEIGHT \(heightConst.constant)")
            }
            else {
//                print("heightConst.constant \(heightConst.constant)")
//                print("MIN_HEIGHT \(MIN_HEIGHT)")
//                print("dissmiss")
                tapToDismiss()
            }
        }
        

    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    }
}

extension CommentChangeAuthorsViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        
        print("gestureRecognizer: \(gestureRecognizer) -------- otherGestureRecognizer: \(otherGestureRecognizer)")
        return false
    }
}


