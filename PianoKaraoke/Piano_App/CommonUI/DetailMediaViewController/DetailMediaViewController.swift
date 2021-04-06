

import UIKit
import IGListKit

class DetailMediaViewController: AziBaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnDissmiss: UIButton!
    
    //MARK: Properties
    let areaDevice = (UIScreen.main.bounds.width*UIScreen.main.bounds.height)
    var originalImageCenter: CGPoint?
    var media: MediaModel?
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
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
    }
    
    //MARK: Method
    func viewIsReady() {
        imageView.setImageURL(URL(string: media?.urlImage ?? ""))
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGest)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanDismis(recognizer:)))
        pan.delegate = self
        pan.maximumNumberOfTouches = 1
        view.addGestureRecognizer(pan)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    override func getScrollView() -> UIScrollView? {
        return scrollView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale == 1 {
            btnDissmiss.isHidden = false
        } else {
            btnDissmiss.isHidden = true
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    @objc func handlePanDismis(recognizer: UIPanGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            guard let imageView = imageView else { return }
            switch recognizer.state {
            case .began:
                btnDissmiss.isHidden = true
                scrollView.isUserInteractionEnabled = false
                imageView.isUserInteractionEnabled = false
                originalImageCenter = imageView.center
            case .changed:
                let translation = recognizer.translation(in: view)
                let newX: CGFloat = imageView.center.x + translation.x
                let newY: CGFloat = imageView.center.y + translation.y
                imageView.center = CGPoint(x: newX, y: newY)
                recognizer.setTranslation(CGPoint.zero, in: view)
                
                let frameGlobal = self.imageView.globalFrame
                let w = (frameGlobal?.width ?? 0) - abs(frameGlobal?.origin.x ?? 0)
                let h = (frameGlobal?.height ?? 0) - abs(frameGlobal?.origin.y ?? 0)
                view.alpha = (w*h)/areaDevice
            case .ended:
                dismissAfterPan()
            default:
                break
            }
        }
    }
    
    func dismissAfterPan() {
        scrollView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
        let frameGlobal = self.imageView.globalFrame
        let w = (frameGlobal?.width ?? 0) - abs(frameGlobal?.origin.x ?? 0)
        let h = (frameGlobal?.height ?? 0) - abs(frameGlobal?.origin.y ?? 0)
        
        if (w*h)/areaDevice <= 0.5 {
            self.backScreen()
        } else {
            btnDissmiss.isHidden = false
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self = self else { return }
                self.imageView.center = self.originalImageCenter ?? CGPoint()
                self.imageView.transform = CGAffineTransform.identity
                self.view.alpha = 1
            })
        }
    }
    
    
    @IBAction func clickDissmiss(_ sender: Any?) {
        self.backScreen()
    }
    
    func backScreen() {
        CustomAVPlayer.globalPlayer?.deactive()
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: false)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

extension DetailMediaViewController {
    class func gotoMe(with viewController: UIViewController?, media: MediaModel?) {
        let vc = DetailMediaViewController()
        vc.media = media
        vc.modalPresentationStyle = .overFullScreen
        viewController?.present(vc, animated: true, completion: nil)
    }
}
