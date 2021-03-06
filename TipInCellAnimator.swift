//
//  TipInCellAnimator.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 23/03/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit
import QuartzCore

let TipInCellAnimatorStartTransform:CATransform3D = {
    let rotationDegrees: CGFloat = -45.0
    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
    let offset = CGPoint(x: -20, y: -20)
    var startTransform = CATransform3DIdentity
    startTransform = CATransform3DRotate(CATransform3DIdentity,
                                         rotationRadians, 0.0, 0.0, 1.0)
    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0)
    
    return startTransform
}()

class TipInCellAnimator {
    class func animate(_ cell:UITableViewCell) {
        let view = cell.contentView
        
        view.layer.transform = TipInCellAnimatorStartTransform
        view.layer.opacity = 0.8
        
        UIView.animate(withDuration: 0.4, animations: {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }) 
    }
}
