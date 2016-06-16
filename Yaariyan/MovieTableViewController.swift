//
//  MovieTableViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 15/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

class MovieTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var totalRowCount: NSInteger!
    var jsonArray: NSArray!
    var preventAnimation: Set<NSIndexPath>!
    var whichCellPressed: NSInteger!
    var url: NSURL!
    var imageCache: NSCache!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalRowCount = NSInteger()
        self.preventAnimation = Set<NSIndexPath>()
        imageCache = NSCache()
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        searchThisWeekMovies()
    }
    
    internal func searchThisWeekMovies() {
        
        if(whichCellPressed == 0) {
            url = NSURL(string: "https://api.cinemalytics.com/v1/movie/releasedthisweek?auth_token=ECF106431844CAF24373B15E1F181FCD")
        }
        if(whichCellPressed == 1) {
            url = NSURL(string: "https://api.cinemalytics.com/v1/movie/nextchange?auth_token=ECF106431844CAF24373B15E1F181FCD")
        }
        if(whichCellPressed == 2) {
            url = NSURL(string: "https://api.cinemalytics.com/v1/movie/upcoming?auth_token=ECF106431844CAF24373B15E1F181FCD")
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.downloadTaskWithURL(url!, completionHandler: {(url, response, error) in
            
            let data: NSData = NSData(contentsOfURL: url!)!
            let tempJsonArray = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSArray
            self.jsonArray = tempJsonArray.reverse()
            self.totalRowCount = self.jsonArray.count
            if let error = error {
                print("error = \(error)")
            }
            
            if let response = response {
                print("response = \(response)")
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return totalRowCount
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Card", forIndexPath: indexPath) as! MovieTableViewCell
        
        cell.reviewButton.hidden = true
        if whichCellPressed < 1 {
            cell.reviewButton.hidden = false
        }
        let posterUrlStr: NSString = self.jsonArray[indexPath.row]["PosterPath"] as! NSString
        let movieNameStr = self.jsonArray[indexPath.row]["Title"] as! String
        var movieDescriptionStr = self.jsonArray[indexPath.row]["Description"] as! String
        let movieGenre = self.jsonArray[indexPath.row]["Genre"] as! String
        let movieCensorRating = self.jsonArray[indexPath.row]["CensorRating"] as! String
        let movieReleaseDate = self.jsonArray[indexPath.row]["ReleaseDate"] as! String
        let youtubeLink = self.jsonArray[indexPath.row]["TrailerLink"] as! String
        
        let cellImageFromUrl = imageCache.objectForKey(posterUrlStr) as? UIImage
        if cellImageFromUrl == nil {
            cell.movieName.text = movieNameStr
            cell.movieImage.image = UIImage(named: "MovieLounge")
            cell.descriptionWindowTitle = movieNameStr
            
            let youtubeLinkArr = youtubeLink.characters.split{$0 == "="}.map(String.init) as NSArray
            if youtubeLinkArr.count > 1 {
                cell.youtubeButton.enabled = true
                cell.onYoutubeButtonTapped = {
                    let playerViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("PlayerView") as! YoutubeViewController
                    playerViewController.videoId = youtubeLinkArr[1] as! String
                    self.navigationController?.pushViewController(playerViewController, animated: true)
                }
            }
            else {
                cell.youtubeButton.enabled = false
            }
            let updatedMovieNameStr = removeSpecialCharsFromString(movieNameStr)
            let reviewUrlStr = "http://thereviewmonk.com/movie/" + updatedMovieNameStr.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/reviews/"
            cell.onReviewButtonTapped = {
                let reviewViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("ReviewView") as! ReviewViewController
                reviewViewController.reviewUrlStr = reviewUrlStr
                self.navigationController?.pushViewController(reviewViewController, animated: true)
            }
            cell.descriptionWindowDetails = movieDescriptionStr
            cell.imageLoadingActivity.startAnimating()
            let session = NSURLSession.sharedSession()
            let task = session.downloadTaskWithURL(url!, completionHandler: {(url, response, error) in
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    var imageUrl: NSURL!
                    var image: UIImage!
                    if (posterUrlStr != "" && (posterUrlStr.rangeOfString(".png").location != NSNotFound || posterUrlStr.rangeOfString(".jpg").location != NSNotFound)) {
                        imageUrl = NSURL(string: posterUrlStr as String)
                        let imageData = NSData(contentsOfURL: imageUrl!)
                        image = UIImage(data: imageData!)
                    }
                    else {
                        image = UIImage(named: "MovieLounge")
                    }
                    
                    if let error = error {
                        NSLog("error = \(error)", "Error while downloading image url")
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        let updateCell = self.tableView.cellForRowAtIndexPath(indexPath) as? MovieTableViewCell
                        if((updateCell) != nil){
                            updateCell?.imageLoadingActivity.stopAnimating()
                            updateCell?.imageLoadingActivity.hidesWhenStopped
                            let cellImageFromUrl = image
                            updateCell!.movieName.text = movieNameStr
                            updateCell!.movieImage.image = cellImageFromUrl
                            updateCell!.descriptionWindowTitle = movieNameStr
                            let fullMovieDescription = "Release Date : " + movieReleaseDate + "\r\n" +
                                "Genre : " + movieGenre + "\r\n" +
                                "Censor Rating : " + movieCensorRating + "\r\n" +
                            movieDescriptionStr
                            
                            movieDescriptionStr = fullMovieDescription
                            let youtubeLinkArr = youtubeLink.characters.split{$0 == "="}.map(String.init) as NSArray
                            if youtubeLinkArr.count > 1 {
                                updateCell!.youtubeButton.enabled = true
                                updateCell!.onYoutubeButtonTapped = {
                                    let playerViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("PlayerView") as! YoutubeViewController
                                    playerViewController.videoId = youtubeLinkArr[1] as! String
                                    self.navigationController?.pushViewController(playerViewController, animated: true)
                                }
                            }
                            else {
                                updateCell!.youtubeButton.enabled = false
                            }
                            updateCell!.descriptionWindowDetails = movieDescriptionStr
                            self.imageCache.setObject(cellImageFromUrl!, forKey: posterUrlStr)
                        }
                    })
                })
            })
            task.resume()
        }
        else {
            cell.movieName.text = movieNameStr
            cell.movieImage.image = cellImageFromUrl
            cell.descriptionWindowTitle = movieNameStr
            let fullMovieDescription = "Release Date : " + movieReleaseDate + "\r\n" +
                "Genre : " + movieGenre + "\r\n" +
                "Censor Rating : " + movieCensorRating + "\r\n" +
            movieDescriptionStr
            
            movieDescriptionStr = fullMovieDescription
            let youtubeLinkArr = youtubeLink.characters.split{$0 == "="}.map(String.init) as NSArray
            if youtubeLinkArr.count > 1 {
                cell.youtubeButton.enabled = true
                cell.onYoutubeButtonTapped = {
                    let playerViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("PlayerView") as! YoutubeViewController
                    playerViewController.videoId = youtubeLinkArr[1] as! String
                    self.navigationController?.pushViewController(playerViewController, animated: true)
                }
            }
            else {
                cell.youtubeButton.enabled = false
            }
            cell.descriptionWindowDetails = movieDescriptionStr
            
            let updatedMovieNameStr = removeSpecialCharsFromString(movieNameStr)
            let reviewUrlStr = "http://thereviewmonk.com/movie/" + updatedMovieNameStr.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/reviews/"
            cell.onReviewButtonTapped = {
                let reviewViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("ReviewView") as! ReviewViewController
                reviewViewController.reviewUrlStr = reviewUrlStr
                self.navigationController?.pushViewController(reviewViewController, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            TipInCellAnimator.animate(cell)
        }
    }
    
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    
    @IBAction func goHome(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     
     if segue.identifier == "showReviewView" {
     let destVc = segue.destinationViewController as! ReviewViewController
     destVc.reviewUrlStr = reviewUrlStr
     }
     }*/

}
