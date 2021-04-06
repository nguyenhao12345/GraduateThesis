
//
//  SearchNavigationView.swift
//  Piano_App
//
//  Created by Azibai on 13/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchNavigationViewDelegate: class {
    func clickSearch()
    func clickDismiss()
}
public class SearchNavigationView: BaseView {

    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var backBtn: UIButton!

    func showBtnCancel(animation: Bool = false) {
        self.parentViewController?.view.isUserInteractionEnabled = false

        textSearch.isUserInteractionEnabled = true
        btn.isHidden = true

        containerView.layoutIfNeeded()
        self.containerView.dropShadow(color: .black, opacity: 0, offSet: CGSize(width: 1, height: 1), radius: 1, scale: true)

        self.rightConstraint.constant = 68
        self.leftConstraint.constant = 48
        self.backBtn.isHidden = false
        SearchNavigationView.animate(withDuration: animation ? 0.3: 0, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.parentViewController?.view.isUserInteractionEnabled = true
            self.delegate?.clickSearch()
        }
    }
    
    func hiddenBtnCancel(animation: Bool = false) {
        self.parentViewController?.view.isUserInteractionEnabled = false
        textSearch.isUserInteractionEnabled = false
        btn.isHidden = false
        self.rightConstraint.constant = 24
        self.leftConstraint.constant = 24
        self.backBtn.isHidden = true
        SearchNavigationView.animate(withDuration: animation ? 0.3: 0, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.parentViewController?.view.isUserInteractionEnabled = true
            self.containerView.layoutIfNeeded()
            self.containerView.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: 1, height: 1), radius: 6, scale: true)
            self.delegate?.clickDismiss()
        }
    }
    weak var delegate: SearchNavigationViewDelegate?
    @IBOutlet weak var containerView: ViewRound!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!

    @IBAction func clickSearch(_ sender: Any?) {
        showBtnCancel(animation: true)
    }
    
    @IBAction func clickDismiss(_ sender: Any?) {
        hiddenBtnCancel(animation: true)
    }
    
    @IBAction func clickCancel(_ sender: Any?) {
        textSearch.text = ""
        textSearch.sendActions(for: .valueChanged)
    }
}
