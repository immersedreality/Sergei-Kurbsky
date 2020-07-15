//
//  LockImageView.swift
//  The Last Will And Testament Of Sergei Kurbsky
//
//  Created by Jeffrey Eugene Hoch on 7/14/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class LockImageView: UIImageView {

    private var isUnlocked = false

    func lock() {
        image = UIImage(systemName: "lock.fill")
        tintColor = UIColor.red
        isUnlocked = false
    }

    func unlock() {
        image = UIImage(systemName: "lock.open.fill")
        tintColor = UIColor.green
        isUnlocked = true
    }

    func checkIfUnlocked() -> Bool {
        return isUnlocked
    }

}
