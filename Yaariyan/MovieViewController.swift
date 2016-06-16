//
//  MovieViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 12/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var pickOfTheWeek: UIButton!
    @IBOutlet weak var comingNextWeek: UIButton!
    @IBOutlet weak var comingSoon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickOfTheWeek.layer.cornerRadius = 0.5 * pickOfTheWeek.bounds.size.width
        comingNextWeek.layer.cornerRadius = 0.5 * comingNextWeek.bounds.size.width
        comingSoon.layer.cornerRadius = 0.5 * comingSoon.bounds.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mtVc = segue.destinationViewController as! MovieTableViewController
        if segue.identifier == "PickOfTheWeek" {
            mtVc.whichCellPressed = 0
        }
        if segue.identifier == "ComingNextWeek" {
            mtVc.whichCellPressed = 1
        }
        if segue.identifier == "ComingSoon" {
            mtVc.whichCellPressed = 2
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if Reachability.isConnectedToNetwork() == false {
            let alertController = Reachability.showAlert()
            presentViewController(alertController, animated: true, completion: nil);
            return false
        } else {
            return true
        }
    }

}
