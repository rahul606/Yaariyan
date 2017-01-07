//
//  MainViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 12/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
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
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        self.navigationController?.navigationBar.barTintColor=UIColor.color(182, green: 193, blue: 45, alpha: 1)
        navigationController?.delegate = self
        
        if Reachability.isConnectedToNetwork() == false {
            let alertController = Reachability.showAlert()
            present(alertController, animated: true, completion: nil);
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: <CircleMenuDelegate>
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(imageLiteralResourceName: items[atIndex].icon), for: UIControlState())
        
        // set highlited image
        let highlightedImage  = UIImage(imageLiteralResourceName: items[atIndex].icon).withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: CircleMenuButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        if(atIndex == 0){
            //self.performSegueWithIdentifier("FindingFanny", sender: self)
        }
        if(atIndex == 1){
            self.performSegue(withIdentifier: "RadioView", sender: self)
        }
        if(atIndex == 2){
            //self.performSegue(withIdentifier: "TwitterCelebrityView", sender: self)
        }
        if(atIndex == 3){
            //self.performSegueWithIdentifier("SpotifyView", sender: self)
        }
        if(atIndex == 4){
            self.performSegue(withIdentifier: "MovieView", sender: self)
        }
        
        print("button did selected: \(atIndex)")
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            customInteractionController.attachToViewController(toVC)
        }
        customNavigationAnimationController.reverse = operation == .pop
        return customNavigationAnimationController
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteractionController.transitionInProgress ? customInteractionController : nil
    }
}

