//
//  AccountViewController.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit
import YoutubeKit
import RxSwift
import RxCocoa


class AccountViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var nav: SearchNavigationView!

    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: Properties
    private var isFetchingMore: Bool = false
    var adapter: ListAdapter!
    var dataSource: [AziBaseSectionModel] = [AccountSectionModel()]

    //MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initUIVariable() {
        super.initUIVariable()
        self.hidesNavigationbar = true
        self.hidesToolbar = true
    }
    
    @IBAction func gotoLocal(_ sender: Any?) {
        let vc = LocalSongsViewController()
        self.navigationController?.push(vc, animation: true)
    }
    
    @IBAction func changeKeyYoutube(_ sender: Any?) {
        self.showAlert(title: "Key Youtube", message: "", buttonTitles: keyAPIYoube, highlightedButtonIndex: nil) { (index) in
            currentKeyAPIYoube = keyAPIYoube[index]
            YoutubeKit.shared.setAPIKey(currentKeyAPIYoube)
        }
    }
    
    @IBAction func gotoSearchYoutube(_ sender: Any?) {
        let vc = SearchSongYoutubeViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickPlayYoutubeLocal(_ sender: Any?) {
               let vc = PianoCustomViewController()
         vc.config(link: LocalVideoManager.shared.getURLVideoLocal(key: LocalVideoManager.shared.VideoYoutube),
                   nameSong: "YouTube",
                   typeCellInitViewController: TypeCell.CellYoutube)
         vc.modalTransitionStyle = .crossDissolve
         vc.modalPresentationStyle = .fullScreen
         present(vc, animated: true, completion: nil)
    }

    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
        nav.addShadow(location: .bottom)
        nav.hiddenBtnCancel()
        nav.delegate = self

        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.nav.backgroundColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }
    
    //MARK: Method
    func viewIsReady() {
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 5)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
        adapter.scrollViewDelegate = self
    }
    
    override func loadMore() {
        
    }
    
    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        
    }
    
    override func getScrollView() -> UIScrollView? {
        return collectionView
    }
    
    override func getTypeAction() -> AziBaseViewController.TypeAction {
        return .None
    }
    
}

//MARK: ListAdapterDataSource
extension AccountViewController: ListAdapterDataSource {
    
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
extension AccountViewController: IGListAdapterDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        if dataSource.count < 1 { return }
        if index >= dataSource.count - 1 && !isFetchingMore {
            loadMore()
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
    
}
extension AccountViewController: SearchNavigationViewDelegate {
    func clickSearch() {
        let vcOld = self
        let vc = SearchSongYoutubeViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false) {
            vcOld.nav.hiddenBtnCancel()
        }
    }
    
    func clickDismiss() {
        
    }
    
}

@IBDesignable
class WavyView: UIView {

    private weak var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    private let maxAmplitude: CGFloat = 0.1
    private let maxTidalVariation: CGFloat = 0.1
    private let amplitudeOffset = CGFloat.random(in: -0.2 ... 0.8)
    private let amplitudeChangeSpeedFactor = CGFloat.random(in: 4 ... 8)

    private let defaultTidalHeight: CGFloat = 0.8
    private let saveSpeedFactor = CGFloat.random(in: 4 ... 8)

    private lazy var background: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.addSublayer(shapeLayer)
        return background
    }()

    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if newSuperview == nil {
            displayLink?.invalidate()
        }
   }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        shapeLayer.path = wave(at: 0)?.cgPath
    }
}


private extension WavyView {

    func configure() {
        addSubview(background)
        background.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)

        startDisplayLink()
        
        AppColor.shared.colorBackGround.subscribe(onNext: { [weak self] (hex) in
            UIView.animate(withDuration: 0.7) {
                self?.shapeLayer.strokeColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1).cgColor
                self?.shapeLayer.fillColor = UIColor.hexStringToUIColor(hex: hex, alpha: 1).cgColor
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: rx.disposeBag)

    }

    func wave(at elapsed: Double) -> UIBezierPath? {
        guard bounds.width > 0, bounds.height > 0 else { return nil }

        func f(_ x: CGFloat) -> CGFloat {
            let elapsed = CGFloat(elapsed)
            let amplitude = maxAmplitude * abs(fmod(elapsed / 2, 3) - 1.5)
            let variation = sin((elapsed + amplitudeOffset) / amplitudeChangeSpeedFactor) * maxTidalVariation
            let value = sin((elapsed / saveSpeedFactor + x) * 4 * .pi)
            return value * amplitude / 2 * bounds.height + (defaultTidalHeight + variation) * bounds.height
        }

        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))

        let count = Int(bounds.width / 10)

        for step in 0 ... count {
            let dataPoint = CGFloat(step) / CGFloat(count)
            let x = dataPoint * bounds.width + bounds.minX
            let y = bounds.maxY - f(dataPoint)
            let point = CGPoint(x: x, y: y)
            path.addLine(to: point)
        }
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.close()
        return path
    }

    func startDisplayLink() {
        startTime = CACurrentMediaTime()
        displayLink?.invalidate()
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }

    func stopDisplayLink() {
        displayLink?.invalidate()
    }

    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CACurrentMediaTime() - startTime
        shapeLayer.path = wave(at: elapsed)?.cgPath
    }
}
