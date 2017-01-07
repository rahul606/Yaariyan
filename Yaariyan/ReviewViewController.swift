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
        let url = URL(string: reviewUrlStr as String)
        let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                                   timeoutInterval: 10.0)
        forwardBtn.isEnabled = false
        backBtn.isEnabled = false
        reviewWebPage.loadRequest(request)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ClearCookiesCache.clearCacheAndCookies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadingImage.image = UIImage.gifWithName("loading")
        loadingImage.isHidden = false
        if reviewWebPage.canGoBack {
            backBtn.isEnabled = true
        } else {
            backBtn.isEnabled = false
        }
        
        if reviewWebPage.canGoForward {
            forwardBtn.isEnabled = true
        } else {
            forwardBtn.isEnabled = false
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingImage.image = nil
        loadingImage.isHidden = true
    }
    
    
    @IBAction func goHome(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        reviewWebPage.goForward()
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
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
