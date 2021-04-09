//
//  AppRouter.swift
//  Piano_App
//
//  Created by Azibai on 06/04/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import YoutubeKit
import IQKeyboardManagerSwift

class AppRouter: NSObject {
    static let shared = AppRouter()
    
    func gotoPianoPractice(viewController: UIViewController?) {
        if #available(iOS 13.0, *) {
            let vc = PianoPracticeViewController()
            isDarkSoftUIView = true
            vc.modalPresentationStyle = .overFullScreen
            viewController?.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }

    }
    
    func gotoChangeColor(viewController: UIViewController?, delegate: ChangeColorAppDelegate?) {
        let vc = ChangeColorAppViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = delegate
        viewController?.present(vc, animated: false, completion: nil)
    }
    
    func gotoLogin(viewController: UIViewController) {
        let vc = AuthenticateViewController()
        vc.modalPresentationStyle = .overFullScreen
        viewController.present(vc, animated: true, completion: nil)
    }
    
    func gotoSearchSongYoutube(viewController: UIViewController) {
        let vc = SearchSongYoutubeViewController()
        present(viewController: viewController, toViewController: vc, animation: true)
    }
    
    func gotoInfoUser(uidUser: String, viewController: UIViewController) {
        let vc = InfoUserViewController()
        vc.uidUser = uidUser
        present(viewController: viewController, toViewController: vc, animation: true)
    }
    
    func gotoEditInfoUser(uidUser: String, viewController: UIViewController) {
        let vc = InfoUserViewController()
        vc.uidUser = uidUser
        vc.isEdit = true
        present(viewController: viewController, toViewController: vc, animation: true)
    }

    func gotoResetPassWord(viewController: UIViewController) {
        let vc = ResetPasswdViewController()
        present(viewController: viewController, toViewController: vc, animation: true)
    }
    
    func gotoLocalSongs(viewController: UIViewController) {
        let vc = LocalSongsViewController()
        present(viewController: viewController, toViewController: vc, animation: true)
    }
    
    func gotoUserWall(uidUSer: String, viewController: UIViewController) {
        let vc = UserWallViewController(uidUser: uidUSer)
        present(viewController: viewController, toViewController: vc, animation: true)
    }
    
    func gotoNewsFeedDetail(newsModel: NewsFeedModel?, viewController: UIViewController) {
        ManagerModernAVPlayer.shared.stop()
        if #available(iOS 13.0, *) {
            let vc = DetailNewsFeedViewController(newsModel: newsModel)
            present(viewController: viewController, toViewController: vc, animation: true)
        } else {
            // Fallback on earlier versions
        }
      }
    
    func gotoDetailMusic(id: String, viewController: UIViewController, frameAnimation: CGRect? = nil, viewAnimation: UIView? = nil, dataModel: DetailInfoSong? = nil) {
        ManagerModernAVPlayer.shared.stop()

        let vc = DetailSongViewController()
        vc.keyIdDetail = id
        vc.dataModel = dataModel
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        vc.isHeroEnabled = true
        vc.addPansGesture = true
        vc.heroModalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))

        
        if frameAnimation == nil {
            viewController.present(vc, animated: true, completion: nil)
            return
        }
        
        
        
        let currentFrameAnimation = CGRect(x: 12, y: UIApplication.shared.statusBarFrame.height, width: Const.widthScreens-24, height: Const.widthScreens*3/4)
        if let img = viewAnimation as? UIImageView {
            guard let window = UIApplication.shared.keyWindow else { return }
            let viewContainer = UIView(frame: window.frame)
            window.addSubview(viewContainer)
            
            viewController.view.isUserInteractionEnabled = false
            
            vc.imageMusic = img.image
            vc.oldFrameAnimation = frameAnimation
            vc.currentFrameAnimation = currentFrameAnimation
            let imageView = UIImageView(frame: frameAnimation ?? CGRect())
            imageView.image = img.image
            imageView.contentMode = .scaleAspectFill
            viewContainer.addSubview(imageView)
            viewAnimation?.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                imageView.frame = currentFrameAnimation
                imageView.cornerRadius = 12
                imageView.layoutIfNeeded() // add this
            }) { _ in
                viewController.present(vc, animated: false) {
                    viewController.view.isUserInteractionEnabled = true
                    viewAnimation?.alpha = 1
                    viewContainer.removeFromSuperview()
                }
            }

        }

        
    }
    
    func dismissAnimation(currentFrame: CGRect, oldFrame: CGRect, image: UIImage, viewController: UIViewController) {
        ManagerModernAVPlayer.shared.stop()

        guard let window = UIApplication.shared.keyWindow else { return }
        let viewContainer = UIView(frame: window.frame)
        window.addSubview(viewContainer)
        
        viewController.view.isUserInteractionEnabled = false

        
        let imageView = UIImageView(frame: currentFrame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        viewContainer.addSubview(imageView)
        viewContainer.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, animations: {
            imageView.frame = oldFrame
            imageView.cornerRadius = 8
            viewContainer.backgroundColor = UIColor(hexString: AppColor.shared.colorBackGround.value)
            imageView.layoutIfNeeded() // add this
        }) { _ in
            viewController.dismiss(animated: false) {
                viewController.view.isUserInteractionEnabled = true
                viewContainer.removeFromSuperview()
            }
        }

    }
    
    func gotoPlayMusic(id: String, viewController: UIViewController) {
        
    }
    
    private func present(viewController: UIViewController, toViewController: AziBaseViewController, animation: Bool, completion: (() -> Void)? = nil) {
        ManagerModernAVPlayer.shared.stop()
        toViewController.modalTransitionStyle = .crossDissolve
        toViewController.modalPresentationStyle = .fullScreen
        toViewController.isHeroEnabled = true
        toViewController.addPansGesture = true
        toViewController.heroModalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .uncover(direction: .right))
        viewController.present(toViewController, animated: animation, completion: completion)
    }

}

