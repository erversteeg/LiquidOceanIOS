//
//  ViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import FlexColorPicker

class InteractiveCanvasViewController: UIViewController, InteractiveCanvasPaintDelegate, ColorPickerDelegate, InteractiveCanvasPixelHistoryDelegate, InteractiveCanvasRecentColorsDelegate, RecentColorsDelegate, ExportViewControllerDelegate, InteractiveCanvasArtExportDelegate, AchievementListener, InteractiveCanvasSocketStatusDelegate, PaintActionDelegate, PaintQtyDelegate, ObjectSelectionDelegate {
    
    @IBOutlet var surfaceView: InteractiveCanvasView!
    
    @IBOutlet var paintPanel: UIView!
    
    @IBOutlet weak var paintPanelButton: ActionButtonView!
    
    @IBOutlet weak var closePaintPanelButton: ActionButtonFrame!
    @IBOutlet weak var closePaintPanelButtonAction: ActionButtonView!
    
    @IBOutlet weak var colorPickerFrame: UIView!
    
    @IBOutlet weak var paintColorIndicator: PaintColorIndicator!
    
    @IBOutlet weak var paintPanelTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var paintPanelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var colorPickerFrameWidth: NSLayoutConstraint!
    
    @IBOutlet weak var paintColorAccept: ActionButtonFrame!
    @IBOutlet weak var paintColorAcceptAction: ActionButtonView!
    
    @IBOutlet weak var paintColorCancel: ActionButtonFrame!
    @IBOutlet weak var paintColorCancelAction: ActionButtonView!
    
    @IBOutlet weak var paintYes: ActionButtonFrame!
    @IBOutlet weak var paintYesAction: ActionButtonView!
    
    @IBOutlet weak var paintNo: ActionButtonFrame!
    @IBOutlet weak var paintNoAction: ActionButtonView!
    
    @IBOutlet weak var paintQuantityCircle: PaintQuantityCircle!
    @IBOutlet weak var paintQuantityBar: PaintQuantityBar!
    
    @IBOutlet weak var backButton: ActionButtonView!
    
    @IBOutlet weak var exportButton: ActionButtonFrame!
    @IBOutlet weak var exportAction: ActionButtonView!
    
    @IBOutlet weak var changeBackgroundButton: ActionButtonFrame!
    @IBOutlet weak var changeBackgroundAction: ActionButtonView!
    
    @IBOutlet weak var gridLinesButton: ActionButtonFrame!
    @IBOutlet weak var gridLinesAction: ActionButtonView!
    
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
    
    @IBOutlet weak var achievementIcon: AchievementIcon!
    @IBOutlet weak var achievementName: UILabel!
    @IBOutlet weak var achievementDesc: UILabel!
    
    @IBOutlet weak var paintEventInfoContainer: UIView!
    @IBOutlet weak var paintEventTimeLabel: UILabel!
    @IBOutlet weak var paintEventAmtLabel: UILabel!
    @IBOutlet weak var paintEventInfoContainerWidth: NSLayoutConstraint!
    
    @IBOutlet weak var canvasLockView: UIView!
    
    @IBOutlet weak var objectSelectionView: UIView!
    
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var paintPanelButtonTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var exportButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var changeBackgroundButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var gridLinesButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var toolboxButtonTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var recentColorsButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var recentColorsContainerLeading: NSLayoutConstraint!
    @IBOutlet weak var recentColorsContainerBottom: NSLayoutConstraint!
    
    @IBOutlet weak var pixelHistoryViewTop: NSLayoutConstraint!
    @IBOutlet weak var pixelHistoryViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var paintInfoContainerTop: NSLayoutConstraint!
    
    @IBOutlet weak var colorPIckerFrameLeading: NSLayoutConstraint!
    
