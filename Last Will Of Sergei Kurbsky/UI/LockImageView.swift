//
//  LockImageView.swift
//  The Last Will And Testament Of Sergei Kurbsky
//
//  Created by Jeffrey Eugene Hoch on 7/14/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit
import AVFoundation

class LockImageView: UIImageView {

    private var isUnlocked = false
    private var lockSound: AVAudioPlayer?
    private var unlockSound: AVAudioPlayer?

    func configureSoundEffects() {
        let lockPath = Bundle.main.path(forResource: "Lock.flac", ofType: nil) ?? ""
        let lockURL = URL(fileURLWithPath: lockPath)
        lockSound = try? AVAudioPlayer(contentsOf: lockURL)

        let unlockPath = Bundle.main.path(forResource: "Unlock.wav", ofType: nil) ?? ""
        let unlockURL = URL(fileURLWithPath: unlockPath)
        unlockSound = try? AVAudioPlayer(contentsOf: unlockURL)
    }

    func obliterateSoundEffects() {
        lockSound = nil
        unlockSound = nil
    }

    func lock() {
        image = UIImage(named: "Lock-Closed")
        isUnlocked = false
        lockSound?.play()
    }

    func unlock() {
        image = UIImage(named: "Lock-Open")
        isUnlocked = true
        unlockSound?.play()
    }

    func checkIfUnlocked() -> Bool {
        return isUnlocked
    }

}
