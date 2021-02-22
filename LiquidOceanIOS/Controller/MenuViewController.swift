//
//  MenuViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/12/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, AchievementListener {

    let showSinglePlay = "ShowSinglePlay"
    let showLoadingScreen = "ShowLoading"
    let showStats = "ShowStats"
    
    @IBOutlet weak var playButton: ActionButtonView!
    @IBOutlet weak var optionsButton: ActionButtonView!
    @IBOutlet weak var statsButton: ActionButtonView!
    @IBOutlet weak var exitButton: ActionButtonView!
    
    @IBOutlet weak var singleAction: ActionButtonView!
    @IBOutlet weak var worldAction: ActionButtonView!
    
    @IBOutlet weak var backAction: ActionButtonView!
    
    @IBOutlet weak var achievementBanner: UIView!
    
    @IBOutlet weak var achievementIcon: UIView!
    @IBOutlet weak var achievementName: UILabel!
    @IBOutlet weak var achievementDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))

        self.playButton.type = .play
        self.optionsButton.type = .options
        self.statsButton.type = .stats
        self.exitButton.type = .exit
        
        self.singleAction.type = .single
        self.worldAction.type = .world
        
        self.backAction.type = .backSolid
        
        self.backAction.setOnClickListener {
            if !self.singleAction.isHidden {
                self.toggleMenuButtons(show: true, depth: 0)
                self.toggleMenuButtons(show: false, depth: 1)
                
                self.backAction.isHidden = true
            }
        }
        
        self.playButton.setOnClickListener {
            self.toggleMenuButtons(show: false, depth: 0)
            self.toggleMenuButtons(show: true, depth: 1)
            
            self.backAction.isHidden = false
        }
        
        self.statsButton.setOnClickListener {
            self.performSegue(withIdentifier: self.showStats, sender: nil)
        }
        
        self.exitButton.setOnClickListener {
            exit(-1)
        }
        
        self.singleAction.setOnClickListener {
            self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
        }
        
        self.worldAction.setOnClickListener {
            self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
        }
        
        SessionSettings.instance.numRecentColors = 12
        
        StatTracker.instance.achievementListener = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        StatTracker.instance.achievementListener = nil
        
        if segue.identifier == self.showSinglePlay {
            let vc = segue.destination as! InteractiveCanvasViewController
            vc.world = false
        }
        else if segue.identifier == self.showStats  {
            let _ = segue.destination as! StatsViewController
        }
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        self.toggleMenuButtons(show: true, depth: 0)
        self.toggleMenuButtons(show: false, depth: 1)
        
        self.backAction.isHidden = true
    }
    
    func toggleMenuButtons(show: Bool, depth: Int) {
        if depth == 0 {
            self.playButton.isHidden = !show
            self.optionsButton.isHidden = !show
            self.statsButton.isHidden = !show
            self.exitButton.isHidden = !show
        }
        else if depth == 1 {
            self.singleAction.isHidden = !show
            self.worldAction.isHidden = !show
        }
    }
    
    // achievement listener
    func notifyDisplayAchievement(nextAchievement: [StatTracker.EventType : Int], displayInterval: Int) {
        achievementBanner.layer.borderWidth = 2
        achievementBanner.layer.borderColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF7819")).cgColor
        
        let eventType = nextAchievement.keys.first!
        let val = nextAchievement[eventType]!
        
        if eventType == .paintReceived {
            achievementName.text = "Total Paint Accrued"
        }
        else if eventType == .pixelOverwriteIn {
            achievementName.text = "Pixels Overwritten By Others"
        }
        else if eventType == .pixelOverwriteOut {
            achievementName.text = "Pixels Overwritten By Me"
        }
        
        achievementDesc.text = "Passed the " + String(val) + " threshold"
        
        achievementBanner.isHidden = false
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (tmr) in
            DispatchQueue.main.async {
                self.achievementBanner.isHidden = true
            }
        }
    }
}