    @IBOutlet weak var paintYesActionWidth: NSLayoutConstraint!
    @IBOutlet weak var paintYesActionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paintNoActionWidth: NSLayoutConstraint!
    @IBOutlet weak var paintNoActionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paintColorAcceptActionWidth: NSLayoutConstraint!
    @IBOutlet weak var paintColorAcceptActionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paintColorCancelActionWidth: NSLayoutConstraint!
    @IBOutlet weak var paintColorCancelActionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var closePaintPanelActionWidth: NSLayoutConstraint!
    @IBOutlet weak var closePaintPanelActionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var canvasLockLeading: NSLayoutConstraint!
    @IBOutlet weak var canvasLockTrailing: NSLayoutConstraint!
    
    var panelThemeConfig: PanelThemeConfig!
    
    var world = false
    var realmId = 0
    
    var statusCheckTimer: Timer?
    
    var previousColor: Int32!
    
    var resizedColorPicker = false
    var initial = true
    
    var paintTextMode = 2
    
    var paintTextModeTime = 0
    var paintTextModeAmt = 1
    var paintTextModeHide = 2
    
    var singlePlaySaveTimer: Timer!
    
    var pixelHistoryViewController: PixelHistoryViewController!
    weak var recentColorsViewController: RecentColorsViewController!
    weak var exportViewController: ExportViewController!
    weak var colorPickerViewController: ColorPickerOutletsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surfaceView.interactiveCanvas.realmId = realmId
        surfaceView.interactiveCanvas.world = world
        
        // paintQuantityMeter.world = world
        
        SessionSettings.instance.interactiveCanvas = self.surfaceView.interactiveCanvas
        
        SessionSettings.instance.darkIcons = (SessionSettings.instance.backgroundColorIndex == 1 || SessionSettings.instance.backgroundColorIndex == 3)
        
        surfaceView.paintActionDelegate = self
        surfaceView.objectSelectionDelegate = self
        
        self.surfaceView.interactiveCanvas.paintDelegate = self
        self.surfaceView.interactiveCanvas.pixelHistoryDelegate = self
        self.surfaceView.interactiveCanvas.recentColorsDelegate = self
        self.surfaceView.interactiveCanvas.artExportDelegate = self
        
        // surfaceView.setInitalScale()
        
        panelThemeConfig = themeConfigFromBackground()
        
        // back button
        self.backButton.type = .back
        self.backButton.setOnClickListener {
            if !self.surfaceView.isExporting() {
                if SessionSettings.instance.promptBack {
                    self.promptBack()
                }
                else {
                    self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
                }
            }
            else {
                self.exportAction.selected = false
                self.exportAction.layer.borderWidth = 0
                
                self.surfaceView.endExporting()
            }
        }
        
        SessionSettings.instance.paintQtyDelegates.append(self)
        paintEventAmtLabel.text = String(SessionSettings.instance.dropsAmt)
        
        // paint quantity meter
        if SessionSettings.instance.showPaintBar {
            SessionSettings.instance.paintQtyDelegates.append(paintQuantityBar)
            
            paintQuantityCircle.isHidden = true
        }
        else if SessionSettings.instance.showPaintCircle {
            SessionSettings.instance.paintQtyDelegates.append(paintQuantityCircle)
            
            paintInfoContainerTop.constant -= 15
            
            paintQuantityBar.isHidden = true
        }
        else {
            paintQuantityCircle.isHidden = true
            paintQuantityBar.isHidden = true
        }
        
        if !world {
            paintQuantityCircle.isHidden = true
            paintQuantityBar.isHidden = true
        }
        
        //self.paintPanelWidth.constant = 0
        self.colorPickerFrameWidth.constant = 0
        self.colorPickerFrame.isHidden = true
        
        // toolbox
        //self.toggleToolbox(open: false)
        
        self.paintPanel.isHidden = true
        
        // action buttons
        paintPanelButton.type = .paint
        
        closePaintPanelButtonAction.type = .closePaint
        closePaintPanelButton.actionButtonView = closePaintPanelButtonAction
        
