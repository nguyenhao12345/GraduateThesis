//
//  ExtensionCollection.swift
//  Tiki_Presenter
//
//  Created by Nguyen Hieu on 13/09/2018.
//  Copyright © 2018 com.nguyenhieu.demo. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
   
    class func loadPhotoFromService(url: String, completion: @escaping (UIImage) -> ())  {
       
        
        guard let link = URL(string: url) else {return}
        
        //Chưa đa luồng
//        guard let data = try? Data(contentsOf: link) else {return}
//        guard let image = UIImage(data: data) else {return}
//        self.image = image
//
        // cho vào luồng mới(quequeLoadHinh), chạy xong r đưa về mainqueque
        //let dispatchQueue = DispatchQueue(label: "quequeLoadHinh")
        //dispatchQueue.async {
        
            URLSession.shared.dataTask(with: link, completionHandler: { (data, res, err) in

                DispatchQueue.main.async {
                     guard let data = data, let image = UIImage(data: data) else {return}
                   
                    completion(image)
                }
            }).resume()
               // try? Data(contentsOf: link) else {return}
        //}
    }
}
extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}
extension UIImage {
    func getHeight() {
    	
    }
}


extension NSObject {
    public class var className:String {
        get {
            return NSStringFromClass(self).components(separatedBy: ".").last!
        }
    }
 
}

protocol StoryboardInstatiable {}

func instantiate<T: StoryboardInstatiable>(_: T.Type) -> T where T: NSObject {
    let storyboard = UIStoryboard(name: T.className, bundle: nil)
    return storyboard.instantiateInitialViewController() as! T
}

func instantiate<T: StoryboardInstatiable>(_: T.Type, storyboard: String) -> T where T: NSObject {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: T.className) as! T
}

extension UIViewController: StoryboardInstatiable {}



protocol NibInstantiable {}

func instantiateFromNib<T: NibInstantiable, U: Any>(_: T.Type, owner: U) -> T where T: NSObject {
    return UINib(nibName: T.className, bundle: nil).instantiate(withOwner: owner, options: nil)[0] as! T
}

func instantiateFromNib<T: Any>(identifier: String, owner: T) -> UIView {
    return UINib(nibName: identifier, bundle: nil).instantiate(withOwner: owner, options: nil)[0] as! UIView
}
extension UIView: NibInstantiable {}

func delay(sec:Double, handler:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + sec, execute:handler)
}


extension UICollectionView {
    func dequeueReusableCellWithType<T: UICollectionViewCell>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
    func registerNibForCellWithType<T: UICollectionViewCell>(type:T.Type){
        let className = type.className
        let nib = UINib(nibName: type.className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
}
extension UITableView {
    func dequeueReusableCellWithType<T: UITableViewCell>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    func registerNibForCellWithType<T: UITableViewCell>(type:T.Type){
        let className = type.className
        let nib = UINib(nibName: type.className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
}

extension UIViewController {
    func chuyenManHinh(nameStoryboard:String,idStoryboard:String) {
        let storyboard = UIStoryboard(name: nameStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: idStoryboard)
        present(vc, animated: true, completion: nil)
    }
}
extension UIColor {
    class func hexStringToUIColor (hex:String,alpha: Float) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
