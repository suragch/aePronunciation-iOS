//
//  Player.swift
//  aePronunciation
//
//  Created by MongolSuragch on 10/5/15.
//  Copyright © 2015 Suragch. All rights reserved.
//

import Foundation
import AudioToolbox

class Player {
    
    private let audioFolder = "raw"
    
    func playSoundFromFile(file: String) {
        var soundURL: NSURL?
        var soundID: SystemSoundID = 0
        let filePath = NSBundle.mainBundle().pathForResource("\(audioFolder)/\(file)", ofType: "mp3")
        soundURL = NSURL(fileURLWithPath: filePath!)
        if let url = soundURL {
            AudioServicesCreateSystemSoundID(url, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
}