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

    @IBOutlet var statusLabel: UILabel!
    
    var doneLoadingPixels = false
    var doneSyncDevice = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if SessionSettings.instance.sentUniqueId {
            getDeviceInfo()
        }
        else {
            sendDeviceId()
        }
        
        downloadCanvasPixels()
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
            self.performSegue(withIdentifier: "ShowInteractiveCanvas", sender: nil)
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
}
