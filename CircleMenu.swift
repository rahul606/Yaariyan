//
//  CircleMenu.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 28/03/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.

import UIKit

// MARK: helpers


public func Init<Type>(_ value: Type, block: (_ object: Type) -> Void) -> Type {
    block(value)
    return value
}

// MARK: Protocol

@objc public protocol CircleMenuDelegate {
    
    // don't change button.tag
    @objc optional func circleMenu(_ circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int)
    
    // call before animation
    @objc optional func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int)
    
    // call after animation
    @objc optional func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int)
}

// MARK: CircleMenu
open class CircleMenu: UIButton {
    
    // MARK: properties
    
    @IBInspectable open var buttonsCount: Int = 3
    @IBInspectable open var duration: Double  = 2 // circle animation duration
    @IBInspectable open var distance: Float   = 100 // distance between center button and buttons
    @IBInspectable open var showDelay: Double = 0 // delay between show buttons
    
    
    @IBOutlet weak open var delegate: CircleMenuDelegate?
    
    var buttons: [CircleMenuButton]?
    
    fileprivate var customNormalIconView: UIImageView!
    fileprivate var customSelectedIconView: UIImageView!
    
    // MARK: life cycle
    public init(frame: CGRect, normalIcon: String?, selectedIcon: String?, buttonsCount: Int = 3, duration: Double = 2,
        distance: Float = 100) {
            super.init(frame: frame)
            
            if let icon = normalIcon {
                setImage(UIImage(named: icon), for: UIControlState())
            }
            
            if let icon = selectedIcon {
                setImage(UIImage(named: icon), for: .selected)
            }
            
            self.buttonsCount = buttonsCount
            self.duration     = duration
            self.distance     = distance
            
            commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    fileprivate func commonInit() {
        addActions()
        
        customNormalIconView = addCustomImageView(state: UIControlState())
        
        customSelectedIconView = addCustomImageView(state: .selected)
        if customSelectedIconView != nil {
            customSelectedIconView.alpha = 0
        }
        setImage(UIImage(), for: UIControlState())
        setImage(UIImage(), for: .selected)
    }
    
    // MARK: create
    
    fileprivate func createButtons() -> [CircleMenuButton] {
        var buttons = [CircleMenuButton]()
        
        let step: Float = 360.0 / Float(self.buttonsCount)
        for index in 0..<self.buttonsCount {
            
            let angle: Float = Float(index) * step
            let distance = Float(self.bounds.size.height/2.0)
            let button = Init(CircleMenuButton(size: self.bounds.size, circleMenu: self, distance:distance, angle: angle)) {
                $0.tag = index
                $0.addTarget(self, action: #selector(CircleMenu.buttonHandler(_:)), for: UIControlEvents.touchUpInside)
                $0.alpha = 0
            }
            buttons.append(button)
        }
        return buttons
    }
    
    fileprivate func addCustomImageView(state: UIControlState) -> UIImageView? {
        guard let image = image(for: state) else {
            return nil
        }
        
        let iconView = Init(UIImageView(image: image)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode                               = .center
            $0.isUserInteractionEnabled                    = false
        }
        addSubview(iconView)
        
        // added constraints
        iconView.addConstraint(NSLayoutConstraint(item: iconView, attribute: .height, relatedBy: .equal, toItem: nil,
            attribute: .height, multiplier: 1, constant: bounds.size.height))
        
        iconView.addConstraint(NSLayoutConstraint(item: iconView, attribute: .width, relatedBy: .equal, toItem: nil,
            attribute: .width, multiplier: 1, constant: bounds.size.width))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: iconView,
            attribute: .centerX, multiplier: 1, constant:0))
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: iconView,
            attribute: .centerY, multiplier: 1, constant:0))
        
        return iconView
    }
    
    // MARK: configure
    
    fileprivate func addActions() {
        self.addTarget(self, action: #selector(CircleMenu.onTap), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: helpers
    
    open func buttonsIsShown() -> Bool {
        guard let buttons = self.buttons else {
            return false
        }
        
        for button in buttons {
            if button.alpha == 0 {
                return false
            }
        }
        return true
    }
    
    // MARK: actions
    
    func onTap() {
        if buttonsIsShown() == false {
            buttons = createButtons()
        }
        let isShow = !buttonsIsShown()
        let duration  = isShow ? 0.5 : 0.2
        buttonsAnimationIsShow(isShow: isShow, duration: duration)
        
        tapBounceAnimation()
        tapRotatedAnimation(0.3, isSelected: isShow)
    }
    
    func buttonHandler(_ sender: CircleMenuButton) {
        delegate?.circleMenu?(self, buttonWillSelected: sender, atIndex: sender.tag)
        
        let circle = CircleMenuLoader(radius: CGFloat(distance), strokeWidth: bounds.size.height, circleMenu: self,
            color: sender.backgroundColor)
        
        if let container = sender.container { // rotation animation
            sender.rotationLayerAnimation(container.angleZ + 360, duration: duration)
            container.superview?.bringSubview(toFront: container)
        }
        
        if let aButtons = buttons {
            circle.fillAnimation(duration, startAngle: -90 + Float(360 / aButtons.count) * Float(sender.tag))
            circle.hideAnimation(0.5, delay: duration)
            
            hideCenterButton(duration: 0.3)
            
            buttonsAnimationIsShow(isShow: false, duration: 0, hideDelay: duration)
            showCenterButton(duration: 0.525, delay: duration)
            
            if customNormalIconView != nil && customSelectedIconView != nil {
                let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(duration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                    self.delegate?.circleMenu?(self, buttonDidSelected: sender, atIndex: sender.tag)
                })
            }
        }
    }
    
    // MARK: animations
    
    fileprivate func buttonsAnimationIsShow(isShow: Bool, duration: Double, hideDelay: Double = 0) {
        guard let buttons = self.buttons else {
            return
        }
        
        let step: Float = 360.0 / Float(self.buttonsCount)
        for index in 0..<self.buttonsCount {
            let button       = buttons[index]
            let angle: Float = Float(index) * step
            if isShow == true {
                delegate?.circleMenu?(self, willDisplay: button, atIndex: index)
                
                button.rotatedZ(angle: angle, animated: false, delay: Double(index) * showDelay)
                button.showAnimation(distance: distance, duration: duration, delay: Double(index) * showDelay)
            } else {
                button.hideAnimation(
                    distance: Float(self.bounds.size.height / 2.0),
                    duration: duration, delay: hideDelay)
            }
        }
        if isShow == false { // hide buttons and remove
            self.buttons = nil
        }
    }
    
    fileprivate func tapBounceAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5,
            options: UIViewAnimationOptions.curveLinear,
            animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
            completion: nil)
    }
    
    fileprivate func tapRotatedAnimation(_ duration: Float, isSelected: Bool) {
        
        let addAnimations: (_ view: UIImageView, _ isShow: Bool) -> () = { (view, isShow) in
            var toAngle: Float   = 180.0
            var fromAngle: Float = 0
            var fromScale        = 1.0
            var toScale          = 0.2
            var fromOpacity      = 1
            var toOpacity        = 0
            if isShow == true {
                toAngle     = 0
                fromAngle   = -180
                fromScale   = 0.2
                toScale     = 1.0
                fromOpacity = 0
                toOpacity   = 1
            }
            
            let rotation = Init(CABasicAnimation(keyPath: "transform.rotation")) {
                $0.duration       = TimeInterval(duration)
                $0.toValue        = (toAngle.degrees)
                $0.fromValue      = (fromAngle.degrees)
                $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            }
            let fade = Init(CABasicAnimation(keyPath: "opacity")) {
                $0.duration            = TimeInterval(duration)
                $0.fromValue           = fromOpacity
                $0.toValue             = toOpacity
                $0.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                $0.fillMode            = kCAFillModeForwards
                $0.isRemovedOnCompletion = false
            }
            let scale = Init(CABasicAnimation(keyPath: "transform.scale")) {
                $0.duration       = TimeInterval(duration)
                $0.toValue        = toScale
                $0.fromValue      = fromScale
                $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            }
            
            view.layer.add(rotation, forKey: nil)
            view.layer.add(fade, forKey: nil)
            view.layer.add(scale, forKey: nil)
        }
        
        if customNormalIconView != nil && customSelectedIconView != nil {
            addAnimations(customNormalIconView, !isSelected)
            addAnimations(customSelectedIconView, isSelected)
        }
        //isSelected = isSelected
        self.alpha = isSelected ? 0.3 : 1
    }
    
    fileprivate func hideCenterButton(duration: Double, delay: Double = 0) {
        UIView.animate( withDuration: TimeInterval(duration), delay: TimeInterval(delay),
            options: UIViewAnimationOptions.curveEaseOut,
            animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }, completion: nil)
    }
    
    fileprivate func showCenterButton(duration: Float, delay: Double) {
        UIView.animate( withDuration: TimeInterval(duration), delay: TimeInterval(delay), usingSpringWithDamping: 0.78,
            initialSpringVelocity: 0, options: UIViewAnimationOptions.curveLinear,
            animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.alpha     = 1
            },
            completion: nil)
        
        let rotation = Init(CASpringAnimation(keyPath: "transform.rotation")) {
            $0.duration        = TimeInterval(1.5)
            $0.toValue         = (0)
            $0.fromValue       = (Float(-180).degrees)
            $0.damping         = 10
            $0.initialVelocity = 0
            $0.beginTime       = CACurrentMediaTime() + delay
        }
        let fade = Init(CABasicAnimation(keyPath: "opacity")) {
            $0.duration            = TimeInterval(0.01)
            $0.toValue             = 0
            $0.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            $0.fillMode            = kCAFillModeForwards
            $0.isRemovedOnCompletion = false
            $0.beginTime           = CACurrentMediaTime() + delay
        }
        let show = Init(CABasicAnimation(keyPath: "opacity")) {
            $0.duration            = TimeInterval(duration)
            $0.toValue             = 1
            $0.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            $0.fillMode            = kCAFillModeForwards
            $0.isRemovedOnCompletion = false
            $0.beginTime           = CACurrentMediaTime() + delay
        }
        
        if customNormalIconView != nil {
            customNormalIconView.layer.add(rotation, forKey: nil)
            customNormalIconView.layer.add(show, forKey: nil)
        }
        
        if customSelectedIconView != nil {
            customSelectedIconView.layer.add(fade, forKey: nil)
        }
    }
}

// MARK: extension

extension Float {
    var radians: Float {
        return self * (Float(180) / Float(M_PI))
    }
    
    var degrees: Float {
        return self  * Float(M_PI) / 180.0
    }
}

extension UIView {
    
    var angleZ: Float {
        let radians: Float = atan2(Float(self.transform.b), Float(self.transform.a))
        return radians.radians
    }
}
