//
//  OpenChestViewController.swift
//  The Last Will And Testament Of Sergei Kurbsky
//
//  Created by Jeffrey Eugene Hoch on 7/15/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class OpenChestViewController: UIViewController {

    var countdownTimer = Timer()
    var countDownStart = 10
    
    @IBAction func iAmReadyButtonTapped(_ sender: Any) {

        countdownTimer = Timer(fire: Date(), interval: 1.0, repeats: true, block: { (timer) in
            self.countDownStart -= 1

            if self.countDownStart == 1 {
                UserDefaults.standard.set(true, forKey: "RiddleSolved")
                exit(0)
            }

        })

        RunLoop.current.add(self.countdownTimer, forMode: RunLoop.Mode.default)

    }
    
}
