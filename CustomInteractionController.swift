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
    
    func attachToViewController(viewController: UIViewController) {
        navigationController = viewController
        setupGestureRecognizer(viewController.view)
    }
    
    private func setupGestureRecognizer(view: UIView) {
            view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(CustomInteractionController.handlePanGesture(_:))))
    }
    
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let viewTranslation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
        switch gestureRecognizer.state {
        case .Began:
            transitionInProgress = true
            navigationController.popoverPresentationController
        case .Changed:
            let const = CGFloat(fminf(fmaxf(Float(viewTranslation.x / 200.0), 0.0), 1.0))
            shouldCompleteTransition = const > 0.5
            updateInteractiveTransition(const)
        case .Cancelled, .Ended:
            transitionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .Cancelled {
                cancelInteractiveTransition()
            } else {
                finishInteractiveTransition()
            }
        default:
            print("Swift switch must be exhaustive, thus the default")
        }
    }
}
