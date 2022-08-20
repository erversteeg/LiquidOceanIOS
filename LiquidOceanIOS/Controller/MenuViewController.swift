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

class MenuViewController: UIViewController, AchievementListener, UICollectionViewDataSource,
                            UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    let showSinglePlay = "ShowSinglePlay"
    let showLoadingScreen = "ShowLoading"
    let showStats = "ShowStats"
    let showOptions = "ShowOptions"
    let showHowto = "ShowHowto"
    
    @IBOutlet weak var connectButton: ButtonFrame?
    @IBOutlet weak var optionsButton: ButtonFrame!
    @IBOutlet weak var howtoButton: ButtonFrame!
    
    @IBOutlet weak var singleButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var singleButton: ActionButtonView!
    
    @IBOutlet weak var worldButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var worldButton: ActionButtonView!
    
    @IBOutlet weak var devButtonBottomLayer: ActionButtonView!
    @IBOutlet weak var devButton: ActionButtonView!
    
    @IBOutlet weak var leftyButton: ButtonFrame!
    @IBOutlet weak var rightyButton: ButtonFrame!
    
    @IBOutlet weak var backButton: ButtonFrame?
    @IBOutlet weak var backActionLeading: NSLayoutConstraint!
    @IBOutlet weak var addButton: ButtonFrame?
    @IBOutlet weak var menuButton: ButtonFrame?
    
    @IBOutlet weak var achievementBanner: UIView!
    
    @IBOutlet weak var achievementIcon: AchievementIcon!
    @IBOutlet weak var achievementName: UILabel!
    @IBOutlet weak var achievementDesc: UILabel!
    
    @IBOutlet weak var artView: ArtView!
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var menuContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var menuContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var serversCollectionView: UICollectionView!
    
    @IBOutlet weak var addServerContainer: UIView!
    
    @IBOutlet weak var accessKeyTextField: UITextField!
    
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
    
    var fromInteractiveCanvas = false
    
    var selectedServer: Server!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        URLSessionHandler.instance.findServer(accessKey: "TEST1") { success, server in
//            if server != nil {
//                print(server!.name)
//                if !SessionSettings.instance.hasServer(accessKey: "TEST1") {
//                    SessionSettings.instance.addServer(server: server!)
//                }
//            }
//        }
        
        // self.view.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))
        randomGradientBackground()
        
        //defaultLabelColor = drawLabel.textColor.argb()
        //defaultLabelColor = optionsLabel.textColor.argb()
        
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
        
        self.backButton?.setOnClickListener {
            self.backButtonClicked()
        }
        
        if addButton != nil {
            self.addButton!.setOnClickListener {
                self.showAddServerView()
            }
        }
        
        if menuButton != nil {
            self.menuButton!.setOnClickListener {
                self.showConnectView()
            }
        }
        
        //var touchGr = UITouchGestureRecognizer(target: self, action: #selector(drawLabelTouched(sender:)))
        //drawLabel.addGestureRecognizer(touchGr)
        
        connectButton?.setOnClickListener {
            self.connectLabelTapped()
        }
        
        optionsButton?.setOnClickListener {
            self.optionsLabelTapped()
        }
        
        howtoButton?.setOnClickListener {
            self.howtoLabelTapped()
        }

        leftyButton?.setOnClickListener {
            self.leftyLabelTapped()
        }
        
        rightyButton?.setOnClickListener {
            self.rightyLabelTapped()
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
        
        StatTracker.instance.achievementListener = self
        
        startShowcase()
    }
    
    func backButtonClicked() {
        if !self.addServerContainer.isHidden || !self.serversCollectionView.isHidden {
            self.addServerContainer.isHidden = true
            self.serversCollectionView.isHidden = true
            
            self.toggleMenuButtons(show: true, depth: 0)
            self.backButton!.isHidden = true
            self.addButton!.isHidden = true
            self.menuButton!.isHidden = false
        }
        else if self.menuLayer == 1 {
            self.toggleMenuButtons(show: true, depth: 0)
            self.toggleMenuButtons(show: false, depth: 1)
            
            if self.connectButton != nil {
                Animator.animateMenuButtons(views: [[self.connectButton!], [self.optionsButton], [self.howtoButton]], cascade: true, moveOut: false, inverse: false)
            }
            else {
                Animator.animateMenuButtons(views: [[self.optionsButton], [self.howtoButton]], cascade: true, moveOut: false, inverse: false)
            }
            
            self.backButton!.isHidden = true
        }
        else if self.menuLayer == 2 {
            self.toggleMenuButtons(show: true, depth: 1)
            self.toggleMenuButtons(show: false, depth: 2)
            
            Animator.animateMenuButtons(views: [[self.singleButtonBottomLayer, self.singleButton], [self.worldButtonBottomLayer, self.worldButton], [self.devButtonBottomLayer, self.devButton]], cascade: true, moveOut: false, inverse: false)
        }
        
        self.menuLayer -= 1
    }
    
    override func viewDidLayoutSubviews() {
        let backX = self.backButton?.frame.origin.x
        
        if backX != nil && backX! < 0 {
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
            vc.server = selectedServer
        }
        
        showcaseTimer.invalidate()
        stopPixels()
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
    
    func connectLabelTapped() {
        let lastVisitedServer = SessionSettings.instance.lastVisitedServer
        if lastVisitedServer != nil {
            self.selectedServer = lastVisitedServer
            self.performSegue(withIdentifier: showLoadingScreen, sender: nil)
            return
        }
        showConnectView()
    }
    
    func showConnectView() {
        toggleMenuButtons(show: false, depth: 0)
        addButton!.isHidden = false
        menuButton!.isHidden = true
        serversCollectionView.isHidden = true
        addServerContainer.isHidden = true
        
        backButton!.isHidden = false
        
        if SessionSettings.instance.servers.count == 0 {
            addButton?.isHidden = true
            addServerContainer.isHidden = false
        }
        else {
            addButton!.isHidden = false
            
            serversCollectionView.isHidden = false
            serversCollectionView.reloadData()
        }
    }
    
    func showAddServerView() {
        toggleMenuButtons(show: false, depth: 0)
        serversCollectionView.isHidden = true
        
        addButton!.isHidden = true
        backButton!.isHidden = false
        
        addServerContainer.isHidden = false
    }
    
    func optionsLabelTapped() {
        //self.performSegue(withIdentifier: self.showOptions, sender: nil)
        if fromInteractiveCanvas {
            menuButtonDelegate?.menuButtonPressed(menuButtonType: .options)
        }
        else {
            self.performSegue(withIdentifier: showOptions, sender: nil)
        }
    }
    
    func howtoLabelTapped() {
        //self.performSegue(withIdentifier: self.showHowto, sender: nil)
        if fromInteractiveCanvas {
            menuButtonDelegate?.menuButtonPressed(menuButtonType: .howto)
        }
        else {
            self.performSegue(withIdentifier: showHowto, sender: nil)
        }
    }
    
    func leftyLabelTapped() {
        SessionSettings.instance.rightHanded = false
        SessionSettings.instance.selectedHand = true
        
        self.showMenuButtons()
        
        //SessionSettings.instance.quickSave()
        
        /*if self.realmId == 0 {
            self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
        }
        else {
            self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
        }*/
        //menuButtonDelegate?.menuButtonPressed(menuButtonType: .lefty)
    }
    
    func rightyLabelTapped() {
        SessionSettings.instance.rightHanded = true
        SessionSettings.instance.selectedHand = true
        
        self.showMenuButtons()
        
        //SessionSettings.instance.quickSave()
        
        /*if self.realmId == 0 {
            self.performSegue(withIdentifier: self.showSinglePlay, sender: nil)
        }
        else {
            self.performSegue(withIdentifier: self.showLoadingScreen, sender: nil)
        }*/
        //menuButtonDelegate?.menuButtonPressed(menuButtonType: .righty)
    }
    
    func randomGradientBackground() {
        var rIndex = Int(arc4random() % UInt32(backgrounds.count))
        
        if SessionSettings.instance.defaultBg {
            rIndex = 8
            
            SessionSettings.instance.defaultBg = false
            //SessionSettings.instance.quickSave()
        }
        
        cBackgroundGradientIndex = rIndex
        
        if fromInteractiveCanvas {
            setGradient(bounds: CGRect(x: 0, y: 0, width: 500, height: 300), index: rIndex)
        }
        else {
            setGradient(bounds: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), index: rIndex)
        }
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
            
            self.connectButton?.isHidden = !show
            
            self.optionsButton.isHidden = !show
            
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
            leftyButton?.isHidden = !show
            rightyButton?.isHidden = !show
        }
    }
    
    func showMenuButtons() {
        toggleMenuButtons(show: true, depth: 0)
        toggleMenuButtons(show: false, depth: 2)
        
        Animator.animateMenuButtons(views: [[optionsButton], [howtoButton]], cascade: true, moveOut: false, inverse: false)
        
        menuLayer += 2
    }
    
    func showHandButtons() {
        menuButton?.isHidden = true
        
        toggleMenuButtons(show: false, depth: 0)
        toggleMenuButtons(show: true, depth: 2)
        
        Animator.animateMenuButtons(views: [[leftyButton], [rightyButton]], cascade: true, moveOut: false, inverse: false)
        
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
    
    // servers colleciton data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SessionSettings.instance.servers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServerCell", for: indexPath) as! ServerCell
        
        let server = SessionSettings.instance.servers[indexPath.item]
        
        if server.isAdmin {
            cell.nameLabel.text = "\(server.name) Eraser"
        }
        else {
            cell.nameLabel.text = server.name
        }
        
        let lgr = ServerLongPressGestureRecognizer(target: self, action: #selector(didLongPressCell))
        lgr.server = server
        
        cell.addGestureRecognizer(lgr)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 260, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedServer = SessionSettings.instance.servers[indexPath.item]
        self.performSegue(withIdentifier: showLoadingScreen, sender: nil)
        self.backButtonClicked()
    }
    
    @IBAction func addServer() {
        let accessKey = accessKeyTextField.text!
        
        if accessKey.count != 5 && accessKey.count != 8 || SessionSettings.instance.hasServer(accessKey: accessKey) {
            return
        }
    
        URLSessionHandler.instance.findServer(accessKey: accessKey) { success, code, server in
            if server != nil {
                print(server!.name)
                SessionSettings.instance.addServer(server: server!)
                
                self.showConnectView()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func didLongPressCell(sender: ServerLongPressGestureRecognizer) {
        if (sender.state == .began) {
            let server = sender.server!
            
            let alertController = UIAlertController(title: "Delete", message: "Delete \(server.name)?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
                SessionSettings.instance.removeServer(server: server)
                self.serversCollectionView.reloadData()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                alertController.dismiss(animated: true, completion: nil)
            }))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    class ServerLongPressGestureRecognizer: UILongPressGestureRecognizer {
        var server: Server!
    }
}