        exportButton.actionButtonView = exportAction
        exportAction.type = .export
        
        changeBackgroundButton.actionButtonView = changeBackgroundAction
        changeBackgroundAction.type = .changeBackground
        
        gridLinesButton.actionButtonView = gridLinesAction
        gridLinesAction.type = .gridLines
        
        // toolbox
        self.toolboxActionView.type = .dot
        self.toolboxButton.actionButtonView = self.toolboxActionView
        
        self.toolboxButton.setOnClickListener {
            self.toggleToolbox(open: self.exportButton.isHidden)
        }
        
        exportButton.isHidden = true
        changeBackgroundButton.isHidden = true
        gridLinesButton.isHidden = true
        
        // recent colors
        self.recentColorsActionView.type = .dot
        self.recentColorsButton.actionButtonView = self.recentColorsActionView
        
        self.recentColorsButton.setOnClickListener {
            self.toggleRecentColors(open: self.recentColorsContainer.isHidden)
        }
        
        self.setupRecentColors(recentColors: self.surfaceView.interactiveCanvas.recentColors)
        
        // export
        self.exportButton.setOnClickListener {
            self.surfaceView.startExporting()
            self.exportAction.selected = true
            self.exportAction.layer.borderColor = UIColor(argb: ActionButtonView.lightYellowColor).cgColor
            self.exportAction.layer.borderWidth = 1
        }
        
        // change background
        self.changeBackgroundButton.setOnClickListener {
            SessionSettings.instance.backgroundColorIndex += 1
            if SessionSettings.instance.backgroundColorIndex == self.surfaceView.interactiveCanvas.numBackgrounds {
                SessionSettings.instance.backgroundColorIndex = 0
            }
            
            SessionSettings.instance.darkIcons = (SessionSettings.instance.backgroundColorIndex == 1 || SessionSettings.instance.backgroundColorIndex == 3)
            
            self.exportAction.setNeedsDisplay()
            self.changeBackgroundAction.setNeedsDisplay()
            self.gridLinesAction.setNeedsDisplay()
            self.paintPanelButton.setNeedsDisplay()
            self.backButton.setNeedsDisplay()
            
            self.recentColorsViewController.collectionView.reloadData()
            
            SessionSettings.instance.quickSave()
            
            self.surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        }
        
        // grid lines
        gridLinesButton.setOnClickListener {
            SessionSettings.instance.showGridLines = !SessionSettings.instance.showGridLines
            
            SessionSettings.instance.quickSave()
            
            self.surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        }
        
        // paint panel
        self.paintPanel.isHidden = true
        self.paintPanelButton.setOnClickListener {
            self.paintPanelButton.isHidden = true
            
            self.paintPanel.isHidden = false
            
            self.pixelHistoryView.isHidden = true
            
            self.backButton.isHidden = true
            
            self.recentColorsButton.isHidden = false
            
            if SessionSettings.instance.canvasLockBorder {
                self.canvasLockView.isHidden = false
            }
            
            //self.paintPanelWidth.constant = 200
            
            /*UIView.animate(withDuration: 0.5, animations: {
                self.paintPanelTrailing.constant = 0
            }) { (done) in
                if done {
                    if SessionSettings.instance.canvasLockBorder {
                        self.canvasLockView.isHidden = false
                    }
                }
            }*/
            
            self.surfaceView.startPainting()
        }
        
        // close paint panel
        self.closePaintPanelButton.setOnClickListener {
            self.surfaceView.endPainting(accept: false)
            
            self.paintPanelButton.isHidden = false
            
            self.backButton.isHidden = false
            
            self.recentColorsButton.isHidden = true
            
            self.toggleRecentColors(open: false)
            
            self.paintPanel.isHidden = true
            if SessionSettings.instance.canvasLockBorder {
                self.canvasLockView.isHidden = true
            }
            
            /*UIView.animate(withDuration: 0.5, animations: {
                self.paintPanelTrailing.constant = -200
            }) { (done) in
                if done {
                    if SessionSettings.instance.canvasLockBorder {
                        if SessionSettings.instance.canvasLockBorder {
                            self.canvasLockView.isHidden = true
                        }
                    }
                }
            }*/
        }
        
