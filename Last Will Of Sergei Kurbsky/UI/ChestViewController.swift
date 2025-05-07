//
//  ChestViewController.swift
//  The Last Will And Testament Of Sergei Kurbsky
//
//  Created by Jeffrey Eugene Hoch on 7/14/20.
//  Copyright © 2020 Bozo Design Labs. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import Network
import ContactsUI
import MultipeerConnectivity
import GoogleMobileAds

class ChestViewController: UIViewController {
    
    @IBOutlet weak var adBannerView: BannerView!

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
    @IBOutlet weak var showLetterButton: UIButton!
    
    var allLocks: [LockImageView] = []

    var lockThreeIsEnabled: Bool = false
    let motionManager = CMMotionManager()
    let audioSession = AVAudioSession.sharedInstance()
    let networkMonitor = NWPathMonitor()
    var serviceAdvertiser: MCNearbyServiceAdvertiser?
    var serviceBrowser: MCNearbyServiceBrowser?
    var creakSound: AVAudioPlayer?

    var appTimer = Timer()

    var accelerationCheckPassedCount = 0
    var rotationCheckPassedCount = 0

    override func viewDidLoad() {
        configureAdBanner()

        guard UserDefaults.standard.bool(forKey: "RiddleSolved") == false else {
            configureEmptyRoom()
            return
        }

        configureLocks()
        configureCreakSound()
        startEvents()
        configureNetworkMonitor()
        configureServiceAdvertiserAndBrowser()
        configureContactPicker()
    }

    override func viewDidAppear(_ animated: Bool) {
        showLetterIfFirstTimeOpeningApp()
    }

    private func configureAdBanner() {
        #if DEBUG
            adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
            adBannerView.adUnitID = "ca-app-pub-7985623540006861/3779903342"
        #endif

        adBannerView.rootViewController = self
        adBannerView.isAutoloadEnabled = true
    }

    private func configureEmptyRoom() {
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

        allLocks.forEach { $0.isHidden = true }
        chestImageView.isHidden = true
        showLetterButton.isHidden = true
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
        allLocks.forEach { $0.configureSoundEffects() }
    }

    private func configureCreakSound() {
        let creakPath = Bundle.main.path(forResource: "ChestOpen.wav", ofType: nil) ?? ""
        let creakURL = URL(fileURLWithPath: creakPath)
        creakSound = try? AVAudioPlayer(contentsOf: creakURL)
    }

    func activateAudioSession() {
        try? audioSession.setActive(true)
    }

    private func showLetterIfFirstTimeOpeningApp() {
        if UserDefaults.standard.bool(forKey: "UserIsReturning") == false {
            performSegue(withIdentifier: "PresentLetterViewController", sender: self)
            UserDefaults.standard.set(true, forKey: "UserIsReturning")
        }
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
        appTimer.invalidate()
        allLocks.forEach { $0.obliterateSoundEffects() }
        creakSound?.play()
        performSegue(withIdentifier: "PresentOpenChestViewController", sender: self)
    }

    @IBAction func presentLetterButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "PresentLetterViewController", sender: self)
    }

}

//LocksOneTwoAndThree
extension ChestViewController {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.contains(where: { (touch) -> Bool in
            touch.view == chestImageView
        }) {
            if lockOneImageView.checkIfUnlocked() == false {
                lockOneImageView.unlock()
            }
            checkIfChestShouldOpen()
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(unlockLockTwo))
            chestImageView.addGestureRecognizer(pinchGestureRecognizer)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        chestImageView.gestureRecognizers?.removeAll{ $0 is UIPinchGestureRecognizer }
        lockThreeIsEnabled = false
        if lockOneImageView.checkIfUnlocked() == true {
            lockOneImageView.lock()
        }

        if lockTwoImageView.checkIfUnlocked() == true {
            lockTwoImageView.lock()
        }

        if lockThreeImageView.checkIfUnlocked() == true {
            lockThreeImageView.lock()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.contains(where: { (touch) -> Bool in
            let touchLocation = touch.location(in: chestImageView)
            return chestImageView.bounds.contains(touchLocation) == false
        }) {
            chestImageView.gestureRecognizers?.removeAll()
            lockThreeIsEnabled = false

            if lockOneImageView.checkIfUnlocked() == true {
                lockOneImageView.lock()
            }

            if lockTwoImageView.checkIfUnlocked() == true {
                lockTwoImageView.lock()
            }

            if lockThreeImageView.checkIfUnlocked() == true {
                lockThreeImageView.lock()
            }
        }
    }

