//
//  MenuViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/12/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol MenuButtonDelegate: AnyObject {
    func menuButtonPressed(menuButtonType: MenuButtonType)
}

enum MenuButtonType {
    case options
    case howto
    case lefty
    case righty
}

class MenuViewController: UIViewController, AchievementListener {

    let showSinglePlay = "ShowSinglePlay"
    let showLoadingScreen = "ShowLoading"
    let showStats = "ShowStats"
    let showOptions = "ShowOptions"
    let showHowto = "ShowHowto"
    
    @IBOutlet weak var optionsLabel: UILabel!
    
    @IBOutlet weak var howtoLabel: UILabel!
    
    @IBOutlet weak var singleButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var singleButton: ActionButtonView!
    
    @IBOutlet weak var worldButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var worldButton: ActionButtonView!
    
    @IBOutlet weak var devButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var devButton: ActionButtonView!
    
    @IBOutlet weak var leftyLabel: UILabel!
    
    @IBOutlet weak var rightyLabel: UILabel!
    
    @IBOutlet weak var backAction: ActionButtonView!
    @IBOutlet weak var backActionLeading: NSLayoutConstraint!
    
    @IBOutlet weak var achievementBanner: UIView!
    
    @IBOutlet weak var achievementIcon: AchievementIcon!
    @IBOutlet weak var achievementName: UILabel!
    @IBOutlet weak var achievementDesc: UILabel!
    
    @IBOutlet weak var artView: ArtView!
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var menuContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var menuContainerHeight: NSLayoutConstraint!
    
    weak var menuButtonDelegate: MenuButtonDelegate?
    
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
        (gradient1: Utils.int32FromColorHex(hex: "0xff3b943f"), gradient2: Utils.int32FromColorHex(hex: "0xff4f1fe0")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff242e8f"), gradient2: Utils.int32FromColorHex(hex: "0xff8f3234")),
        (gradient1: Utils.int32FromColorHex(hex: "0xff898f1d"), gradient2: Utils.int32FromColorHex(hex: "0xff158f86"))]
    
    var cBackgroundGradientIndex = 0
    var insertedSublayer = false
    
    var menuLayer = 0
    
