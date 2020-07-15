//
//  ChestViewController.swift
//  The Last Will And Testament Of Sergei Kurbsky
//
//  Created by Jeffrey Eugene Hoch on 7/14/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit

class ChestViewController: UIViewController {
    
    @IBOutlet weak var lockOneImageView: LockImageView!
    @IBOutlet weak var lockTwoImageView: LockImageView!
    @IBOutlet weak var lockThreeImageView: LockImageView!
    @IBOutlet weak var lockFourImageView: LockImageView!
    @IBOutlet weak var lockFiveImageView: LockImageView!
    @IBOutlet weak var lockSixImageView: LockImageView!
    @IBOutlet weak var lockSevenImageView: LockImageView!
    @IBOutlet weak var lockEightImageView: LockImageView!
    @IBOutlet weak var lockNineImageView: LockImageView!
    @IBOutlet weak var lockTenImageView: LockImageView!
    @IBOutlet weak var chestImageView: UIImageView!
    
    var allLocks: [LockImageView] = []

    override func viewDidLoad() {
        configureLocks()
    }

    private func configureLocks() {
        allLocks.append(lockOneImageView)
        allLocks.append(lockTwoImageView)
        allLocks.append(lockThreeImageView)
        allLocks.append(lockFourImageView)
        allLocks.append(lockFiveImageView)
        allLocks.append(lockSixImageView)
        allLocks.append(lockSevenImageView)
        allLocks.append(lockEightImageView)
        allLocks.append(lockNineImageView)
        allLocks.append(lockTenImageView)
    }

    private func checkIfChestShouldOpen() {
        if chestShouldOpen() {
            openChest()
        }
    }

    private func chestShouldOpen() -> Bool {
        for lock in allLocks {
            guard lock.checkIfUnlocked() == true else { return false }
            continue
        }

        return true
    }

    private func openChest() {
        
    }

    @IBAction func presentLetterButtonTapped(_ sender: Any) {
    }

}

//LockOne
extension ChestViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view == chestImageView {
            lockOneImageView.unlock()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view == chestImageView {
            lockOneImageView.lock()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: chestImageView)
        if chestImageView.bounds.contains(touchLocation) == false {
            lockOneImageView.lock()
        }
    }

}