        // paint quantity meter
        let paintIndicatorTap = UITapGestureRecognizer(target: self, action: #selector(didTapColorIndicator(sender:)))
        self.paintColorIndicator.addGestureRecognizer(paintIndicatorTap)
        
        paintColorAcceptAction.type = .paintSelectYes
        paintColorAccept.actionButtonView = paintColorAcceptAction
        
        paintColorCancelAction.type = .paintSelectCancel
        paintColorCancel.actionButtonView = paintColorCancelAction
        
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
            
            SessionSettings.instance.quickSave()
        }
        
        // paint selection cancel
        self.paintColorCancel.setOnClickListener {
            self.paintColorIndicator.setPaintColor(color: self.previousColor)
            self.colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.paintColor)
            
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
        
        paintYesAction.type = .yes
        paintYes.actionButtonView = paintYesAction
        
        paintNoAction.type = .no
        paintNo.actionButtonView = paintNoAction
        
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
        
        // bocker lock
        if SessionSettings.instance.canvasLockBorder {
            canvasLockView.layer.borderWidth = 4
            canvasLockView.layer.borderColor = UIColor(argb: SessionSettings.instance.canvasLockColor).cgColor
            canvasLockView.layer.cornerRadius = 40
        }
        
        // panel theme config
        if panelThemeConfig.actionButtonColor == ActionButtonView.blackColor {
            paintColorAcceptAction.colorMode = .black
            paintColorCancelAction.colorMode = .black
            closePaintPanelButtonAction.colorMode = .black
        }
        else {
            paintColorAcceptAction.colorMode = .white
            paintColorCancelAction.colorMode = .white
            closePaintPanelButtonAction.colorMode = .white
        }
        
        self.paintColorAcceptAction.touchDelegate = self.paintColorIndicator
        
        self.paintQuantityCircle.panelThemeConfig = panelThemeConfig
        self.paintQuantityBar.panelThemeConfig = panelThemeConfig
        
        self.paintColorIndicator.panelThemeConfig = panelThemeConfig
        
