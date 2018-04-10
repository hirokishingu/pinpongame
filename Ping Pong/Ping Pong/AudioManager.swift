//
//  AudioManager.swift
//  Ping Pong
//
//  Created by 新宮広輝 on 2017/01/21.
//  Copyright © 2017年 新宮広輝. All rights reserved.
//

import AVFoundation

class AudioManager {

    static let instance = AudioManager()
    private init() {}

    private var audioPlayer:AVAudioPlayer?
    
    
    var isMusicOn = false

    func playBGM(){
        
        isMusicOn = true
    
        let url = Bundle.main.url(forResource: "omocha", withExtension: "mp3")
    
        var err:NSError?
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.3
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let err1 as NSError {
            err = err1
        }
    
        if err != nil {
            print("問題あり \(String(describing: err))")
        }
    }
    
    func play1BGM(){
        
        isMusicOn = true
        
        let url = Bundle.main.url(forResource: "nichi", withExtension: "mp3")
        
        var err:NSError?
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url!)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.3
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch let err1 as NSError {
            err = err1
        }
        
        if err != nil {
            print("問題あり \(String(describing: err))")
        }
    }

    func stopBGM(){
        if isMusicOn == true {
            audioPlayer?.stop()
            isMusicOn = false
        }
        
    }
}


















