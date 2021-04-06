//
//  CustomSegmentedControl.swift
//  Piano_App
//
//  Created by Nguyen Hieu on 3/11/19.
//  Copyright © 2019 com.nguyenhieu.demo. All rights reserved.
//

import UIKit
@IBDesignable

class CustomSegmentedControl: UIControl {
    var buttons = [UIButton]()
    var selector: UIView!
    var selectorSegmentIndex = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    @IBInspectable
//    var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    @IBInspectable
//    var borderColor: UIColor = UIColor.clear {
//        didSet {
//            layer.borderColor = borderColor.cgColor
//        }
//    }
//    
    @IBInspectable
    var commaSeparatedButtonTitles: String = "" {
        didSet {
            updataView()
        }
    }
    @IBInspectable
    var textColor: UIColor = UIColor.lightGray {
        didSet {
            updataView()
        }
    }
    @IBInspectable
    var selectorColor: UIColor = UIColor.darkGray {
        didSet {
            updataView()
        }
    }
    @IBInspectable
    var selectorTextColor: UIColor = .white {
        didSet {
            updataView()
        }
    }
    func updataView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        
        let selectorWidth = self.frame.width / CGFloat(buttonTitles.count)
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: self.frame.height))
        selector.layer.cornerRadius = self.frame.height / 2
        selector.backgroundColor = selectorColor
        addSubview(selector)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    @objc func buttonTapped(button: UIButton) {
        
        for (buttonIndex,btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            
            if btn == button {
                selectorSegmentIndex = buttonIndex
                sendActions(for: .valueChanged)
                let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selector.frame.origin.x = selectorStartPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height/2
    }

}
class ViewRound: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
    }
}

public class BaseView: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }
    
    func getNibName() -> String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
    
    func load() {
        let bundle = Bundle.init(for:BaseView.self)
        let nib = UINib(nibName: getNibName(), bundle: bundle)
        let views = nib.instantiate(withOwner: self, options: nil)
        if let childView = views[0] as? UIView {
            addViewOverlay(childView: childView, toView: self)
            loadingViewComplete(childView: childView)
        }
    }
    
    func loadingViewComplete(childView: UIView) {
        
    }
    func addViewOverlay(childView: UIView, toView parentView: UIView) {
        parentView.addSubview(childView)
        // Use bounds not frame or it'll be offset
        if frame == CGRect.zero {
            frame = childView.frame
        } else {
            childView.frame = bounds
        }
        BaseView.addConstrainOverlay(childView: childView, toView: parentView)
    }
    static func addConstrainOverlay(childView: UIView, toView parentView: UIView) {
        
        childView.bounds = parentView.bounds // use for non auto layout project.
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXConstraint = NSLayoutConstraint(item: childView,
                                                   attribute: NSLayoutConstraint.Attribute.centerX,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: parentView,
                                                   attribute: NSLayoutConstraint.Attribute.centerX,
                                                   multiplier: 1, constant: 0)
        
        let centerYConstraint = NSLayoutConstraint(item: childView,
                                                   attribute: NSLayoutConstraint.Attribute.centerY,
                                                   relatedBy: NSLayoutConstraint.Relation.equal,
                                                   toItem: parentView,
                                                   attribute: NSLayoutConstraint.Attribute.centerY,
                                                   multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: childView,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  relatedBy: NSLayoutConstraint.Relation.equal,
                                                  toItem: parentView,
                                                  attribute: NSLayoutConstraint.Attribute.height,
                                                  multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: childView,
                                                 attribute: NSLayoutConstraint.Attribute.width,
                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                 toItem: parentView,
                                                 attribute: NSLayoutConstraint.Attribute.width,
                                                 multiplier: 1, constant: 0)
        
        parentView.addConstraints([centerXConstraint, centerYConstraint, heightConstraint, widthConstraint])
    }
}