    var defaultLabelColor: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))
        randomGradientBackground()
        
        //defaultLabelColor = drawLabel.textColor.argb()
        defaultLabelColor = optionsLabel.textColor.argb()
        
        /*menuContainer.layer.cornerRadius = 10
        menuContainer.layer.borderWidth = 1
        menuContainer.layer.borderColor = Utils.UIColorFromColorHex(hex: "0xFF333333").cgColor*/
        
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
        
        backAction.type = .backSolid
        
        self.backAction.setOnClickListener {
            if self.menuLayer == 1 {
                self.toggleMenuButtons(show: true, depth: 0)
                self.toggleMenuButtons(show: false, depth: 1)
                
                Animator.animateMenuButtons(views: [[self.optionsLabel], [self.howtoLabel]], cascade: true, moveOut: false, inverse: false)
                
                self.backAction.isHidden = true
            }
            else if self.menuLayer == 2 {
                self.toggleMenuButtons(show: true, depth: 1)
                self.toggleMenuButtons(show: false, depth: 2)
                
                Animator.animateMenuButtons(views: [[self.singleButtonBottomLayer, self.singleButton], [self.worldButtonBottomLayer, self.worldButton], [self.devButtonBottomLayer, self.devButton]], cascade: true, moveOut: false, inverse: false)
            }
            
            self.menuLayer -= 1
        }
        
        //var touchGr = UITouchGestureRecognizer(target: self, action: #selector(drawLabelTouched(sender:)))
        //drawLabel.addGestureRecognizer(touchGr)
        
        var touchGr = UITouchGestureRecognizer(target: self, action: #selector(optionsLabelTouched(sender:)))
        optionsLabel.addGestureRecognizer(touchGr)
        
        touchGr = UITouchGestureRecognizer(target: self, action: #selector(howtoLabelTouched(sender:)))
        howtoLabel.addGestureRecognizer(touchGr)
        
        touchGr = UITouchGestureRecognizer(target: self, action: #selector(leftyLabelTouched(sender:)))
        leftyLabel.addGestureRecognizer(touchGr)
        
        touchGr = UITouchGestureRecognizer(target: self, action: #selector(rightyLabelTouched(sender:)))
        rightyLabel.addGestureRecognizer(touchGr)
        
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
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Animator.animateMenuButtons(views: [[self.optionsLabel], [self.howtoLabel]], cascade: true, moveOut: false, inverse: false)
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        /*if SessionSettings.instance.canvasOpen {
            self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
        }*/
        
        if !SessionSettings.instance.selectedHand {
            self.showHandButtons()
        }
        else {
            self.showMenuButtons()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view!.backgroundColor = UIColor.black
        view.setNeedsDisplay()
        artView.setNeedsDisplay()
        
        /*setGradient(bounds: CGRect(x: 0, y: 0, width: size.width, height: size.height), index: cBackgroundGradientIndex)*/
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
        
    }
    
    func highlightLabel(label: UILabel) {
        label.textColor = UIColor(argb: ActionButtonView.altGreenColor)
    }
    
    func unhighlightLabel(label: UILabel) {
        label.textColor = UIColor(argb: defaultLabelColor)
    }
    
    // menu gestures
    func drawLabelTapped() {
        self.realmId = 0
        if SessionSettings.instance.selectedHand {
            self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
        }
        else {
            self.showHandButtons()
        }
    }
    
    /*@objc func drawLabelTouched(sender: UITouchGestureRecognizer) {
        if (sender.state == .began) {
            highlightLabel(label: drawLabel)
        }
        else if (sender.state == .ended) {
            unhighlightLabel(label: drawLabel)
            drawLabelTapped()
        }
    }*/
    
    func optionsLabelTapped() {
        //self.performSegue(withIdentifier: self.showOptions, sender: nil)
        menuButtonDelegate?.menuButtonPressed(menuButtonType: .options)
    }
    
    @objc func optionsLabelTouched(sender: UITouchGestureRecognizer) {
        if (sender.state == .began) {
            highlightLabel(label: optionsLabel)
        }
        else if (sender.state == .ended) {
            unhighlightLabel(label: optionsLabel)
            optionsLabelTapped()
        }
    }
    
    func howtoLabelTapped() {
        //self.performSegue(withIdentifier: self.showHowto, sender: nil)
        menuButtonDelegate?.menuButtonPressed(menuButtonType: .howto)
    }
    
    @objc func howtoLabelTouched(sender: UITouchGestureRecognizer) {
        if (sender.state == .began) {
            highlightLabel(label: howtoLabel)
        }
        else if (sender.state == .ended) {
            unhighlightLabel(label: howtoLabel)
            howtoLabelTapped()
        }
    }
    
    func leftyLabelTapped() {
        SessionSettings.instance.rightHanded = false
        SessionSettings.instance.selectedHand = true
        
        //SessionSettings.instance.quickSave()
        
        /*if self.realmId == 0 {
            self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
        }
        else {
            self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
        }*/
        menuButtonDelegate?.menuButtonPressed(menuButtonType: .lefty)
    }
    
    @objc func leftyLabelTouched(sender: UITouchGestureRecognizer) {
        if (sender.state == .began) {
            highlightLabel(label: leftyLabel)
        }
        else if (sender.state == .ended) {
            unhighlightLabel(label: leftyLabel)
            leftyLabelTapped()
        }
    }
    
    func rightyLabelTapped() {
        SessionSettings.instance.rightHanded = true
        SessionSettings.instance.selectedHand = true
        
        //SessionSettings.instance.quickSave()
        
        /*if self.realmId == 0 {
            self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
        }
        else {
            self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
        }*/
        menuButtonDelegate?.menuButtonPressed(menuButtonType: .righty)
    }
    
    @objc func rightyLabelTouched(sender: UITouchGestureRecognizer) {
        if (sender.state == .began) {
            highlightLabel(label: rightyLabel)
        }
        else if (sender.state == .ended) {
            unhighlightLabel(label: rightyLabel)
            rightyLabelTapped()
        }
    }
    
    func randomGradientBackground() {
        var rIndex = Int(arc4random() % UInt32(backgrounds.count))
        
        if SessionSettings.instance.defaultBg {
            rIndex = 8
            
            SessionSettings.instance.defaultBg = false
            //SessionSettings.instance.quickSave()
        }
        
        cBackgroundGradientIndex = rIndex
        
        setGradient(bounds: CGRect(x: 0, y: 0, width: 500, height: 300), index: rIndex)
    }
    
    func setGradient(bounds: CGRect, index: Int) {
        let background = backgrounds[index]
        
        let gradient = CAGradientLayer()

        gradient.frame = bounds
        gradient.colors = [UIColor(argb: background.gradient1).cgColor, UIColor(argb: background.gradient2).cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)

        if insertedSublayer {
            view.layer.sublayers![0].removeFromSuperlayer()
        }
        view.layer.insertSublayer(gradient, at: 0)
        insertedSublayer = true
    }
    
    func toggleMenuButtons(show: Bool, depth: Int) {
        if depth == 0 {
            //self.drawLabel.isHidden = !show
            
            self.optionsLabel.isHidden = !show
            
            self.howtoLabel.isHidden = !show
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
            leftyLabel.isHidden = !show
            rightyLabel.isHidden = !show
        }
    }
    
    func showMenuButtons() {
        toggleMenuButtons(show: true, depth: 0)
        
        Animator.animateMenuButtons(views: [[optionsLabel], [howtoLabel]], cascade: true, moveOut: false, inverse: false)
        
        menuLayer += 2
    }
    
    func showHandButtons() {
        toggleMenuButtons(show: false, depth: 0)
        toggleMenuButtons(show: true, depth: 2)
        
        Animator.animateMenuButtons(views: [[leftyLabel], [rightyLabel]], cascade: true, moveOut: false, inverse: false)
        
        menuLayer += 2
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
