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
    let showHowto = "ShowHowto"
    
    @IBOutlet weak var playButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var playButton: ActionButtonView!
    
    @IBOutlet weak var optionsButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var optionsButton: ActionButtonView!
    
    @IBOutlet weak var statsButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var statsButton: ActionButtonView!
    
    @IBOutlet weak var howtoButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var howtoButton: ActionButtonView!
    
    @IBOutlet weak var singleButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var singleButton: ActionButtonView!
    
    @IBOutlet weak var worldButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var worldButton: ActionButtonView!
    
    @IBOutlet weak var devButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var devButton: ActionButtonView!
    
    @IBOutlet weak var leftyButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var leftyButton: ActionButtonView!
    
    @IBOutlet weak var rightyButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var rightyButton: ActionButtonView!
    
    @IBOutlet weak var backAction: ActionButtonView!
    @IBOutlet weak var backActionLeading: NSLayoutConstraint!
    
    @IBOutlet weak var achievementBanner: UIView!
    
    @IBOutlet weak var achievementIcon: AchievementIcon!
    @IBOutlet weak var achievementName: UILabel!
    @IBOutlet weak var achievementDesc: UILabel!
    
    @IBOutlet weak var artView: ArtView!
    @IBOutlet weak var menuContainer: UIView!
    
    var realmId = 0
    
    var showcaseTimer: Timer!
    
    var pixels = [UIView]()
    
    let backgrounds: [(gradient1: Int32, gradient2: Int32)] = [
        (gradient1: Utils.int32FromColorHex(hex: "0xff290a59"), gradient2: Utils.int32FromColorHex(hex: "0xffff7c00")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff942210"), gradient2: Utils.int32FromColorHex(hex: "0xff1f945e")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff0803fa"), gradient2: Utils.int32FromColorHex(hex: "0xfffacf02")),
        (gradient1: Utils.int32FromColorHex(hex: "0xfffa8202"), gradient2: Utils.int32FromColorHex(hex: "0xff18bdfa")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff821794"), gradient2: Utils.int32FromColorHex(hex: "0xff99e046")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff6f46e0"), gradient2: Utils.int32FromColorHex(hex: "0xffe0d121")),
        (gradient1: Utils.int32FromColorHex(hex: "0xffe02819"), gradient2: Utils.int32FromColorHex(hex: "0xffe026d1")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff3b943f"), gradient2: Utils.int32FromColorHex(hex: "0xff4f1fe0")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff242e8f"), gradient2: Utils.int32FromColorHex(hex: "0xff8f3234")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff898f1d"), gradient2: Utils.int32FromColorHex(hex: "0xff158f86"))]
    
    var menuLayer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))
        randomGradientBackground()
        
        menuContainer.layer.cornerRadius = 10
        menuContainer.layer.borderWidth = 1
        menuContainer.layer.borderColor = Utils.UIColorFromColorHex(hex: "0xFF333333").cgColor
        
        playButtonBottomLayer.type = .play
        playButtonBottomLayer.selectable = false
        
        playButton.type = .play
        playButton.topLayer = true
        
        optionsButtonBottomLayer.type = .options
        optionsButtonBottomLayer.selectable = false
        
        optionsButton.type = .options
        optionsButton.topLayer = true
        
        statsButtonBottomLayer.type = .stats
        statsButtonBottomLayer.selectable = false
        
        statsButton.type = .stats
        statsButton.topLayer = true
        
        howtoButtonBottomLayer.type = .howto
        howtoButtonBottomLayer.selectable = false
        
        howtoButton.type = .howto
        howtoButton.topLayer = true
        
        singleButtonBottomLayer.type = .single
        singleButtonBottomLayer.selectable = false
        
        singleButton.type = .single
        singleButton.topLayer = true
        
        worldButtonBottomLayer.type = .world
        worldButtonBottomLayer.selectable = false
        
        worldButton.type = .world
        worldButton.topLayer = true
        
        devButtonBottomLayer.type = .dev
        devButtonBottomLayer.selectable = false
        
        devButton.type = .dev
        devButton.topLayer = true
        
        leftyButtonBottomLayer.type = .lefty
        leftyButtonBottomLayer.selectable = false
        
        leftyButton.type = .lefty
        leftyButton.topLayer = true
        
        rightyButtonBottomLayer.type = .righty
        rightyButtonBottomLayer.selectable = false
        
        rightyButton.type = .righty
        rightyButton.topLayer = true
        
        backAction.type = .backSolid
        
        self.backAction.setOnClickListener {
            if self.menuLayer == 1 {
                self.toggleMenuButtons(show: true, depth: 0)
                self.toggleMenuButtons(show: false, depth: 1)
                
                Animator.animateMenuButtons(views: [[self.playButtonBottomLayer, self.playButton], [self.optionsButtonBottomLayer, self.optionsButton], [self.statsButtonBottomLayer, self.statsButton], [self.howtoButtonBottomLayer, self.howtoButton]], cascade: true, moveOut: false, inverse: false)
                
                self.backAction.isHidden = true
            }
            else if self.menuLayer == 2 {
                self.toggleMenuButtons(show: true, depth: 1)
                self.toggleMenuButtons(show: false, depth: 2)
                
                Animator.animateMenuButtons(views: [[self.singleButtonBottomLayer, self.singleButton], [self.worldButtonBottomLayer, self.worldButton], [self.devButtonBottomLayer, self.devButton]], cascade: true, moveOut: false, inverse: false)
            }
            
            self.menuLayer -= 1
        }
        
        self.playButton.setOnClickListener {
            self.toggleMenuButtons(show: false, depth: 0)
            self.toggleMenuButtons(show: true, depth: 1)
            
            Animator.animateMenuButtons(views: [[self.singleButtonBottomLayer, self.singleButton], [self.worldButtonBottomLayer, self.worldButton], [self.devButtonBottomLayer, self.devButton]], cascade: true, moveOut: false, inverse: false)
            
            self.backAction.isHidden = false
            
            self.menuLayer += 1
        }
        
        self.optionsButton.setOnClickListener {
            self.performSegue(withIdentifier: self.showOptions, sender: nil)
        }
        
        self.statsButton.setOnClickListener {
            self.performSegue(withIdentifier: self.showStats, sender: nil)
        }
        
        self.howtoButton.setOnClickListener {
            self.performSegue(withIdentifier: self.showHowto, sender: nil)
        }
        
        self.singleButton.setOnClickListener {
            self.realmId = 0
            if SessionSettings.instance.selectedHand {
                self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
            }
            else {
                self.showHandButtons()
            }
        }
        
        self.worldButton.setOnClickListener {
            self.realmId = 1
            if SessionSettings.instance.selectedHand {
                self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
            }
            else {
                self.showHandButtons()
            }
        }
        
        self.devButton.setOnClickListener {
            self.realmId = 2
            if SessionSettings.instance.selectedHand {
                self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
            }
            else {
                self.showHandButtons()
            }
        }
        
        leftyButton.setOnClickListener {
            SessionSettings.instance.rightHanded = false
            SessionSettings.instance.selectedHand = true
            
            SessionSettings.instance.quickSave()
            
            if self.realmId == 0 {
                self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
            }
            else {
                self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
            }
        }
        
        rightyButton.setOnClickListener {
            SessionSettings.instance.rightHanded = true
            SessionSettings.instance.selectedHand = true
            
            SessionSettings.instance.quickSave()
            
            if self.realmId == 0 {
                self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
            }
            else {
                self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
            }
        }
        
        StatTracker.instance.achievementListener = self
        
        startShowcase()
    }
    
    override func viewDidLayoutSubviews() {
        let backX = self.backAction.frame.origin.x
        
        if backX < 0 {
            backActionLeading.constant += 30
        }
        
        startPixels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Animator.animateMenuButtons(views: [[self.playButtonBottomLayer, self.playButton], [self.optionsButtonBottomLayer, self.optionsButton], [self.statsButtonBottomLayer, self.statsButton], [self.howtoButtonBottomLayer, self.howtoButton]], cascade: true, moveOut: false, inverse: false)
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
        else if segue.identifier == self.showLoadingScreen {
            let vc = segue.destination as! LoadingViewController
            vc.realmId = realmId
        }
        
        showcaseTimer.invalidate()
        stopPixels()
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        self.toggleMenuButtons(show: true, depth: 0)
        self.toggleMenuButtons(show: false, depth: 1)
        self.toggleMenuButtons(show: false, depth: 2)
        
        Animator.animateMenuButtons(views: [[self.singleButtonBottomLayer, self.singleButton], [self.worldButtonBottomLayer, self.worldButton], [self.devButtonBottomLayer, self.devButton]], cascade: true, moveOut: false, inverse: false)
        
        menuLayer = 0
        self.backAction.isHidden = true
        
        startShowcase()
        
        startPixels()
    }
    
    func randomGradientBackground() {
        var rIndex = Int(arc4random() % UInt32(backgrounds.count))
        
        if SessionSettings.instance.defaultBg {
            rIndex = 8
            
            SessionSettings.instance.defaultBg = false
            SessionSettings.instance.quickSave()
        }
        
        let randBackground = backgrounds[rIndex]
        
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(argb: randBackground.gradient1).cgColor, UIColor(argb: randBackground.gradient2).cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func toggleMenuButtons(show: Bool, depth: Int) {
        if depth == 0 {
            self.playButtonBottomLayer.isHidden = !show
            self.playButton.isHidden = !show
            
            self.optionsButtonBottomLayer.isHidden = !show
            self.optionsButton.isHidden = !show
            
            self.statsButtonBottomLayer.isHidden = !show
            self.statsButton.isHidden = !show
            
            self.howtoButtonBottomLayer.isHidden = !show
            self.howtoButton.isHidden = !show
        }
        else if depth == 1 {
            self.singleButtonBottomLayer.isHidden = !show
            self.singleButton.isHidden = !show
            
            self.worldButtonBottomLayer.isHidden = !show
            self.worldButton.isHidden = !show
            
            self.devButtonBottomLayer.isHidden = true
            self.devButton.isHidden = true
        }
        else if depth == 2 {
            leftyButtonBottomLayer.isHidden = !show
            leftyButton.isHidden = !show
            
            rightyButtonBottomLayer.isHidden = !show
            rightyButton.isHidden = !show
        }
    }
    
    func showHandButtons() {
        toggleMenuButtons(show: false, depth: 1)
        toggleMenuButtons(show: true, depth: 2)
        
        Animator.animateMenuButtons(views: [[leftyButtonBottomLayer, leftyButton], [rightyButtonBottomLayer, rightyButton]], cascade: true, moveOut: false, inverse: false)
        
        menuLayer += 1
    }
    
    func startShowcase() {
        if (SessionSettings.instance.artShowcase == nil) {
            SessionSettings.instance.defaultArtShowcase()
        }
        
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
    func notifyDisplayAchievement(nextAchievement: [String : Any], displayInterval: Int) {
        achievementBanner.layer.borderWidth = 2
        achievementBanner.layer.borderColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF7819")).cgColor
        
        let eventType = nextAchievement["event_type"] as! StatTracker.EventType
        let value = nextAchievement["threshold"] as! Int
        let thresholdsPassed = nextAchievement["thresholds_passed"] as! Int
        
        if eventType == .paintReceived {
            achievementName.text = "Total Paint Accrued"
        }
        else if eventType == .pixelOverwriteIn {
            achievementName.text = "Pixels Overwritten By Others"
        }
        else if eventType == .pixelOverwriteOut {
            achievementName.text = "Pixels Overwritten By Me"
        }
        else if eventType == .pixelPaintedWorld {
            achievementName.text = "Pixels Painted World"
        }
        else if eventType == .pixelPaintedSingle {
            achievementName.text = "Pixels Painted Single"
        }
        else if eventType == .worldXp {
            achievementName.text = "World XP"
        }
        
        if eventType != .worldXp {
            achievementDesc.text = "Passed the " + String(value) + " threshold"
        }
        else {
            achievementDesc.text = "Congrats on reaching level " + String(StatTracker.instance.getWorldLevel())
        }
        
        achievementBanner.isHidden = false
        achievementBanner.layer.borderWidth = 1
        achievementBanner.layer.borderColor = UIColor.black.cgColor
        
        achievementIcon.setType(achievementType: eventType, thresholds: thresholdsPassed)
        
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
    
    func deviceName() -> String {

        var systemInfo = utsname()
        uname(&systemInfo)

        guard let iOSDeviceModelsPath = Bundle.main.path(forResource: "iOSDeviceModelMapping", ofType: "plist") else { return "" }
        guard let iOSDevices = NSDictionary(contentsOfFile: iOSDeviceModelsPath) else { return "" }

        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        return iOSDevices.value(forKey: identifier) as! String
    }
}
