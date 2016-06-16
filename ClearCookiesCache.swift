//
//  ClearCookiesCache.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 27/03/16.
//  Copyright © 2016 Rahul Tomar. All rights reserved.
//

import Foundation

class ClearCookiesCache {
    static func clearCacheAndCookies() {
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        NSURLCache.sharedURLCache().diskCapacity = 0
        NSURLCache.sharedURLCache().memoryCapacity = 0
        let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
}