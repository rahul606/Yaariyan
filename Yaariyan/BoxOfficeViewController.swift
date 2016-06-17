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
    
    var imageArray: [NSString] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search()
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
    
    internal func search() {
        
        let url = NSURL(string: "https://api.cinemalytics.com/v1/analytics/TopMovies/?auth_token=ECF106431844CAF24373B15E1F181FCD")
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url!, completionHandler: {(url, response, error) in
            
            let data: NSData = NSData(contentsOfURL: url!)!
            let jsonArray = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSArray
            for counter in 0...jsonArray.count-1 {
                self.imageArray.append(jsonArray[counter]["PosterPath"] as! NSString)
            }
            if let error = error {
                print("error = \(error)")
            }
            
            if let response = response {
                print("response = \(response)")
            }
            
            self.koladaView.reloadData()
        })
        task.resume()
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
        if self.imageArray.count > 0{
            let a: Int = Int(index)
            let imageUrl = NSURL(string: self.imageArray[a] as String)
            let imageData = NSData(contentsOfURL: imageUrl!)
            return UIImageView(image: UIImage(data: imageData!))
        } else{
            return UIImageView(image: UIImage(named: ""))
        }
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("OverlayView",
                                                  owner: self, options: nil)[0] as? OverlayView
    }
}
