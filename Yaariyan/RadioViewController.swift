//
//  RadioViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 12/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit
import MediaPlayer

class RadioViewController: UIViewController {

    var artistUrl: NSString = ""
    var timer: NSTimer!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var artistInfo: UITextView!
    @IBOutlet weak var albumImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBtn.layer.cornerRadius = 0.5 * playBtn.bounds.size.width
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playBtn.setTitle("STOP", forState: UIControlState.Normal)
        } else {
            playBtn.setTitle("PLAY", forState: UIControlState.Normal)
        }
        if Reachability.isConnectedToNetwork() == false {
            let alertController = Reachability.showAlert()
            presentViewController(alertController, animated: true, completion: nil);
        } else {
            searchSong()
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            timer = NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector: #selector(RadioViewController.searchSong), userInfo: nil, repeats: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            timer.invalidate()
        }
    }
    
    internal func searchSong()
    {
        dispatch_async(dispatch_get_main_queue(), {
            let url = NSURL(string: "http://tunein.com/radio/City-1016-FM-s14329/")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                if error == nil {
                    let urlData :NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    if(urlData != "")
                    {
                        let divData=self.parse(urlData, open: "<h3 class=\"title\">", close: "</h3>")
                        var itunesSearchTerm: String = divData.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, divData.length))
                        itunesSearchTerm = divData.stringByReplacingOccurrencesOfString("-", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, divData.length))
                        
                        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
                        var newurlStr = "http://itunes.apple.com/search?term=("
                        newurlStr = newurlStr + escapedSearchTerm!
                        newurlStr = newurlStr + ")&media=music"
                        let inputData: NSData = NSData(contentsOfURL: NSURL(string: newurlStr)!)!
                        let boardsDictionary: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                        
                        let resultCountValue = boardsDictionary["resultCount"] as! NSNumber
                        let resultCount = resultCountValue.integerValue
                        if(resultCount > 0)
                        {
                            self.setInfo(boardsDictionary)
                        }
                        else
                        {
                            newurlStr = "http://itunes.apple.com/search?term=(dilwale-dulhaniya-le-jayenge)&media=music"
                            let inputData: NSData = NSData(contentsOfURL: NSURL(string: newurlStr)!)!
                            let boardsDictionary: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                            self.setInfo(boardsDictionary)
                        }
                    }
                } else {
                    dispatch_sync(dispatch_get_main_queue()) {
                        
                        SweetAlert().showAlert("No Internet", subTitle: "Please check your internet. Application wiil be closed.", style: AlertStyle.Error, buttonTitle: "Okay", buttonColor: UIColor.color(89, green: 188, blue: 184, alpha: 1), action: { (isOtherButton) in
                            exit(0)
                        })
                    }
                }
            }
            task.resume()
        })
    }
    
    private func setInfo(boardsDictionary: NSDictionary)
    {
        let resultData: NSArray = boardsDictionary["results"] as! NSArray
        let artistName: NSString = resultData[0]["artistName"] as! NSString
        dispatch_sync(dispatch_get_main_queue())
        {
            self.artistInfo.text = artistName as String
            self.artistInfo.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 15)
            self.artistInfo.textColor = UIColor.whiteColor()
            self.artistInfo.textAlignment = NSTextAlignment.Center
        }
        self.artistUrl = resultData[0]["artistViewUrl"] as! NSString
        var albumImageUrl: NSString = resultData[0]["artworkUrl100"] as! NSString
        albumImageUrl = albumImageUrl.stringByReplacingOccurrencesOfString("100x100", withString: "170x170")
        let imageUrl = NSURL(string: albumImageUrl as String)
        let imageData = NSData(contentsOfURL: imageUrl!)
        self.albumImage.image = UIImage(data: imageData!)
    }
    
    private func parse(thing: NSString, open: NSString, close: NSString ) -> NSString
    {
        var divRange:NSRange = thing.rangeOfString(open as String, options:NSStringCompareOptions.CaseInsensitiveSearch)
        if (divRange.location != NSNotFound)
        {
            var endDivRange = NSMakeRange(divRange.length + divRange.location, thing.length - ( divRange.length + divRange.location))
            endDivRange = thing.rangeOfString(close as String, options:NSStringCompareOptions.CaseInsensitiveSearch, range:endDivRange)
            
            if (endDivRange.location != NSNotFound)
            {
                divRange.location += divRange.length
                divRange.length  = endDivRange.location - divRange.location
            }
        }
        return thing.substringWithRange(divRange)
    }
    
    
    @IBAction func btnPressed(sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            toggle()
        }
    }
    
    func toggle() {
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
        } else {
            playRadio()
        }
    }
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
        playBtn.setTitle("STOP", forState: UIControlState.Normal)
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        playBtn.setTitle("PLAY", forState: UIControlState.Normal)
        
    }
    
}
