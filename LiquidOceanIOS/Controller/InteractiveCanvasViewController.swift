//
//  ViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import FlexColorPicker

class InteractiveCanvasViewController: UIViewController, InteractiveCanvasPaintDelegate, ColorPickerDelegate, InteractiveCanvasPixelHistoryDelegate, InteractiveCanvasRecentColorsDelegate, RecentColorsDelegate, ExportViewControllerDelegate, InteractiveCanvasArtExportDelegate, AchievementListener, InteractiveCanvasSocketStatusDelegate {
    
    @IBOutlet var surfaceView: InteractiveCanvasView!
    
    @IBOutlet var paintPanel: UIView!
    
    @IBOutlet weak var paintPanelButton: ActionButtonView!
    @IBOutlet weak var closePaintPanelButton: ActionButtonView!
    
    @IBOutlet weak var colorPickerFrame: UIView!
    
    @IBOutlet weak var paintColorIndicator: PaintColorIndicator!
    
    
    @IBOutlet weak var paintPanelWidth: NSLayoutConstraint!
    @IBOutlet weak var colorPickerFrameWidth: NSLayoutConstraint!
    
    @IBOutlet weak var paintColorAccept: ActionButtonView!
    @IBOutlet weak var paintColorCancel: ActionButtonView!
    
    @IBOutlet weak var paintYes: ActionButtonView!
    @IBOutlet weak var paintNo: ActionButtonView!
    
    @IBOutlet weak var paintQuantityBar: PaintQuantityBar!
    
    @IBOutlet weak var backButton: ActionButtonView!
    
    @IBOutlet weak var exportAction: ActionButtonView!
    @IBOutlet weak var changeBackgroundAction: ActionButtonView!
    
    @IBOutlet weak var toolboxButton: ActionButtonFrame!
    @IBOutlet weak var toolboxActionView: ActionButtonView!
    
    @IBOutlet weak var recentColorsButton: ActionButtonFrame!
    @IBOutlet weak var recentColorsActionView: ActionButtonView!
    @IBOutlet weak var recentColorsContainer: UIView!
    
    @IBOutlet weak var pixelHistoryView: UIView!
    
    @IBOutlet weak var recentColorsContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var recentColorsContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var exportContainer: UIView!
    
    @IBOutlet weak var achievementBanner: UIView!
    
    @IBOutlet weak var achievementIcon: UIView!
    @IBOutlet weak var achievementName: UILabel!
    @IBOutlet weak var achievementDesc: UILabel!
    
    @IBOutlet weak var paintEventInfoContainer: UIView!
    @IBOutlet weak var paintEventTimeLabel: UILabel!
    
    
    var world = false
    
    var statusCheckTimer: Timer!
    
    var previousColor: Int32!
    
    var pixelHistoryViewController: PixelHistoryViewController!
    weak var recentColorsViewController: RecentColorsViewController!
    weak var exportViewController: ExportViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surfaceView.interactiveCanvas.world = world
        paintQuantityBar.world = world
        
        surfaceView.setInitalScale()
        
        SessionSettings.instance.interactiveCanvas = self.surfaceView.interactiveCanvas
        
        SessionSettings.instance.darkIcons = (SessionSettings.instance.backgroundColorIndex == 1 || SessionSettings.instance.backgroundColorIndex == 3)
        
