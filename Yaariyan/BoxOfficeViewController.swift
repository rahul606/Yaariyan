//
//  BoxOfficeViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 16/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

private let numberOfCards: UInt = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BoxOfficeViewController: UIViewController {

    @IBOutlet weak var koladaView: CustomKolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = ["Top Rated Movies", "Top Grossed Movies", "Top Actors", "Top Actresses"]
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: items.first!, items: items)
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            
            items[indexPath]
        }
        
        koladaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        koladaView.countOfVisibleCards = kolodaCountOfVisibleCards
        koladaView.delegate = self
        koladaView.dataSource = self
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goHome(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: KolodaViewDelegate
extension BoxOfficeViewController: KolodaViewDelegate {
    func koloda(kolodaDidRunOutOfCards koloda: KolodaView) {
        
        koladaView.resetCurrentCardNumber()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
    }
    
    func koloda(kolodaShouldApplyAppearAnimation koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaShouldMoveBackgroundCard koloda: KolodaView) -> Bool {
        return false
    }
    
    func koloda(kolodaShouldTransparentizeNextCard koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

//MARK: KolodaViewDataSource
extension BoxOfficeViewController: KolodaViewDataSource {
    
    func koloda(kolodaNumberOfCards koloda: KolodaView) -> UInt {
        return numberOfCards
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}
