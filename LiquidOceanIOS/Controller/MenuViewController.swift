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
    let showOptions = "ShowOptions"
    
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
    
    @IBOutlet weak var artView: ArtView!
    @IBOutlet weak var menuContainer: UIView!
    
    var showcaseTimer: Timer!
    
    var pixels = [UIView]()
    
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
                
                Animator.animateMenuButtons(views: [self.playButton, self.optionsButton, self.statsButton, self.exitButton], initial: false, moveOut: false)
                
                self.backAction.isHidden = true
            }
        }
        
        self.playButton.setOnClickListener {
            self.toggleMenuButtons(show: false, depth: 0)
            self.toggleMenuButtons(show: true, depth: 1)
            
            Animator.animateMenuButtons(views: [self.singleAction, self.worldAction], initial: false, moveOut: false)
            
            self.backAction.isHidden = false
        }
        
        self.optionsButton.setOnClickListener {
            self.performSegue(withIdentifier: self.showOptions, sender: nil)
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
        
        startShowcase()
        
        startPixels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Animator.animateMenuButtons(views: [self.playButton, self.optionsButton, self.statsButton, self.exitButton], initial: true, moveOut: false)
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
        
        showcaseTimer.invalidate()
        stopPixels()
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        self.toggleMenuButtons(show: true, depth: 0)
        self.toggleMenuButtons(show: false, depth: 1)
        
        self.backAction.isHidden = true
        
        startShowcase()
        
        startPixels()
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
    
    func startShowcase() {
        showcaseTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: { (tmr) in
            DispatchQueue.main.async {
                if SessionSettings.instance.artShowcase != nil {
                    self.artView.alpha = 0
                    
                    self.artView.showBackground = false
                    self.artView.art = self.getNextArtShowcase()
                    
                    UIView.animate(withDuration: 2.5, animations: {
                        self.artView.alpha = 1
                    }) { (success) in
                        if success {
                            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (tmr) in
                                UIView.animate(withDuration: 1.5, animations: {
                                    self.artView.alpha = 0
                                })
                            }
                        }
                    }
                }
            }
        })
        showcaseTimer.fire()
    }
    
    func startPixels() {
        Animator.context = self
        
        if self.pixels.count == 0 {
            for _ in 0...6 {
                let newView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
                self.pixels.append(newView)
                self.view.addSubview(newView)
            }
        }
        
        for i in 0...6 {
            Animator.animatePixelColorEffect(view:self.pixels[i], parent: self.view, safeViews: [artView, menuContainer])
        }
    }
    
    func stopPixels() {
        Animator.context = nil
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
    
    func getNextArtShowcase() -> [InteractiveCanvas.RestorePoint]? {
        if let artShowcase = SessionSettings.instance.artShowcase {
            if SessionSettings.instance.showcaseIndex == artShowcase.count {
                SessionSettings.instance.showcaseIndex = 0
            }
            
            if artShowcase.count > 0 {
                let nextArt = artShowcase[SessionSettings.instance.showcaseIndex]
                SessionSettings.instance.showcaseIndex += 1
                
                return nextArt
            }
        }
        
        return nil
    }
}
