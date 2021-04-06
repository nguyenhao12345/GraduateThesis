//
//  ChangeColorAppViewController.swift
//  Piano_App
//
//  Created by Azibai on 24/03/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import IGListKit

protocol ChangeColorAppDelegate: class {
    func updateColor(hex: String)
}
class ChangeColorAppViewController: AziBaseViewController {
    weak var delegate: ChangeColorAppDelegate?
    //MARK: Outlets
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var viewMess: UIView!
    
    @IBAction func clickView1(_ sender: Any?) {
        delegate?.updateColor(hex: view1.backgroundColor?.hexString ?? "")
        clickBack(nil)
    }
    
    @IBAction func clickView2(_ sender: Any?) {
        delegate?.updateColor(hex: view2.backgroundColor?.hexString ?? "")
        clickBack(nil)
    }
    
    @IBAction func clickView3(_ sender: Any?) {
        delegate?.updateColor(hex: view3.backgroundColor?.hexString ?? "")
        clickBack(nil)
    }
    
    @IBAction func clickView4(_ sender: Any?) {
        delegate?.updateColor(hex: view4.backgroundColor?.hexString ?? "")
        clickBack(nil)
    }
    
    @IBAction func clickView5(_ sender: Any?) {
        delegate?.updateColor(hex: view5.backgroundColor?.hexString ?? "")
        clickBack(nil)
    }
    
    @IBAction func clickBack(_ sender: Any?) {
        self.viewMess.transform = .identity
        UIView.animate(withDuration: 0.2, animations: {
            self.viewMess.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }

    }
    
    //MARK: Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    override func initUIVariable() {
//        super.initUIVariable()
////        self.allowAutoPlay = true
//        self.hidesNavigationbar = true
////        self.hidesToolbar = true
////        self.addPansGesture = true
////        self.colorStatusBar = .black
//    }
//
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewIsReady()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        viewMess.transform =
        self.viewMess.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.2, animations: {
            self.viewMess.transform = .identity
        })
    }
    
    //MARK: Method
    func viewIsReady() {
        view1.backgroundColor = UIColor(hexString: AppColor.shared.arrColor[0])
        view2.backgroundColor = UIColor(hexString: AppColor.shared.arrColor[1])
        view3.backgroundColor = UIColor(hexString: AppColor.shared.arrColor[2])
        view4.backgroundColor = UIColor(hexString: AppColor.shared.arrColor[3])
        view5.backgroundColor = UIColor(hexString: AppColor.shared.arrColor[4])
        
//        for i in
//        if
    }
}