        // paint event time toggle
        let tgr = UITapGestureRecognizer(target: self, action: #selector(didTapPaintQuantityBar))
        
        if SessionSettings.instance.showPaintCircle {
            self.paintQuantityCircle.addGestureRecognizer(tgr)
        }
        else if SessionSettings.instance.showPaintBar {
            self.paintQuantityBar.addGestureRecognizer(tgr)
        }
        
        StatTracker.instance.achievementListener = self
        
        InteractiveCanvasSocket.instance.socketStatusDelegate = self
        
        if world {
            self.startServerStatusChecks()
            
            getPaintTimerInfo()
        }
        else {
            singlePlaySaveTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: { (tmr) in
                self.surfaceView.interactiveCanvas.save()
            })
            
            if SessionSettings.instance.showPaintCircle {
                self.paintQuantityCircle.removeGestureRecognizer(tgr)
            }
            else if SessionSettings.instance.showPaintBar {
                self.paintQuantityBar.removeGestureRecognizer(tgr)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if initial {
            let backX = self.backButton.frame.origin.x
            let paintPanelButtonX = self.paintPanelButton.frame.origin.x + self.paintPanelButton.frame.size.width
            
            let exportButtonX = self.exportButton.frame.origin.x + self.exportButton.frame.size.width
            let changeBackgroundButtonX = self.changeBackgroundButton.frame.origin.x + self.changeBackgroundButton.frame.size.width
            let gridLinesButtonX = self.gridLinesButton.frame.origin.x + self.gridLinesButton.frame.size.width
            
            let toolboxButtonX = self.toolboxButton.frame.origin.x + self.toolboxButton.frame.size.width
            
            let recentColorsButtonX = self.recentColorsButton.frame.origin.x
            
            let recentColorsX = self.recentColorsContainer.frame.origin.x
            
            if paintPanelButtonX > self.view.frame.size.width {
                paintPanelButtonTrailing.constant += 30
            }
            
            if exportButtonX > self.view.frame.size.width {
                exportButtonTrailing.constant += 30
            }
            
            if changeBackgroundButtonX > self.view.frame.size.width {
                changeBackgroundButtonTrailing.constant += 30
            }
            
            if gridLinesButtonX > self.view.frame.size.width {
                gridLinesButtonTrailing.constant += 30
            }
            
            if toolboxButtonX > self.view.frame.size.width {
                toolboxButtonTrailing.constant += 30
            }
            
            if backX < 0 {
                backButtonLeading.constant += 30
            }
            
            if recentColorsButtonX < 0 {
                recentColorsButtonLeading.constant += 30
            }
            
            if recentColorsX < 20 {
                recentColorsContainerLeading.constant = 20
                recentColorsContainerBottom.constant = 20
            }
            
            let panelRatio = paintPanel.frame.size.width / paintPanel.frame.size.height
            
            var adjust = false
            if panelRatio < 0.4 || panelRatio > 0.6 {
                paintPanelWidth.constant = paintPanel.frame.size.height * 0.25
                adjust = true
            }
            
            // right-handed
            if SessionSettings.instance.rightHanded {
                
                canvasLockLeading.constant = paintPanelWidth.constant
                canvasLockTrailing.constant = 0
                
                // paint panel
                paintPanel.translatesAutoresizingMaskIntoConstraints = false
                
                paintPanelTrailing.isActive = false
                
                var constraints = [paintPanel.leftAnchor.constraint(equalTo: view.leftAnchor),
                                   paintPanel.topAnchor.constraint(equalTo: view.topAnchor),
                                   paintPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                   paintPanel.widthAnchor.constraint(equalTo: paintPanel.widthAnchor)]
                
                NSLayoutConstraint.activate(constraints)
                
                // close paint panel
                closePaintPanelButton.transform = CGAffineTransform.init(rotationAngle: CGFloat(180 * Double.pi / 180.0))
                
                // color picker frame
                colorPickerFrame.translatesAutoresizingMaskIntoConstraints = false
                
                colorPIckerFrameLeading.isActive = false
                
                constraints = [colorPickerFrame.rightAnchor.constraint(equalTo: view.rightAnchor),
                                   colorPickerFrame.topAnchor.constraint(equalTo: view.topAnchor),
                                   colorPickerFrame.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                   colorPickerFrame.widthAnchor.constraint(equalTo: colorPickerFrame.widthAnchor)]
                
                NSLayoutConstraint.activate(constraints)
                
                // toolbox button
                toolboxButton.translatesAutoresizingMaskIntoConstraints = false
                
                toolboxButtonTrailing.isActive = false
                
                constraints = [toolboxButton.leftAnchor.constraint(equalTo: view.leftAnchor),
                                toolboxButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                toolboxButton.widthAnchor.constraint(equalTo: toolboxButton.widthAnchor),
                                toolboxButton.heightAnchor.constraint(equalTo: toolboxButton.heightAnchor)]
                
                NSLayoutConstraint.activate(constraints)
                
                // recent colors button
                recentColorsButton.translatesAutoresizingMaskIntoConstraints = false
                
                recentColorsButtonLeading.isActive = false
                
                constraints = [recentColorsButton.rightAnchor.constraint(equalTo: view.rightAnchor),
                                recentColorsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                recentColorsButton.widthAnchor.constraint(equalTo: recentColorsButton.widthAnchor),
                                recentColorsButton.heightAnchor.constraint(equalTo: recentColorsButton.heightAnchor)]
                
                NSLayoutConstraint.activate(constraints)
                
                // recent colors container
                recentColorsContainer.translatesAutoresizingMaskIntoConstraints = false
                
                recentColorsContainerLeading.isActive = false
                
                constraints = [recentColorsContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
                                recentColorsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 21),
                                recentColorsContainer.widthAnchor.constraint(equalTo: recentColorsContainer.widthAnchor),
                                recentColorsContainer.heightAnchor.constraint(equalTo: recentColorsContainer.heightAnchor)]
                
                NSLayoutConstraint.activate(constraints)
                
                // toolbox buttons
                
                let buttons = [exportButton, changeBackgroundButton, gridLinesButton]
                let trailingConstraints = [exportButtonTrailing, changeBackgroundButtonTrailing, gridLinesButtonTrailing]
                
                for i in 0...2 {
                    let button = buttons[i]!
                    let trailingConstraint = trailingConstraints[i]!
                    
                    button.translatesAutoresizingMaskIntoConstraints = false
                    
                    trailingConstraint.isActive = false
                    
                    constraints = [button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                    button.widthAnchor.constraint(equalTo: button.widthAnchor),
                    button.heightAnchor.constraint(equalTo: button.heightAnchor)]
                    
                    NSLayoutConstraint.activate(constraints)
                }
                
                // paint qty bar
                paintQuantityBar.transform = CGAffineTransform.init(rotationAngle: CGFloat(180 * Double.pi / 180.0))
            }
            else {
                canvasLockLeading.constant = 0
                canvasLockTrailing.constant = paintPanelWidth.constant
            }
            
            // small action buttons
            if SessionSettings.instance.smallActionButtons {
                paintColorAcceptActionWidth.constant = paintColorAcceptActionWidth.constant * 0.833
                paintColorAcceptActionHeight.constant = paintColorAcceptActionHeight.constant * 0.833
                
                paintYesActionWidth.constant = paintYesActionWidth.constant * 0.833
                paintYesActionHeight.constant = paintYesActionHeight.constant * 0.833
                
                paintNoActionWidth.constant = paintNoActionWidth.constant * 0.833
                paintNoActionHeight.constant = paintNoActionHeight.constant * 0.833
                
                paintColorCancelActionWidth.constant = paintColorCancelActionWidth.constant * 0.833
                paintColorCancelActionHeight.constant = paintColorCancelActionHeight.constant * 0.833
                
                closePaintPanelActionWidth.constant = closePaintPanelActionWidth.constant * 0.833
                closePaintPanelActionHeight.constant = closePaintPanelActionHeight.constant * 0.833
            }
            
            setPaintPanelBackground(adjust: adjust)

            surfaceView.setInitalScale()
                
            initial = false
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func didTapPaintQuantityBar() {
        paintTextMode += 1
        if paintTextMode == 3 {
            paintTextMode = 0
        }
        
        if paintTextMode == paintTextModeTime {
            paintEventTimeLabel.isHidden = false
            paintEventInfoContainer.isHidden = false
    
            paintEventAmtLabel.isHidden = true
        }
        else if paintTextMode == paintTextModeAmt {
            paintEventAmtLabel.isHidden = false
            paintEventInfoContainer.isHidden = false
            
            paintEventTimeLabel.isHidden = true
        }
        else if paintTextMode == paintTextModeHide {
            paintEventInfoContainer.isHidden = true
        }
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
                        if self.world {
                            InteractiveCanvasSocket.instance.sendSocketStatusCheck()
                        }
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
        if panelThemeConfig.inversePaintEventInfo {
            self.paintEventInfoContainer.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFFFFFFFF"))
            self.paintEventTimeLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF000000"))
            self.paintEventAmtLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF000000"))
        }
        else {
            self.paintEventInfoContainer.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF000000"))
            self.paintEventTimeLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFFFFFFFF"))
            self.paintEventAmtLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFFFFFFFF"))
        }
        
        if SessionSettings.instance.showPaintCircle {
            self.paintEventInfoContainer.backgroundColor = UIColor.clear
        }
        
        self.paintEventInfoContainer.layer.cornerRadius = 20
        
        URLSessionHandler.instance.getPaintTimerInfo { (success, nextPaintTime) -> (Void) in
            if success {
                if nextPaintTime >= 0 {
                    var ts = Int(nextPaintTime)
                    let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (tmr) in
                        ts -= 1
                        
                        if ts == 0 {
                            ts = 300
                        }
                        
                        let m = ts / 60
                        let s = ts % 60
                        
                        self.paintEventTimeLabel.text = String(format: "%02d:%02d", m, s)
                        self.paintEventInfoContainerWidth.constant = self.paintEventTimeLabel.text!.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: self.paintEventTimeLabel.font.pointSize)]).width + 20
                    }
                    timer.fire()
                }
                else {
                    self.paintEventTimeLabel.text = "???"
                }
            }
        }
    }
    
    // embeds
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ColorPickerEmbed" {
            colorPickerViewController = segue.destination as! ColorPickerOutletsViewController
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
            SessionSettings.instance.save()
            
            StatTracker.instance.achievementListener = nil
            
            if world {
                InteractiveCanvasSocket.instance.socket.disconnect()
                
                statusCheckTimer?.invalidate()
            }
            
            else {
                surfaceView.interactiveCanvas.save()
                
                singlePlaySaveTimer.invalidate()
            }
        }
    }
    
    // paint color indicator
    @objc func didTapColorIndicator(sender: UITapGestureRecognizer) {
        self.previousColor = SessionSettings.instance.paintColor
        
        if self.previousColor == 0 {
            colorPickerViewController.selectedColor = UIColor.white
        }
        
        // tablet
        if view.frame.size.height > 600 && !resizedColorPicker {
            colorPickerFrameWidth.constant = 330
            colorPickerFrameWidth.constant *= 1.4
            
            colorPickerViewController.hsbWheelWidth.constant *= 1.5
            colorPickerViewController.hsbWheelHeight.constant *= 1.5
            
            colorPickerViewController.hsbWheelXCenter.constant = 0
            colorPickerViewController.hsbWheelYCenter.constant = 0
            
            resizedColorPicker = true
        }
        else if view.frame.size.height <= 600 {
            colorPickerFrameWidth.constant = 330
        }
        
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
            exportButton.isHidden = false
            changeBackgroundButton.isHidden = false
            gridLinesButton.isHidden = false
            
            if SessionSettings.instance.rightHanded {
                Animator.animateMenuButtons(views: [[exportButton], [changeBackgroundButton], [gridLinesButton]], cascade: false, moveOut: false, inverse: true)
            }
            else {
                Animator.animateMenuButtons(views: [[exportButton], [changeBackgroundButton], [gridLinesButton]], cascade: false, moveOut: false, inverse: false)
            }
        }
        else {
            if SessionSettings.instance.rightHanded {
                Animator.animateMenuButtons(views: [[exportButton], [changeBackgroundButton], [gridLinesButton]], cascade: false, moveOut: true, inverse: true)
            }
            else {
                Animator.animateMenuButtons(views: [[exportButton], [changeBackgroundButton], [gridLinesButton]], cascade: false, moveOut: true, inverse: false)
            }
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
        colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.paintColor)
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
        
        if x < 20 {
            x = 20
        }
        else if x + self.pixelHistoryView.frame.size.width > self.view.frame.size.width - 20 {
            x = self.view.frame.size.width - self.pixelHistoryView.frame.size.width - 20
        }
        
        if y < 20 {
            y = 20
        }
        else if y + self.pixelHistoryView.frame.size.height > self.view.frame.size.height - 20 {
            y = self.view.frame.size.height - self.pixelHistoryView.frame.size.height - 20
        }
        
        pixelHistoryViewLeading.constant = x
        pixelHistoryViewTop.constant = y
        
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
        self.colorPickerViewController.selectedColor = UIColor(argb: color)
        
        self.recentColorsContainer.isHidden = true
    }
    
    // export view controller delegate
    func notifyExportViewControllerBackPressed() {
        exportContainer.isHidden = true
        
        self.exportAction.selected = false
        self.exportAction.layer.borderWidth = 0
        
        surfaceView.endExporting()
    }
    
    // art export delegate
    func notifyArtExported(art: [InteractiveCanvas.RestorePoint]) {
        exportViewController.art = art
        exportContainer.isHidden = false
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
    
    // socket status delegate
    func notifySocketError() {
        self.showDisconnectedMessage(type: 2)
    }
    
    func promptBack() {
        let alert = UIAlertController(title: nil, message: "Are you sure you would like to go back?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // paint action delegate
    func notifyPaintActionStarted() {
        toggleRecentColors(open: false)
        
        if SessionSettings.instance.dropsAmt == 0 {
            paintQuantityCircle.flashError()
            paintQuantityBar.flashError()
        }
    }
    
    func setPaintPanelBackground(adjust: Bool) {
        /*var w = CGFloat(200)
        if adjust {
            w = self.paintPanel.frame.size.height * 0.25
        }*/
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: paintPanel.frame.size.width, height: paintPanel.frame.size.height))
        
        //paintPanelWidth.constant = w
        
        if SessionSettings.instance.panelBackgroundName == "" {
            backgroundImage.image = UIImage(named: "wood_texture_light.jpg")
        }
        else {
            backgroundImage.image = UIImage(named: SessionSettings.instance.panelBackgroundName)
        }
        
        if adjust {
            backgroundImage.contentMode = .topLeft
        }
        else {
            backgroundImage.contentMode = .scaleToFill
        }
        
        self.paintPanel.insertSubview(backgroundImage, at: 0)
    }
    
    func themeConfigFromBackground() -> PanelThemeConfig {
        var ptc: PanelThemeConfig!
        
        if SessionSettings.instance.panelBackgroundName == "" {
            ptc = PanelThemeConfig.defaultDarkTheme()
        }
        else {
            ptc = PanelThemeConfig.buildConfig(imageName: SessionSettings.instance.panelBackgroundName)
        }
        
        return ptc
    }
    
    // paint quantity delegate
    func notifyPaintQtyChanged(qty: Int) {
        paintEventAmtLabel.text = String(qty)
    }
    
    // object selection delegate
    func notifyObjectSelectionBoundsChanged(upperLeft: CGPoint, lowerRight: CGPoint) {
        objectSelectionView.isHidden = false
        
        objectSelectionView.layer.borderWidth = 1
        if SessionSettings.instance.backgroundColorIndex == 1 || SessionSettings.instance.backgroundColorIndex == 3 {
            objectSelectionView.backgroundColor = Utils.UIColorFromColorHex(hex: "0x44000000")
            objectSelectionView.layer.borderColor = Utils.UIColorFromColorHex(hex: "0xff2f2f2f").cgColor
        }
        else {
            objectSelectionView.backgroundColor = Utils.UIColorFromColorHex(hex: "0x44ffffff")
            objectSelectionView.layer.borderColor = Utils.UIColorFromColorHex(hex: "0xffffffff").cgColor
        }
        
        objectSelectionView.frame = CGRect(x: upperLeft.x, y: upperLeft.y, width: lowerRight.x - upperLeft.x, height: lowerRight.y - upperLeft.y)
        
        //objectSelectionView.frame = CGRect(x: upperLeft.x, y: upperLeft.y, width: 100, height: 100)
        
        print(objectSelectionView.frame)
    }
    
    func notifyObjectSelectionEnded() {
        objectSelectionView.isHidden = true
    }
}


