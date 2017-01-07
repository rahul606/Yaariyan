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
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
}
