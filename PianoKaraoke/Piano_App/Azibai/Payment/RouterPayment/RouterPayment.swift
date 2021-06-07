//
//  File.swift
//  Piano_App
//
//  Created by Azibai on 19/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

extension AppRouter {
    
    func gotoPaymentFiterHistory(viewController: UIViewController, filter: PaymentFilterHistory, delegate: Any?) {
        let vc = PaymentFilterHistoryViewController()
        vc.filter = filter
        vc.delegate = delegate as? PaymentFilterHistoryViewControllerDelegate
        viewController.present(vc, withNavigation: false)
    }
    
    func gotoPaymentCURD(viewController: UIViewController, type: CURDPaymentAccountViewController.TYPE, walletModel: WalletModel? = nil) {
        let vc = CURDPaymentAccountViewController(wallet: walletModel)
        vc.type = type
        vc.delegate = viewController as? CURDPaymentAccountViewControllerDelegate
        viewController.present(vc, withNavigation: false)
    }
    
    func gotoPaymentWithDrawMoney(viewController: UIViewController) {
        print("gotoWithDrawMoney")
        
        let vc = WithDrawalMoneyViewController()
        viewController.present(vc, withNavigation: false)
    }
    
    func gotoPaymentTotalAvailableBalance(viewController: UIViewController) {
        print("gotoPaymentTotalAvailableBalance")
    }
    
    func gotoPaymentRevenueFromStores(viewController: UIViewController) {
        print("gotoPaymentRevenueFromStores")
    }
    
    func gotoPaymentFromPartnerAzibai(viewController: UIViewController) {
        print("gotoPaymentFromPartnerAzibai")
    }
    
    func gotoPaymentCollectedFromCollaborators(viewController: UIViewController) {
        print("gotoPaymentCollectedFromCollaborators")
    }
    
    func gotoPaymentCollectFromConsignment(viewController: UIViewController) {
        print("gotoPaymentCollectFromConsignment")
    }
}
