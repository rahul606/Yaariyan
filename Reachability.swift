//
//  Reachability.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 26/05/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import SystemConfiguration
import UIKit

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    class func showAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
            let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
