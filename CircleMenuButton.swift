//
//  CircleMenuButton.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 28/03/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.

import UIKit

open class CircleMenuButton: UIButton {
    
    // MARK: properties
    
    open weak var container: UIView?
    
    // MARK: life cycle
    
    init(size: CGSize, circleMenu: CircleMenu, distance: Float, angle: Float = 0) {
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        self.backgroundColor = UIColor(colorLiteralRed: 0.79, green: 0.24, blue: 0.27, alpha: 1)
        self.layer.cornerRadius = size.height / 2.0
        
        let aContainer = createContainer(CGSize(width: size.width, height:CGFloat(distance)), circleMenu: circleMenu)
        
        // hack view for rotate
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        view.backgroundColor = UIColor.clear
        view.addSubview(self)
        //...
        
        aContainer.addSubview(view)
        container = aContainer
        
        view.layer.transform = CATransform3DMakeRotation(-CGFloat(angle.degrees), 0, 0, 1)
        
        self.rotatedZ(angle: angle, animated: false)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: configure
    
    fileprivate func createContainer(_ size: CGSize, circleMenu: CircleMenu) -> UIView {
        
        guard let circleMenuSuperView = circleMenu.superview else {
            fatalError("wront circle menu")
        }
        
        let container = Init(UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))) {
            $0.backgroundColor                           = UIColor.clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.anchorPoint                         = CGPoint(x: 0.5, y: 1)
        }
        circleMenuSuperView.insertSubview(container, belowSubview: circleMenu)
        
        // added constraints
        let height = NSLayoutConstraint(item: container,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: size.height)
        height.identifier = "height"
        container.addConstraint(height)
        
        container.addConstraint(NSLayoutConstraint(item: container,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: size.width))
        
        circleMenuSuperView.addConstraint(NSLayoutConstraint(item: circleMenu,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: container,
            attribute: .centerX,
            multiplier: 1,
            constant:0))
        
        circleMenuSuperView.addConstraint(NSLayoutConstraint(item: circleMenu,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: container,
            attribute: .centerY,
            multiplier: 1,
            constant:0))
        
        return container
    }
    
    // MARK: public
    
    open func rotatedZ(angle: Float, animated: Bool, duration: Double = 0, delay: Double = 0) {
        guard let container = self.container else {
            fatalError("contaner don't create")
        }
        
        let rotateTransform = CATransform3DMakeRotation(CGFloat(angle.degrees), 0, 0, 1)
        if animated {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: UIViewAnimationOptions(),
                animations: { () -> Void in
                    container.layer.transform = rotateTransform
                },
                completion: nil)
        } else {
            container.layer.transform = rotateTransform
        }
    }
}

// MARK: Animations

extension CircleMenuButton {
    
    public func showAnimation(distance: Float, duration: Double, delay: Double = 0) {
        
        guard let container = self.container else {
            fatalError()
        }
        
        let heightConstraint = self.container?.constraints.filter {$0.identifier == "height"}.first
        
        guard heightConstraint != nil else {
            return
        }
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.container?.layoutIfNeeded()
        
        self.alpha = 0
        
        heightConstraint?.constant = CGFloat(distance)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0,
            options: UIViewAnimationOptions.curveLinear,
            animations: { () -> Void in
                container.layoutIfNeeded()
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.alpha = 1
            }, completion: { (success) -> Void in
        })
    }
    
    public func hideAnimation(distance: Float, duration: Double, delay: Double = 0) {
        
        guard let container = self.container else {
            fatalError()
        }
        
        let heightConstraint = self.container?.constraints.filter {$0.identifier == "height"}.first
        
        guard heightConstraint != nil else {
            return
        }
        heightConstraint?.constant = CGFloat(distance)
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: { () -> Void in
                container.layoutIfNeeded()
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (success) -> Void in
                self.alpha = 0
                
                if let _ = self.container {
                    container.removeFromSuperview() // remove container
                }
        })
    }
    
    public func changeDistance(_ distance: CGFloat, animated: Bool, duration: Double = 0, delay: Double = 0) {
        
        guard let container = self.container else {
            fatalError()
        }
        
        let heightConstraint = self.container?.constraints.filter {$0.identifier == "height"}.first
        
        guard heightConstraint != nil else {
            return
        }
        
        heightConstraint?.constant = distance
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: { () -> Void in
                container.layoutIfNeeded()
            },
            completion: nil)
    }
    
    // MARK: layer animation
    
    public func rotationLayerAnimation(_ angle: Float, duration: Double) {
        if let aContainer = container {
            rotationLayerAnimation(aContainer, angle: angle, duration: duration)
        }
    }
}

extension UIView {
    
    public func rotationLayerAnimation(_ view: UIView, angle: Float, duration: Double) {
        
        let rotation = Init(CABasicAnimation(keyPath: "transform.rotation")) {
            $0.duration       = TimeInterval(duration)
            $0.toValue        = (angle.degrees)
            $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        view.layer.add(rotation, forKey: "rotation")
    }
}
