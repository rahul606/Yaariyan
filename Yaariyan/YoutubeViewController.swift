//
//  YoutubeViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 16/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

class YoutubeViewController: UIViewController, YTPlayerViewDelegate  {

    @IBOutlet weak var playerView: YTPlayerView!
    
    var videoId: NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        ClearCookiesCache.clearCacheAndCookies()
        self.playerView.load(withVideoId: videoId as String)
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ClearCookiesCache.clearCacheAndCookies()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch (state){
        case YTPlayerState.playing:
            break
        case YTPlayerState.paused:
            break
        default:
            break
        }
    }
    //MARK: Delegate method
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goHome(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
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
