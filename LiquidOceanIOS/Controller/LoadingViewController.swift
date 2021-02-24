//
//  LoadingViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import Alamofire

class LoadingViewController: UIViewController {

    var showInteractiveCanvas = "ShowInteractiveCanvas"
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet weak var dotsLabel: UILabel!
    @IBOutlet weak var gameTipLabel: UILabel!
    
    let gameTips = ["You can turn several features on / off in the Options mneu",
                    "All drawings can be exported to a PNG file. Simply use the object selector tool, tap an object, and from there you can save it",
                    "Anything you create on the world canvas is automatically saved and shared with others.",
                    "Like you level, paint, and other stas? Back your account up now and sync across multiple devices with Google or Facebook.",
                    "Tap on any pixel on the world canvas to view a history of edits for that position.",
                    "No violence, racism, bigotry, or nudity of any kind is allowed on the world canvas.",
                    "Anyone can get started painting on the world canvas in 5 minutes or less, tap the paint bar to bring up a timer with when the next paint event will occur."]
    
    var doneLoadingPixels = false
    var doneSyncDevice = false
    
    var timer: Timer!
    var lastDotsStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if SessionSettings.instance.sentUniqueId {
            getDeviceInfo()
        }
        else {
            sendDeviceId()
        }
        
        downloadCanvasPixels()
        
        let rIndex = Int(arc4random() % UInt32(gameTips.count))
        gameTipLabel.text = gameTips[rIndex]
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (tmr) in
            if self.lastDotsStr.count < 3 {
                self.lastDotsStr = self.lastDotsStr + "."
            }
            else {
                self.lastDotsStr = ""
            }
            self.dotsLabel.text = self.lastDotsStr
        }
    }

    func downloadCanvasPixels() {
        
        URLSessionHandler.instance.downloadCanvasPixels { (success) in
            if success {
                self.doneLoadingPixels = true
                
                self.downloadFinished()
            }
        }
    }
    
    func getDeviceInfo() {
        URLSessionHandler.instance.getDeviceInfo { (success) -> (Void) in
            if success {
                self.doneSyncDevice = true
                
                self.downloadFinished()
            }
        }
    }
    
    func sendDeviceId() {
        URLSessionHandler.instance.sendDeviceId { (success) -> (Void) in
            if success {
                self.doneSyncDevice = true
                
                self.downloadFinished()
            }
        }
    }
    
    func downloadFinished() {
        statusLabel.text = String(format: "Loading %d / 2", getNumLoaded())
        
        if loadingDone() {
            SessionSettings.instance.save()
            self.performSegue(withIdentifier: self.showInteractiveCanvas, sender: nil)
        }
    }
    
    func getNumLoaded() -> Int {
        var num = 0
        
        if doneLoadingPixels {
            num += 1
        }
        
        if doneSyncDevice {
            num += 1
        }
        
        return num
    }
    
    func loadingDone() -> Bool {
        return doneLoadingPixels && doneSyncDevice
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.showInteractiveCanvas {
            let vc = segue.destination as! InteractiveCanvasViewController
            vc.world = true
        }
        
        timer.invalidate()
    }
}
