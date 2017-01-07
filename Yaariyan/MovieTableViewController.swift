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
    var preventAnimation: Set<IndexPath>!
    var whichCellPressed: NSInteger!
    var url: URL!
    var imageCache: NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalRowCount = NSInteger()
        self.preventAnimation = Set<IndexPath>()
        imageCache = NSCache()
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        searchThisWeekMovies()
    }
    
    internal func searchThisWeekMovies() {
        
        if(whichCellPressed == 0) {
            url = URL(string: "http://api.cinemalytics.in/v2/movie/releasedthisweek?auth_token=ECF106431844CAF24373B15E1F181FCD")
        }
        if(whichCellPressed == 1) {
            url = URL(string: "http://api.cinemalytics.in/v2/movie/latest-trailers/?auth_token=ECF106431844CAF24373B15E1F181FCD")
        }
        if(whichCellPressed == 2) {
            url = URL(string: "http://api.cinemalytics.in/v2/movie/upcoming?auth_token=ECF106431844CAF24373B15E1F181FCD")
        }
        
        let session = URLSession.shared
        let task = session.downloadTask(with: url!, completionHandler: {(url, response, error) in
            
            let data: Data = try! Data(contentsOf: url!)
            let tempJsonArray = (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
            self.jsonArray = tempJsonArray.reversed() as NSArray!
            self.totalRowCount = self.jsonArray.count
            if let error = error {
                print("error = \(error)")
            }
            
            if let response = response {
                print("response = \(response)")
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return totalRowCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath) as! MovieTableViewCell
        
        cell.reviewButton.isHidden = true
        if whichCellPressed < 1 {
            cell.reviewButton.isHidden = false
        }
        let posterUrlStr = (self.jsonArray[indexPath.row] as? NSDictionary)?["PosterPath"] as! String
        let movieNameStr = (self.jsonArray[indexPath.row] as? NSDictionary)?["Title"] as! String
        var movieDescriptionStr = (self.jsonArray[indexPath.row] as? NSDictionary)?["Description"] as! String
        let movieGenre = (self.jsonArray[indexPath.row] as? NSDictionary)?["Genre"] as! String
        let movieCensorRating = (self.jsonArray[indexPath.row] as? NSDictionary)?["CensorRating"] as! String
        let movieReleaseDate = (self.jsonArray[indexPath.row] as? NSDictionary)?["ReleaseDate"] as! String
        let youtubeLink = (self.jsonArray[indexPath.row] as? NSDictionary)?["TrailerLink"] as! String
        
        let cellImageFromUrl = imageCache.object(forKey: posterUrlStr as AnyObject) as? UIImage
        if cellImageFromUrl == nil {
            cell.movieName.text = movieNameStr
            cell.movieImage.image = UIImage(named: "MovieLounge")
            cell.descriptionWindowTitle = movieNameStr
            
            let youtubeLinkArr = youtubeLink.characters.split{$0 == "="}.map(String.init)
            if (youtubeLinkArr.count) > 1 {
                cell.youtubeButton.isEnabled = true
                cell.onYoutubeButtonTapped = {
                    let playerViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "PlayerView") as! YoutubeViewController
                    playerViewController.videoId = youtubeLinkArr[1] as NSString! 
                    self.navigationController?.pushViewController(playerViewController, animated: true)
                }
            }
            else {
                cell.youtubeButton.isEnabled = false
            }
            let updatedMovieNameStr = removeSpecialCharsFromString(movieNameStr)
            let reviewUrlStr = "http://thereviewmonk.com/movie/" + updatedMovieNameStr.replacingOccurrences(of: " ", with: "-") + "/reviews/"
            cell.onReviewButtonTapped = {
                let reviewViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ReviewView") as! ReviewViewController
                reviewViewController.reviewUrlStr = reviewUrlStr as NSString! as NSString!
                self.navigationController?.pushViewController(reviewViewController, animated: true)
            }
            cell.descriptionWindowDetails = movieDescriptionStr
            cell.imageLoadingActivity.startAnimating()
            let session = URLSession.shared
            let task = session.downloadTask(with: url!, completionHandler: {(url, response, error) in
                
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                    var imageUrl: URL!
                    var image: UIImage!
                    if (posterUrlStr != "" && (posterUrlStr.range(of: ".png") != nil || posterUrlStr.range(of: ".jpg") != nil)) {
                        imageUrl = URL(string: posterUrlStr as String)
                        let imageData = try? Data(contentsOf: imageUrl!)
                        image = UIImage(data: imageData!)
                    }
                    else {
                        image = UIImage(named: "MovieLounge")
                    }
                    
                    if let error = error {
                        NSLog("error = \(error)", "Error while downloading image url")
                    }
                    
                    DispatchQueue.main.async(execute: {
                        let updateCell = self.tableView.cellForRow(at: indexPath) as? MovieTableViewCell
                        if((updateCell) != nil){
                            updateCell?.imageLoadingActivity.stopAnimating()
                            updateCell?.imageLoadingActivity.hidesWhenStopped
                            let cellImageFromUrl = image
                            updateCell!.movieName.text = movieNameStr
                            updateCell!.movieImage.image = cellImageFromUrl
                            updateCell!.descriptionWindowTitle = movieNameStr
                            let lineBreak = "\r\n"
                            var fullMovieDescription = "Release Date : " + movieReleaseDate + lineBreak
                            fullMovieDescription += "Genre : " + movieGenre + lineBreak
                            fullMovieDescription += "Censor Rating : " + movieCensorRating + lineBreak
                            fullMovieDescription += movieDescriptionStr
                            
                            movieDescriptionStr = fullMovieDescription
                            let youtubeLinkArr = youtubeLink.characters.split{$0 == "="}.map(String.init)
                            if (youtubeLinkArr.count) > 1 {
                                updateCell!.youtubeButton.isEnabled = true
                                updateCell!.onYoutubeButtonTapped = {
                                    let playerViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "PlayerView") as! YoutubeViewController
                                    playerViewController.videoId = youtubeLinkArr[1] as NSString!
                                    self.navigationController?.pushViewController(playerViewController, animated: true)
                                }
                            }
                            else {
                                updateCell!.youtubeButton.isEnabled = false
                            }
                            updateCell!.descriptionWindowDetails = movieDescriptionStr
                            self.imageCache.setObject(cellImageFromUrl!, forKey: posterUrlStr as AnyObject)
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
            let lineBreak = "\r\n"
            var fullMovieDescription = "Release Date : " + movieReleaseDate + lineBreak
            fullMovieDescription += "Genre : " + movieGenre + lineBreak
            fullMovieDescription += "Censor Rating : " + movieCensorRating + lineBreak
            fullMovieDescription += movieDescriptionStr
            
            movieDescriptionStr = fullMovieDescription
            let youtubeLinkArr = youtubeLink.characters.split{$0 == "="}.map(String.init)
            if (youtubeLinkArr.count) > 1 {
                cell.youtubeButton.isEnabled = true
                cell.onYoutubeButtonTapped = {
                    let playerViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "PlayerView") as! YoutubeViewController
                    playerViewController.videoId = youtubeLinkArr[1] as NSString!
                    self.navigationController?.pushViewController(playerViewController, animated: true)
                }
            }
            else {
                cell.youtubeButton.isEnabled = false
            }
            cell.descriptionWindowDetails = movieDescriptionStr
            
            let updatedMovieNameStr = removeSpecialCharsFromString(movieNameStr)
            let reviewUrlStr = "http://thereviewmonk.com/movie/" + updatedMovieNameStr.replacingOccurrences(of: " ", with: "-") + "/reviews/"
            cell.onReviewButtonTapped = {
                let reviewViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "ReviewView") as! ReviewViewController
                reviewViewController.reviewUrlStr = reviewUrlStr as NSString!
                self.navigationController?.pushViewController(reviewViewController, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !preventAnimation.contains(indexPath) {
            preventAnimation.insert(indexPath)
            TipInCellAnimator.animate(cell)
        }
    }
    
    func removeSpecialCharsFromString(_ text: String) -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890".characters)
        return String(text.characters.filter {okayChars.contains($0) })
    }
    
    
    @IBAction func goHome(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
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
