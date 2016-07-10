//
//  TwitterCelebrityViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 10/07/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

class TwitterCelebrityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var celebrityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        celebrityTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celebrity", forIndexPath: indexPath) as! TwitterCelebrityTableViewCell
        cell.leftBtn.layer.cornerRadius = 0.5 * cell.leftBtn.bounds.size.width
        cell.centreBtn.layer.cornerRadius = 0.5 * cell.centreBtn.bounds.size.width
        cell.rightBtn.layer.cornerRadius = 0.5 * cell.rightBtn.bounds.size.width
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
