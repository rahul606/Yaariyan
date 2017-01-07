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

    var artistUrl: String = ""
    var timer: Timer!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var artistInfo: UITextView!
    @IBOutlet weak var albumImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBtn.layer.cornerRadius = 0.5 * playBtn.bounds.size.width
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            playBtn.setTitle("STOP", for: UIControlState())
        } else {
            playBtn.setTitle("PLAY", for: UIControlState())
        }
        if Reachability.isConnectedToNetwork() == false {
            let alertController = Reachability.showAlert()
            present(alertController, animated: true, completion: nil);
        } else {
            searchSong()
            UIApplication.shared.beginReceivingRemoteControlEvents()
            timer = Timer.scheduledTimer(timeInterval: 10, target:self, selector: #selector(RadioViewController.searchSong), userInfo: nil, repeats: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == true {
            timer.invalidate()
        }
    }
    
    internal func searchSong()
    {
        DispatchQueue.main.async(execute: {
            let url = URL(string: "http://tunein.com/radio/City-1016-FM-s14329/")
            let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                if error == nil {
                    let urlData :NSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                    if(urlData != "")
                    {
                        let divData=self.parse(urlData, open: "<h3 class=\"title\">", close: "</h3>")
                        var itunesSearchTerm: String = divData.replacingOccurrences(of: " ", with: "+", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, divData.length))
                        itunesSearchTerm = divData.replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, divData.length))
                        
                        let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                        var newurlStr = "http://itunes.apple.com/search?term=("
                        newurlStr = newurlStr + escapedSearchTerm!
                        newurlStr = newurlStr + ")&media=music"
                        let inputData: Data = try! Data(contentsOf: URL(string: newurlStr)!)
                        let boardsDictionary: NSDictionary = (try! JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                        
                        let resultCountValue = boardsDictionary["resultCount"] as! NSNumber
                        let resultCount = resultCountValue.intValue
                        if(resultCount > 0)
                        {
                            self.setInfo(boardsDictionary)
                        }
                        else
                        {
                            newurlStr = "http://itunes.apple.com/search?term=(dilwale-dulhaniya-le-jayenge)&media=music"
                            let inputData: Data = try! Data(contentsOf: URL(string: newurlStr)!)
                            let boardsDictionary: NSDictionary = (try! JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                            self.setInfo(boardsDictionary)
                        }
                    }
                } else {
                    DispatchQueue.main.sync {
                        
                        SweetAlert().showAlert("No Internet", subTitle: "Please check your internet. Application wiil be closed.", style: AlertStyle.error, buttonTitle: "Okay", buttonColor: UIColor.color(89, green: 188, blue: 184, alpha: 1), action: { (isOtherButton) in
                            exit(0)
                        })
                    }
                }
            }) 
            task.resume()
        })
    }
    
    fileprivate func setInfo(_ boardsDictionary: NSDictionary)
    {
        let resultData: NSArray = boardsDictionary["results"]! as! NSArray
        let artistName = (resultData[0] as? NSDictionary)?["artistName"]
        DispatchQueue.main.sync
        {
            self.artistInfo.text = artistName as! String
            self.artistInfo.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 15)
            self.artistInfo.textColor = UIColor.white
            self.artistInfo.textAlignment = NSTextAlignment.center
        }
        self.artistUrl = (resultData[0] as? NSDictionary)?["artistViewUrl"] as! String
        var albumImageUrl: String = ((resultData[0] as? NSDictionary)?["artworkUrl100"])! as! String
        albumImageUrl = (albumImageUrl.replacingOccurrences(of: "100x100", with: "170x170") as NSString) as String
        let imageUrl = URL(string: albumImageUrl as String)
        let imageData = try? Data(contentsOf: imageUrl!)
        self.albumImage.image = UIImage(data: imageData!)
    }
    
    fileprivate func parse(_ thing: NSString, open: NSString, close: NSString ) -> NSString
    {
        var divRange:NSRange = thing.range(of: open as String, options:NSString.CompareOptions.caseInsensitive)
        if (divRange.location != NSNotFound)
        {
            var endDivRange = NSMakeRange(divRange.length + divRange.location, thing.length - ( divRange.length + divRange.location))
            endDivRange = thing.range(of: close as String, options:NSString.CompareOptions.caseInsensitive, range:endDivRange)
            
            if (endDivRange.location != NSNotFound)
            {
                divRange.location += divRange.length
                divRange.length  = endDivRange.location - divRange.location
            }
        }
        return thing.substring(with: divRange) as NSString
    }
    
    
    @IBAction func btnPressed(_ sender: UIButton) {
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
        playBtn.setTitle("STOP", for: UIControlState())
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        playBtn.setTitle("PLAY", for: UIControlState())
        
    }
    
}
