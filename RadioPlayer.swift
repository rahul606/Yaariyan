//
//  RadioPlayer.swift
//  BollywoodMasti
//
//  Created by Rahul Tomar on 10/11/15.
//  Copyright © 2015 Rahul Tomar. All rights reserved.
//

import Foundation
import AVFoundation

class RadioPlayer {
    static let sharedInstance = RadioPlayer()
    fileprivate var player = AVPlayer(url: URL(string: "http://playerservices.streamtheworld.com/pls/ARNCITYAAC.pls")!)
    fileprivate var isPlaying = false
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func toggle() {
        if isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
}
