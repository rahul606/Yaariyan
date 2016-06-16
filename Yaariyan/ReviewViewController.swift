//
//  ReviewViewController.swift
//  Yaariyan
//
//  Created by Rahul Tomar on 16/06/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var forwardBtn: UIBarButtonItem!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var reviewWebPage: UIWebView!
    
    var reviewUrlStr: NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewWebPage.delegate = self
        ClearCookiesCache.clearCacheAndCookies()
        let url = NSURL(string: reviewUrlStr as String)
        let request = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
                                   timeoutInterval: 10.0)
        forwardBtn.enabled = false
        backBtn.enabled = false
        reviewWebPage.loadRequest(request)
    }
    
    override func viewWillDisappear(animated: Bool) {
        ClearCookiesCache.clearCacheAndCookies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingImage.image = UIImage.gifWithName("loading")
        loadingImage.hidden = false
        if reviewWebPage.canGoBack {
            backBtn.enabled = true
        } else {
            backBtn.enabled = false
        }
        
        if reviewWebPage.canGoForward {
            forwardBtn.enabled = true
        } else {
            forwardBtn.enabled = false
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingImage.image = nil
        loadingImage.hidden = true
    }
    
    
    @IBAction func goHome(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func goForward(sender: UIBarButtonItem) {
        reviewWebPage.goForward()
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        reviewWebPage.goBack()
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
