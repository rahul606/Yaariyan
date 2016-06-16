//
//  OverlayView.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 28/03/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

public enum OverlayMode{
    case None
    case Left
    case Right
}


public class OverlayView: UIView {
    
    public var overlayState:OverlayMode = OverlayMode.None

}
