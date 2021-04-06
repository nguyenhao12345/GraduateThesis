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
    var completionHandle: ((String) -> Void)? = nil
    //MARK: Properties
//    var titlePop: String = ""
    
    //MARK: Init
    
    class func showAlert(viewController: UIViewController?,
                         title: String,
                         dataSource: [String],
                         hightLight: String = "",
                         attributes: [NSAttributedString.Key : Any]? = nil, completion: ((String) -> Void)? = nil) {
        let vc = PopupIGViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.titlePop = title
        vc.dataSource.append(PopupIGSectionModel(dataModels: dataSource, attributes: attributes))
        vc.completionHandle = { value in
            vc.dismiss(animated: false) {
                DispatchQueue.main.async {
                    completion?(value)
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
