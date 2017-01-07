//
//  CustomInteractionController.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 28/03/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

class CustomInteractionController: UIPercentDrivenInteractiveTransition {
    var navigationController: UIViewController!
    var shouldCompleteTransition = false
    var transitionInProgress = false
    var completionSeed: CGFloat {
        return 1 - percentComplete
    }
    
    func attachToViewController(_ viewController: UIViewController) {
        navigationController = viewController
        setupGestureRecognizer(viewController.view)
    }
    
    fileprivate func setupGestureRecognizer(_ view: UIView) {
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CustomInteractionController.handlePanGesture(_:))))
    }
    
    func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let viewTranslation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        switch gestureRecognizer.state {
        case .began:
            transitionInProgress = true
            navigationController.popoverPresentationController
        case .changed:
            let const = CGFloat(fminf(fmaxf(Float(viewTranslation.x / 200.0), 0.0), 1.0))
            shouldCompleteTransition = const > 0.5
            update(const)
        case .cancelled, .ended:
            transitionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                cancel()
            } else {
                finish()
            }
        default:
            print("Swift switch must be exhaustive, thus the default")
        }
    }
}
