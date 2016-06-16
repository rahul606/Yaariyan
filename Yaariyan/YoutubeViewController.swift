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
        self.playerView.loadWithVideoId(videoId as String)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        ClearCookiesCache.clearCacheAndCookies()
    }
    
    func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState) {
        switch (state){
        case YTPlayerState.Playing:
            break
        case YTPlayerState.Paused:
            break
        default:
            break
        }
    }
    //MARK: Delegate method
    
    func playerView(playerView: YTPlayerView, didChangeToQuality quality: YTPlaybackQuality) {
    }
    
    func playerView(playerView: YTPlayerView, receivedError error: YTPlayerError) {
    }
    
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        self.playerView.playVideo()
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
