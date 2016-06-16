//
//  CustomOverlayView.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 28/03/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

private let overlayRightImageName = "overlay_like"
private let overlayLeftImageName = "overlay_skip"

class CustomOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState:OverlayMode  {
        didSet {
            switch overlayState {
            case .Left :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .Right :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
            
        }
    }
    
}