        self.surfaceView.interactiveCanvas.paintDelegate = self
        self.surfaceView.interactiveCanvas.pixelHistoryDelegate = self
        self.surfaceView.interactiveCanvas.recentColorsDelegate = self
        self.surfaceView.interactiveCanvas.artExportDelegate = self
        
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: self.view.frame.size.height))
        if SessionSettings.instance.panelBackgroundName == "" {
            backgroundImage.image = UIImage(named: "wood_texture_light.jpg")
        }
        else {
            backgroundImage.image = UIImage(named: SessionSettings.instance.panelBackgroundName)
        }
        
        backgroundImage.contentMode = .scaleToFill
        
        // back button
        self.backButton.type = .back
        self.backButton.setOnClickListener {
            if !self.surfaceView.isExporting() {
                self.surfaceView.interactiveCanvas.save()
                
                 self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
            }
            else {
                self.exportAction.selected = false
                self.surfaceView.endExporting()
            }
        }
        
        self.paintPanelWidth.constant = 0
        self.colorPickerFrameWidth.constant = 0
        
        self.paintPanel.insertSubview(backgroundImage, at: 0)
        
        toggleToolbox(open: false)
        
        // action buttons
        self.paintPanelButton.type = .paint
        self.closePaintPanelButton.type = .closePaint
        self.exportAction.type = .export
        self.changeBackgroundAction.type = .changeBackground
        
        // toolbox
        self.toolboxActionView.type = .dot
        self.toolboxButton.actionButtonView = self.toolboxActionView
        
        self.toolboxButton.setOnClickListener {
            self.toggleToolbox(open: self.exportAction.isHidden)
        }
        
        // recent colors
        self.recentColorsActionView.type = .dot
        self.recentColorsButton.actionButtonView = self.recentColorsActionView
        
        self.recentColorsButton.setOnClickListener {
            self.toggleRecentColors(open: self.recentColorsContainer.isHidden)
        }
        
        self.setupRecentColors(recentColors: self.surfaceView.interactiveCanvas.recentColors)
        
        // export
        self.exportAction.setOnClickListener {
            self.surfaceView.startExporting()
            self.exportAction.selected = true
        }
        
        // change background
        self.changeBackgroundAction.setOnClickListener {
            SessionSettings.instance.backgroundColorIndex += 1
            if SessionSettings.instance.backgroundColorIndex == self.surfaceView.interactiveCanvas.numBackgrounds {
                SessionSettings.instance.backgroundColorIndex = 0
            }
            
            SessionSettings.instance.darkIcons = (SessionSettings.instance.backgroundColorIndex == 1 || SessionSettings.instance.backgroundColorIndex == 3)
            
            self.exportAction.setNeedsDisplay()
            self.changeBackgroundAction.setNeedsDisplay()
            self.paintPanelButton.setNeedsDisplay()
            self.backButton.setNeedsDisplay()
            
            SessionSettings.instance.save()
            
            self.surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        }
        
        // paint panel
        self.paintPanel.isHidden = true
        self.paintPanelButton.setOnClickListener {
            self.paintPanelWidth.constant = 200
            self.paintPanel.isHidden = false
            
            self.pixelHistoryView.isHidden = true
            
            self.backButton.isHidden = true
            self.recentColorsButton.isHidden = false
            
            self.surfaceView.startPainting()
        }
        
        // close paint panel
        self.closePaintPanelButton.setOnClickListener {
            self.surfaceView.endPainting(accept: false)
            
            self.paintPanelWidth.constant = 0
            self.paintPanel.isHidden = true
            
            self.backButton.isHidden = false
            
            self.recentColorsButton.isHidden = true
            
            self.toggleRecentColors(open: false)
        }
        
        // paint quantity bar
        SessionSettings.instance.paintQtyDelegates.append(self.paintQuantityBar)
        
        let paintIndicatorTap = UITapGestureRecognizer(target: self, action: #selector(didTapColorIndicator(sender:)))
        self.paintColorIndicator.addGestureRecognizer(paintIndicatorTap)
        
        self.paintColorAccept.type = .paintSelectYes
        self.paintColorCancel.type = .paintSelectCancel
        
        self.paintColorAccept.isHidden = true
        self.paintColorCancel.isHidden = true
        
        // paint selection accept
        self.paintColorAccept.setOnClickListener {
            self.closeColorPicker()
            
            if self.surfaceView.interactiveCanvas.restorePoints.count == 0 {
                self.closePaintPanelButton.isHidden = false
                
                self.paintYes.isHidden = true
                self.paintNo.isHidden = true
            }
            else {
                self.closePaintPanelButton.isHidden = true
                
                self.paintYes.isHidden = false
                self.paintNo.isHidden = false
            }
            
            self.recentColorsButton.isHidden = false
            
            self.surfaceView.endPaintSelection()
        }
        
        // paint selection cancel
        self.paintColorCancel.setOnClickListener {
            self.paintColorIndicator.setPaintColor(color: self.previousColor)
            
            if self.surfaceView.interactiveCanvas.restorePoints.count == 0 {
                self.closePaintPanelButton.isHidden = false
                
                self.paintYes.isHidden = true
                self.paintNo.isHidden = true
            }
            else {
                self.closePaintPanelButton.isHidden = true
                
                self.paintYes.isHidden = false
                self.paintNo.isHidden = false
            }
            
            self.closeColorPicker()
            
            self.recentColorsButton.isHidden = false
            
            self.surfaceView.endPaintSelection()
        }
        
        self.paintYes.type = .yes
        self.paintNo.type = .no
        
        self.paintYes.isHidden = true
        self.paintNo.isHidden = true
        
        // paint yes
        self.paintYes.setOnClickListener {
            self.surfaceView.endPainting(accept: true)
            
            self.paintYes.isHidden = true
            self.paintNo.isHidden = true
            self.closePaintPanelButton.isHidden = false
            
            self.surfaceView.startPainting()
        }
        
        // paint no
        self.paintNo.setOnClickListener {
            self.surfaceView.endPainting(accept: false)
            
            self.paintYes.isHidden = true
            self.paintNo.isHidden = true
            self.closePaintPanelButton.isHidden = false
            
            self.surfaceView.startPainting()
        }
        
        // paint event time toggle
        let tgr = UITapGestureRecognizer(target: self, action: #selector(didTapPaintQuantityBar))
        self.paintQuantityBar.addGestureRecognizer(tgr)
        
        StatTracker.instance.achievementListener = self
        
        surfaceView.interactiveCanvas.socketStatusDelegate = self
        startServerStatusChecks()
        
        getPaintTimerInfo()
    }
    
    @objc func didTapPaintQuantityBar() {
        paintEventInfoContainer.isHidden = !paintEventInfoContainer.isHidden
    }
    
    func startServerStatusChecks() {
        statusCheckTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (tmr) in
            let connected = Utils.isNetworkAvailable()
            if !connected {
                DispatchQueue.main.async {
                    self.showDisconnectedMessage(type: 0)
                }
            }
            else {
                URLSessionHandler.instance.sendApiStatusCheck { (success) -> (Void) in
                    if !success {
                        self.showDisconnectedMessage(type: 1)
                    }
                    else {
                        self.surfaceView.interactiveCanvas.sendSocketStatusCheck()
                    }
                }
            }
        })
    }
    
    func showDisconnectedMessage(type: Int) {
        // create the alert
        let alert = UIAlertController(title: nil, message: "Lost connection to world server (code=" + String(type) + ")", preferredStyle: UIAlertController.Style.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func getPaintTimerInfo() {
        self.paintEventInfoContainer.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF303030"))
        self.paintEventInfoContainer.layer.cornerRadius = 20
        
        URLSessionHandler.instance.getPaintTimerInfo { (success, nextPaintTime) -> (Void) in
            if success {
                var ts = Int(nextPaintTime)
                let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (tmr) in
                    ts -= 1
                    
                    if ts == 0 {
                        ts = 300
                    }
                    
                    let m = ts / 60
                    let s = ts % 60
                    
                    self.paintEventTimeLabel.text = String(format: "%d:%d", m, s)
                }
                timer.fire()
            }
        }
    }
    
    // embeds
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ColorPickerEmbed" {
            let colorPickerViewController = segue.destination as! CustomColorPickerViewController
            colorPickerViewController.delegate = self
            colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.paintColor)
            colorPickerViewController.view.backgroundColor = UIColor.clear
        }
        else if segue.identifier == "PixelHistoryEmbed" {
            segue.destination.modalPresentationStyle = .overCurrentContext
            self.pixelHistoryViewController = segue.destination as? PixelHistoryViewController
        }
        else if segue.identifier == "RecentColorsEmbed" {
            self.recentColorsViewController = segue.destination as? RecentColorsViewController
            self.recentColorsViewController.delegate = self
        }
        else if segue.identifier == "ExportEmbed" {
            self.exportViewController = segue.destination as? ExportViewController
            self.exportViewController.delegate = self
        }
        else if segue.identifier == "UnwindToMenu" {
            StatTracker.instance.achievementListener = nil
        }
    }
    
    // paint color indicator
    @objc func didTapColorIndicator(sender: UITapGestureRecognizer) {
        self.previousColor = SessionSettings.instance.paintColor
        
        self.colorPickerFrameWidth.constant = 370
        self.colorPickerFrame.isHidden = false
        
        self.paintColorAccept.isHidden = false
        self.paintColorCancel.isHidden = false
        
        self.closePaintPanelButton.isHidden = true
        
        // self.colorHandle.color = UIColor(argb: SessionSettings.instance.paintColor)
        
        self.paintYes.isHidden = true
        self.paintNo.isHidden = true
        
        self.toggleRecentColors(open: false)
        self.recentColorsButton.isHidden = true
        
        self.surfaceView.startPaintSelection()
    }
    
    func closeColorPicker() {
        self.colorPickerFrame.isHidden = true
        self.paintColorAccept.isHidden = true
        self.paintColorCancel.isHidden = true
        
        if self.surfaceView.interactiveCanvas.restorePoints.count == 0 {
            self.closePaintPanelButton.isHidden = false
        }
    }
    
    func toggleToolbox(open: Bool) {
        if open {
            self.exportAction.isHidden = false
            self.changeBackgroundAction.isHidden = false
        }
        else {
            self.exportAction.isHidden = true
            self.changeBackgroundAction.isHidden = true
        }
    }
    
    func toggleRecentColors(open: Bool) {
        if open {
            self.recentColorsActionView.isHidden = true
            self.recentColorsContainer.isHidden = false
        }
        else {
            self.recentColorsActionView.isHidden = false
            self.recentColorsContainer.isHidden = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.surfaceView.backgroundColor = UIColor.red
    }
    
    // paint delegate
    
    func notifyPaintingStarted() {
        self.closePaintPanelButton.isHidden = true
        self.paintYes.isHidden = false
        self.paintNo.isHidden = false
    }
    
    func notifyPaintingEnded() {
        self.closePaintPanelButton.isHidden = false
        self.paintYes.isHidden = true
        self.paintNo.isHidden = true
    }
    
    func notifyPaintColorUpdate() {
        self.paintColorIndicator.setPaintColor(color: SessionSettings.instance.paintColor)
    }
    
    // color picker delegate
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        SessionSettings.instance.paintColor = selectedColor.argb()
        self.paintColorIndicator.setNeedsDisplay()
    }
    
    // pixel history delegate
    func notifyShowPixelHistory(data: [AnyObject], screenPoint: CGPoint) {
        
        self.pixelHistoryViewController.data = data.reversed()
        self.pixelHistoryViewController.clearSelections()
        self.pixelHistoryViewController.collectionView.reloadData()
        
        var x = screenPoint.x + 10
        var y = screenPoint.y - 130
        
        if x < 0 {
            x = 20
        }
        else if x + self.pixelHistoryView.frame.size.width > self.view.frame.size.width {
            x = self.view.frame.size.width - self.pixelHistoryView.frame.size.width - 20
        }
        
        if y < 0 {
            y = 20
        }
        else if y + self.pixelHistoryView.frame.size.height > self.view.frame.size.height {
            y = self.view.frame.size.height - self.pixelHistoryView.frame.size.height - 20
        }
        
        self.pixelHistoryView.frame = CGRect(x: CGFloat(x), y: CGFloat(y),
                                             width: self.pixelHistoryView.frame.size.width,
                                             height: self.pixelHistoryView.frame.size.height)
        
        self.pixelHistoryView.isHidden = false
    }
    
    
    func notifyHidePixelHistory() {
        self.pixelHistoryView.isHidden = true
    }
    
    // recent colors delegate
    func notifyNewRecentColors(recentColors: [Int32]) {
        self.setupRecentColors(recentColors: recentColors)
    }
    
    func setupRecentColors(recentColors: [Int32]) {
        let itemWidth = self.recentColorsViewController.itemWidth
        let itemHeight = self.recentColorsViewController.itemWidth
        let margin = self.recentColorsViewController.itemMargin
        
        self.recentColorsContainerWidth.constant = itemWidth * 4 + margin * 3
        
        let numRows = SessionSettings.instance.numRecentColors / 4
        self.recentColorsContainerHeight.constant = itemHeight * CGFloat(numRows) + margin * CGFloat(numRows - 1)
        
        self.recentColorsViewController.data = recentColors.reversed()
        self.recentColorsViewController.collectionView.reloadData()
    }
    
    // recent colors delegate
    func notifyRecentColorSelected(color: Int32) {
        self.notifyPaintColorUpdate()
    }
    
    // export view controller delegate
    func notifyExportViewControllerBackPressed() {
        exportContainer.isHidden = true
        
        self.exportAction.selected = false
        surfaceView.endExporting()
    }
    
    // art export delegate
    func notifyArtExported(art: [InteractiveCanvas.RestorePoint]) {
        exportViewController.art = art
        exportContainer.isHidden = false
    }
    
    // achievement listener
    func notifyDisplayAchievement(nextAchievement: [StatTracker.EventType : Int], displayInterval: Int) {
        achievementBanner.layer.borderWidth = 2
        achievementBanner.layer.borderColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFFFF7819")).cgColor
        
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
        else if eventType == .pixelPaintedWorld {
            achievementName.text = "Pixels painted world"
        }
        else if eventType == .pixelPaintedSingle {
            achievementName.text = "Pixels painted single"
        }
        
        achievementDesc.text = "Passed the " + String(val) + " threshold"
        
        achievementBanner.isHidden = false
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (tmr) in
            DispatchQueue.main.async {
                self.achievementBanner.isHidden = true
            }
        }
    }
    
    // socket status delegate
    func notifySocketError() {
        self.showDisconnectedMessage(type: 2)
    }
}