    @objc func unlockLockTwo() {
        if lockTwoImageView.checkIfUnlocked() == false {
            lockTwoImageView.unlock()
            lockThreeIsEnabled = true
            checkIfChestShouldOpen()
        }
    }

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard lockThreeIsEnabled else { return }
        if motion == .motionShake {
            if lockThreeImageView.checkIfUnlocked() == false {
                lockThreeImageView.unlock()
                checkIfChestShouldOpen()
            }
        }
    }
}

//LocksFourFiveSixAndSeven
extension ChestViewController: AVAudioRecorderDelegate {

    private func startEvents() {
        if motionManager.isGyroAvailable && motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0/60.0
            motionManager.startAccelerometerUpdates()
            motionManager.gyroUpdateInterval = 1.0/60.0
            motionManager.startGyroUpdates()

            appTimer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: { (_) in

                if let data = self.motionManager.accelerometerData {
                    if data.acceleration.z > 0 {
                        self.accelerationCheckPassedCount += 1
                        guard self.accelerationCheckPassedCount >= 30 else { return }
                        if self.lockFourImageView.checkIfUnlocked() == false {
                            self.lockFourImageView.unlock()
                            self.checkIfChestShouldOpen()
                        }
                    } else {
                        self.accelerationCheckPassedCount = 0
                        if self.lockFourImageView.checkIfUnlocked() == true {
                            self.lockFourImageView.lock()
                        }
                    }
                }

                if let data = self.motionManager.gyroData {
                    if data.rotationRate.z < -2 {
                        self.rotationCheckPassedCount += 1
                        guard self.rotationCheckPassedCount >= 30 else { return }
                        if self.lockFiveImageView.checkIfUnlocked() == false {
                            self.lockFiveImageView.unlock()
                            self.checkIfChestShouldOpen()
                        }
                    } else {
                        self.rotationCheckPassedCount = 0
                        if self.lockFiveImageView.checkIfUnlocked() == true {
                            self.lockFiveImageView.lock()
                        }
                    }
                }

                if self.audioSession.outputVolume < 0.80 && self.audioSession.outputVolume > 0.70  {
                    if self.lockSixImageView.checkIfUnlocked() == false {
                        self.lockSixImageView.unlock()
                        self.checkIfChestShouldOpen()
                    }
                } else {
                    if self.lockSixImageView.checkIfUnlocked() == true {
                        self.lockSixImageView.lock()
                    }
                }

                if UserDefaults.standard.bool(forKey: "seven") == true {
                    if self.lockSevenImageView.checkIfUnlocked() == false {
                        self.lockSevenImageView.unlock()
                        self.checkIfChestShouldOpen()
                    }
                } else {
                    if self.lockSevenImageView.checkIfUnlocked() == true {
                        self.lockSevenImageView.lock()
                    }
                }

            })

            RunLoop.current.add(self.appTimer, forMode: RunLoop.Mode.default)
        }

    }

}

//LockEight
extension ChestViewController {

    private func configureNetworkMonitor() {
        networkMonitor.pathUpdateHandler = { path in
            if path.availableInterfaces.contains(where: { (interface) -> Bool in
                interface.type == .cellular
            }) == false && path.status == .satisfied {
                if self.lockEightImageView.checkIfUnlocked() == false {
                    self.lockEightImageView.unlock()
                    self.checkIfChestShouldOpen()
                }
            } else {
                if self.lockEightImageView.checkIfUnlocked() == true {
                    self.lockEightImageView.lock()
                }
            }
        }
        networkMonitor.start(queue: .main)
    }

}

//LockNine
extension ChestViewController: MCNearbyServiceBrowserDelegate {

    private func configureServiceAdvertiserAndBrowser() {
        let myPeerId = MCPeerID(displayName: UIDevice.current.name)
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: "sergeikurbsky")
        self.serviceAdvertiser?.startAdvertisingPeer()

        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: "sergeikurbsky")
        self.serviceBrowser?.delegate = self
        self.serviceBrowser?.startBrowsingForPeers()
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if self.lockNineImageView.checkIfUnlocked() == false {
            self.lockNineImageView.unlock()
            self.checkIfChestShouldOpen()
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        return
    }

}

//LockTen
extension ChestViewController: CNContactPickerDelegate {

    private func configureContactPicker() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchContactPicker))
        tapGestureRecognizer.numberOfTapsRequired = 13
        lockTenImageView.isUserInteractionEnabled = true
        lockTenImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func launchContactPicker() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        present(contactPickerViewController, animated: true, completion: nil)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if contact.givenName == "Sergei" && contact.familyName == "Kurbsky" {
            if self.lockTenImageView.checkIfUnlocked() == false {
                self.lockTenImageView.unlock()
                self.checkIfChestShouldOpen()
            }
        }
    }

}
