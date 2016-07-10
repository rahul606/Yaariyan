//
//  MainViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 12/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

extension UIColor {
    static func color(red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
}

class MainViewController: UIViewController, CircleMenuDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {

    let customNavigationAnimationController = CustomNavigationAnimationController()
    let customInteractionController = CustomInteractionController()
    
    let items: [(icon: String, color: UIColor)] = [
        ("icon_music", UIColor.color(48, green:107, blue:255, alpha:1)),
        ("icon_radio", UIColor.color(41, green:183, blue:188, alpha:1)),
        ("icon_analytics", UIColor.color(237, green:91, blue:42, alpha:1)),
        ("music-icon", UIColor.color(3, green:157, blue:129, alpha:1)),
        ("icon_movie", UIColor.color(253, green:192, blue:15, alpha:1)),
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.barTintColor=UIColor.color(182, green: 193, blue: 45, alpha: 1)
        navigationController?.delegate = self
        
        if Reachability.isConnectedToNetwork() == false {
            let alertController = Reachability.showAlert()
            presentViewController(alertController, animated: true, completion: nil);
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: <CircleMenuDelegate>
    
    func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(imageLiteral: items[atIndex].icon), forState: .Normal)
        
        // set highlited image
        let highlightedImage  = UIImage(imageLiteral: items[atIndex].icon).imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        if(atIndex == 0){
            //self.performSegueWithIdentifier("FindingFanny", sender: self)
        }
        if(atIndex == 1){
            self.performSegueWithIdentifier("RadioView", sender: self)
        }
        if(atIndex == 2){
            self.performSegueWithIdentifier("TwitterCelebrityView", sender: self)
        }
        if(atIndex == 3){
            //self.performSegueWithIdentifier("SpotifyView", sender: self)
        }
        if(atIndex == 4){
            self.performSegueWithIdentifier("MovieView", sender: self)
        }
        
        print("button did selected: \(atIndex)")
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push {
            customInteractionController.attachToViewController(toVC)
        }
        customNavigationAnimationController.reverse = operation == .Pop
        return customNavigationAnimationController
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }
}

