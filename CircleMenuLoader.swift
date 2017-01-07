//
//  CircleMenuLoader.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 28/03/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.

import Foundation
import UIKit

open class CircleMenuLoader: UIView {
    
    // MARK: properties
    
    var circle: CAShapeLayer?
    
    // MARK: life cycle
    
    public init(radius: CGFloat, strokeWidth: CGFloat, circleMenu: CircleMenu, color: UIColor?) {
        super.init(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
        
        if let aSuperView = circleMenu.superview {
            aSuperView.insertSubview(self, belowSubview: circleMenu)
        }
        
        circle = createCircle(radius, strokeWidth: strokeWidth, color: color)
        createConstraints(circleMenu, radius: radius)
        
        let circleFrame = CGRect(
            x: radius * 2 - strokeWidth,
            y: radius - strokeWidth / 2,
            width: strokeWidth,
            height: strokeWidth)
        createRoundView(circleFrame, color: color)
        
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: create
    
    fileprivate func createCircle(_ radius: CGFloat, strokeWidth: CGFloat, color: UIColor?) -> CAShapeLayer {
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: radius, y: radius),
            radius: CGFloat(radius) - strokeWidth / 2.0,
            startAngle: CGFloat(0),
            endAngle:CGFloat(M_PI * 2),
            clockwise: true)
        
        let circle = Init(CAShapeLayer()) {
            $0.path        = circlePath.cgPath
            $0.fillColor   = UIColor.clear.cgColor
            $0.strokeColor = color?.cgColor
            $0.lineWidth   = strokeWidth
        }
        
        self.layer.addSublayer(circle)
        return circle
    }
    
    fileprivate func createConstraints(_ circleMenu: CircleMenu, radius: CGFloat) {
        
        guard let circleMenuSuperView = circleMenu.superview else {
            fatalError()
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        // added constraints
        addConstraint(NSLayoutConstraint(item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: radius * 2.0))
        
        addConstraint(NSLayoutConstraint(item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .width,
            multiplier: 1,
            constant: radius * 2.0))
        
        circleMenuSuperView.addConstraint(NSLayoutConstraint(item: circleMenu,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1,
            constant:0))
        
        circleMenuSuperView.addConstraint(NSLayoutConstraint(item: circleMenu,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant:0))
    }
    
    fileprivate func createRoundView(_ rect: CGRect, color: UIColor?) {
        let roundView = Init(UIView(frame: rect)) {
            $0.backgroundColor = UIColor.black
            $0.layer.cornerRadius = rect.size.width / 2.0
            $0.backgroundColor = color
        }
        addSubview(roundView)
    }
    
    // MARK: animations
    
    open func fillAnimation(_ duration: Double, startAngle: Float) {
        guard circle != nil else {
            return
        }
        
        let rotateTransform = CATransform3DMakeRotation(CGFloat(startAngle.degrees), 0, 0, 1)
        layer.transform = rotateTransform
        
        let animation = Init(CABasicAnimation(keyPath: "strokeEnd")) {
            $0.duration       = CFTimeInterval(duration)
            $0.fromValue      = (0)
            $0.toValue        = (1)
            $0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        }
        circle?.add(animation, forKey: nil)
    }
    
    open func hideAnimation(_ duration: CGFloat, delay: Double) {
        
        let scale = Init(CABasicAnimation(keyPath: "transform.scale")) {
            $0.toValue             = 1.2
            $0.duration            = CFTimeInterval(duration)
            $0.fillMode            = kCAFillModeForwards
            $0.isRemovedOnCompletion = false
            $0.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            $0.beginTime           = CACurrentMediaTime() + delay
        }
        layer.add(scale, forKey: nil)
        
        UIView.animate(
            withDuration: CFTimeInterval(duration),
            delay: delay,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: { () -> Void in
                self.alpha = 0
            },
            completion: { (success) -> Void in
                self.removeFromSuperview()
        })
    }
}
