//
//  ViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import FlexColorPicker
import Kingfisher

class InteractiveCanvasViewController: UIViewController, InteractiveCanvasPaintDelegate, ColorPickerDelegate, InteractiveCanvasPixelHistoryDelegate, InteractiveCanvasRecentColorsDelegate, RecentColorsDelegate, ExportViewControllerDelegate, InteractiveCanvasArtExportDelegate, AchievementListener, InteractiveCanvasSocketStatusDelegate, PaintActionDelegate, PaintQtyDelegate, ObjectSelectionDelegate, UITextFieldDelegate, ColorPickerLayoutDelegate, InteractiveCanvasPalettesDelegate, PalettesViewControllerDelegate, InteractiveCanvasGestureDelegate, CanvasFrameViewControllerDelegate, CanvasFrameDelegate, CanvasEdgeTouchDelegate, InteractiveCanvasSelectedObjectViewDelegate, InteractiveCanvasSelectedObjectMoveViewDelegate, MenuButtonDelegate,
    InteractiveCanvasSocketConnectionDelegate, SceneDelegateDeleage, InteractiveCanvasEraseDelegate {
    
    @IBOutlet var surfaceView: InteractiveCanvasView!
    
    @IBOutlet var paintPanel: UIView!
    
    @IBOutlet weak var paintPanelButton: ButtonFrame!
    @IBOutlet weak var paintPanelImage: UIImageView!
    
    @IBOutlet weak var closePaintPanelButton: ButtonFrame!
    
    @IBOutlet weak var colorPickerFrame: UIView!
    
    @IBOutlet weak var paintColorIndicator: PaintColorIndicator!
    
    @IBOutlet var paintPanelLeading: NSLayoutConstraint!
    @IBOutlet var paintPanelTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var paintPanelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var colorPickerFrameWidth: NSLayoutConstraint!
    
    @IBOutlet weak var paintColorAccept: ButtonFrame!
    @IBOutlet weak var paintColorCancel: ButtonFrame!
    @IBOutlet weak var paintYes: ButtonFrame!
    @IBOutlet weak var paintNo: ButtonFrame!
    
    @IBOutlet weak var paintQuantityCircle: PaintQuantityCircle!
    @IBOutlet weak var paintQuantityBar: PaintQuantityBar!
    
    @IBOutlet weak var paletteAddColor: ActionButtonFrame!
    @IBOutlet weak var paletteAddColorAction: ActionButtonView!
    
    @IBOutlet weak var paletteRemoveColor: ActionButtonFrame!
    @IBOutlet weak var paletteRemoveColorAction: ActionButtonView!
    
    @IBOutlet weak var lockPaintPanel: ActionButtonFrame!
    @IBOutlet weak var lockPaintPanelAction: ActionButtonView!
    @IBOutlet weak var lockPaintPanelCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var menuButton: ButtonFrame!
    
    @IBOutlet weak var exportImage: UIImageView!
    @IBOutlet weak var exportButton: ButtonFrame!
    @IBOutlet weak var changeBackgroundButton: ButtonFrame!
    @IBOutlet weak var gridLinesButton: ButtonFrame!
    @IBOutlet weak var summaryButton: ButtonFrame!
    
    @IBOutlet weak var toolboxButton: ButtonFrame!
    
    @IBOutlet var toolboxActionLeading: NSLayoutConstraint!
    @IBOutlet var toolboxActionTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var recentColorsButton: ButtonFrame!
    
    @IBOutlet var recentColorsActionLeading: NSLayoutConstraint!
    @IBOutlet var recentColorsActionTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var recentColorsContainer: UIView!
    @IBOutlet weak var recentColorsImage: UIImageView!
    
    @IBOutlet weak var pixelHistoryView: UIView!
    
    @IBOutlet weak var recentColorsContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var recentColorsContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var exportContainer: UIView!
    
    @IBOutlet weak var achievementBanner: UIView!
    
    @IBOutlet weak var achievementIcon: AchievementIcon!
    @IBOutlet weak var achievementName: UILabel!
    @IBOutlet weak var achievementDesc: UILabel!
    
    @IBOutlet weak var colorPaletteTitleLabel: UILabel!
    
    @IBOutlet weak var paintEventInfoContainer: UIView!
    @IBOutlet weak var paintEventTimeLabel: UILabel!
    @IBOutlet weak var paintEventAmtLabel: UILabel!
    @IBOutlet weak var paintEventInfoContainerWidth: NSLayoutConstraint!
    
    @IBOutlet weak var canvasLockView: UIView!
    
    @IBOutlet weak var objectSelectionView: UIView!
    
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var paintPanelButtonTrailing: NSLayoutConstraint!
    
    @IBOutlet var exportButtonLeading: NSLayoutConstraint!
    @IBOutlet var exportButtonTrailing: NSLayoutConstraint!
    @IBOutlet var exportActionLeading: NSLayoutConstraint!
    @IBOutlet var exportActionTrailing: NSLayoutConstraint!
    
    @IBOutlet var changeBackgroundButtonLeading: NSLayoutConstraint!
    @IBOutlet var changeBackgroundButtonTrailing: NSLayoutConstraint!
    @IBOutlet var changeBackgroundActionLeading: NSLayoutConstraint!
    @IBOutlet var changeBackgroundActionTrailing: NSLayoutConstraint!
    
    @IBOutlet var gridLinesButtonLeading: NSLayoutConstraint!
    @IBOutlet var gridLinesButtonTrailing: NSLayoutConstraint!
    @IBOutlet var gridLinesActionLeading: NSLayoutConstraint!
    @IBOutlet var gridLinesActionTrailing: NSLayoutConstraint!
    
    @IBOutlet var summaryButtonLeading: NSLayoutConstraint!
    @IBOutlet var summaryButtonTrailing: NSLayoutConstraint!
    @IBOutlet var summaryActionLeading: NSLayoutConstraint!
    @IBOutlet var summaryActionTrailing: NSLayoutConstraint!
    
    @IBOutlet var toolboxButtonLeading: NSLayoutConstraint!
    @IBOutlet var toolboxButtonTrailing: NSLayoutConstraint!
    
    @IBOutlet var recentColorsButtonLeading: NSLayoutConstraint!
    @IBOutlet var recentColorsButtonTrailing: NSLayoutConstraint!
    
    @IBOutlet var recentColorsContainerLeading: NSLayoutConstraint!
    @IBOutlet var recentColorsContainerTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var recentColorsContainerBottom: NSLayoutConstraint!
    
    @IBOutlet weak var pixelHistoryViewTop: NSLayoutConstraint!
    @IBOutlet weak var pixelHistoryViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var canvasFrameViewTop: NSLayoutConstraint!
    @IBOutlet weak var canvasFrameViewLeading: NSLayoutConstraint!
    
    @IBOutlet weak var paintInfoContainerTop: NSLayoutConstraint!
    
    @IBOutlet var colorPIckerFrameLeading: NSLayoutConstraint!
    @IBOutlet var colorPickerFrameTrailing: NSLayoutConstraint!
    
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
    
    @IBOutlet var canvasLockLeading: NSLayoutConstraint!
    @IBOutlet var canvasLockTrailing: NSLayoutConstraint!
    
    @IBOutlet var canvasLockLeadingRight: NSLayoutConstraint!
    @IBOutlet var canvasLockTrailingRight: NSLayoutConstraint!
    
    @IBOutlet var summaryViewLeading: NSLayoutConstraint!
    @IBOutlet var summaryViewTrailing: NSLayoutConstraint!
    
    @IBOutlet var deviceViewportSummaryViewLeading: NSLayoutConstraint!
    @IBOutlet var deviceViewportSummaryViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var palettesViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var palettesView: UIView!
    
    @IBOutlet weak var summaryView: UIImageView!
    @IBOutlet weak var deviceViewportSummaryView: DeviceViewportSummaryView!
    
    @IBOutlet weak var canvasFrameView: UIView!
    
    @IBOutlet weak var menuContainer: UIView!
    
    @IBOutlet weak var objectMoveUpButton: ActionButtonFrame!
    @IBOutlet weak var objectMoveUpAction: ActionButtonView!
    @IBOutlet weak var objectMoveUpButtonTop: NSLayoutConstraint!
    @IBOutlet weak var objectMoveUpButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var objectMoveDownButton: ActionButtonFrame!
    @IBOutlet weak var objectMoveDownAction: ActionButtonView!
    @IBOutlet weak var objectMoveDownButtonTop: NSLayoutConstraint!
    @IBOutlet weak var objectMoveDownButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var objectMoveLeftButton: ActionButtonFrame!
    @IBOutlet weak var objectMoveLeftAction: ActionButtonView!
    @IBOutlet weak var objectMoveLeftButtonTop: NSLayoutConstraint!
    @IBOutlet weak var objectMoveLeftButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var objectMoveRightButton: ActionButtonFrame!
    @IBOutlet weak var objectMoveRightAction: ActionButtonView!
    @IBOutlet weak var objectMoveRightButtonTop: NSLayoutConstraint!
    @IBOutlet weak var objectMoveRightButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var selectedObjectYesButton: ActionButtonFrame!
    @IBOutlet weak var selectedObjectYesAction: ActionButtonView!
    @IBOutlet weak var selectedObjectNoButton: ActionButtonFrame!
    @IBOutlet weak var selectedObjectNoAction: ActionButtonView!
    
    @IBOutlet weak var selectedObjectYesNoContainer: UIView!
    @IBOutlet weak var selectedObjectYesNoContainerTop: NSLayoutConstraint!
    @IBOutlet weak var selectedObjectYesNoContainerLeading: NSLayoutConstraint!
    
    @IBOutlet weak var menuContainerCenterX: NSLayoutConstraint!
    @IBOutlet weak var menuContainerCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerIcon: UIImageView!
    @IBOutlet weak var bannerText: UILabel!
    @IBOutlet weak var bannerWidth: NSLayoutConstraint!
    
    let showOptions = "ShowOptions"
    let showHowto = "ShowHowto"
    let unwindToLoading = "UnwindToLoading"
    
    var panelThemeConfig: PanelThemeConfig!
    
    var world = false
    var realmId = 0
    var server: Server!
    
    var statusCheckTimer: Timer?
    
    var previousColor: Int32!
    
    var resizedColorPicker = false
    var initial = true
    
    var paintTextMode = 2
    
    var paintTextModeTime = 0
    var paintTextModeAmt = 1
    var paintTextModeHide = 2
    
    var paintPanelBackgroundSet = false
    
    var singlePlaySaveTimer: Timer!
    
    var lastViewFrameSize: CGSize!
    
    var lastPanTranslationX: CGFloat = 0
    var lastPanTranslationY: CGFloat = 0
    
    var lastCanvasSummaryUpdate = 0.0
    
    var pixelHistoryViewController: PixelHistoryViewController!
    weak var recentColorsViewController: RecentColorsViewController!
    weak var exportViewController: ExportViewController!
    weak var colorPickerViewController: ColorPickerOutletsViewController!
    weak var palettesViewController: PalettesViewController!
    weak var canvasFrameViewController: CanvasFrameViewController!
    weak var menuViewController: MenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InteractiveCanvasSocket.instance.socketConnectionDelegate = self
        
        SessionSettings.instance.canvasOpen = true
        SessionSettings.instance.sceneDelegateDelegate = self
        
        realmId = 1
        
        surfaceView.interactiveCanvas.server = server
        surfaceView.interactiveCanvas.realmId = realmId
        surfaceView.interactiveCanvas.world = world
        
        // paintQuantityMeter.world = world
        
        SessionSettings.instance.interactiveCanvas = self.surfaceView.interactiveCanvas
        
        surfaceView.paintActionDelegate = self
        surfaceView.objectSelectionDelegate = self
        
        self.surfaceView.interactiveCanvas.pixelHistoryDelegate = self
        self.surfaceView.interactiveCanvas.recentColorsDelegate = self
        self.surfaceView.interactiveCanvas.artExportDelegate = self
        self.surfaceView.interactiveCanvas.eraseDelegate = self
        self.surfaceView.paintDelegate = self
        self.surfaceView.palettesDelegate = self
        self.surfaceView.gestureDelegate = self
        self.surfaceView.canvasFrameDelegate = self
        self.surfaceView.canvasEdgeTouchDelegate = self
        self.surfaceView.selectedObjectView = self
        self.surfaceView.selectedObjectMoveView = self
        
        // surfaceView.setInitalScale()
        
        setupBanner()
        
        // menu button
        self.menuButton.setOnClickListener {
            
            if self.surfaceView.isExporting() {
                self.exportButton.toggleState = .none
                self.surfaceView.endExporting()
                
                self.exportButton.highlight = false
            }
//            else if self.surfaceView.isObjectMoveSelection() || self.surfaceView.isObjectMoving() {
//                if self.surfaceView.isObjectMoving() {
//                    self.surfaceView.interactiveCanvas.cancelMoveSelectedObject()
//                }
//                else {
//                    self.surfaceView.startExporting()
//
//                    self.exportButton.toggleState = .single
//                    self.exportButton.layer.borderWidth = 1
//                    self.exportButton.layer.borderColor = UIColor(argb: ActionButtonView.lightYellowColor).cgColor
//                }
//            }
            else {
                /*if SessionSettings.instance.promptBack {
                    self.promptBack()
                }
                else {
                    self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
                }*/
                //self.toggleMenu(show: self.menuContainer.isHidden)
                self.performSegue(withIdentifier: self.showOptions, sender: self)
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
        
        // toolbox
        self.toolboxButton.setOnClickListener {
            self.toggleToolbox(open: self.exportButton.isHidden)
        }
        
        exportButton.isHidden = true
        changeBackgroundButton.isHidden = true
        gridLinesButton.isHidden = true
        summaryButton.isHidden = true
        
        // recent colors
        self.recentColorsButton.setOnClickListener {
            self.toggleRecentColors(open: self.recentColorsContainer.isHidden)
        }
        
        // export
        self.exportButton.setOnClickListener {
            if (self.exportButton.toggleState == .none) {
                self.surfaceView.startExporting()
                self.exportButton.toggleState = .single
                self.exportButton.highlight = true
            }
            else if (self.exportButton.toggleState == .single) {
                self.surfaceView.endExporting()
                self.exportButton.toggleState = .none
                self.exportButton.highlight = false
//                self.surfaceView.startObjectMoveSelection()
//                self.exportAction.toggleState = .double
//                self.exportAction.layer.borderColor = UIColor(argb: ActionButtonView.lightGreenColor).cgColor
            }
//            else if (self.exportAction.toggleState == .double) {
//                self.surfaceView.endObjectMove()
//                self.surfaceView.interactiveCanvas.cancelMoveSelectedObject()
//                self.exportAction.toggleState = .none
//                self.exportAction.layer.borderWidth = 0
//            }
        }
        
        // change background
        self.changeBackgroundButton.setOnClickListener {
            SessionSettings.instance.backgroundColorIndex += 1
            if SessionSettings.instance.backgroundColorIndex == self.surfaceView.interactiveCanvas.numBackgrounds {
                SessionSettings.instance.backgroundColorIndex = 0
            }
            
            if SessionSettings.instance.backgroundColorIndex == InteractiveCanvas.backgroundCustom {
                if SessionSettings.instance.canvasBackgroundPrimaryColor == 0 || SessionSettings.instance.canvasBackgroundSecondaryColor == 0 {
                    SessionSettings.instance.backgroundColorIndex = 0
                }
            }
            
            SessionSettings.instance.darkIcons = (SessionSettings.instance.backgroundColorIndex == 1 || SessionSettings.instance.backgroundColorIndex == 3)
            
            self.updateIconColors()
            
            self.paletteAddColorAction.setNeedsDisplay()
            self.paletteRemoveColorAction.setNeedsDisplay()
            self.objectMoveUpAction.setNeedsDisplay()
            self.objectMoveDownAction.setNeedsDisplay()
            self.objectMoveLeftAction.setNeedsDisplay()
            self.objectMoveRightAction.setNeedsDisplay()
            
            self.palettesViewController.addPaletteAction.setNeedsDisplay()
            
            self.recentColorsViewController.collectionView.reloadData()
            
            self.surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        }
        
        // grid lines
        gridLinesButton.setOnClickListener {
            SessionSettings.instance.showGridLines = !SessionSettings.instance.showGridLines
            
            self.surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        }
        
        // summary
        summaryButton.setOnClickListener {
            if self.summaryView.isHidden {
                self.toggleSummary(show: true)
            }
            else {
                self.toggleSummary(show: false)
            }
            let currentTime = NSDate().timeIntervalSince1970
            if currentTime - self.lastCanvasSummaryUpdate > 60 * 10 {
                self.summaryView.kf.setImage(with: URL(string: "\(self.server!.serviceAltUrl())/canvas"), options: [.forceRefresh])
                self.lastCanvasSummaryUpdate = currentTime
            }
            
        }
        
        // paint panel
        self.paintPanel.isHidden = true
        self.paintPanelButton.setOnClickListener {
            self.togglePaintPanel(open: true)
        }
        
        self.paintPanel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPaintPanel)))
        
        // close paint panel
        self.closePaintPanelButton.setOnClickListener {
            self.togglePaintPanel(open: false)
        }
        
        // paint quantity meter
        let paintIndicatorTap = UITapGestureRecognizer(target: self, action: #selector(didTapColorIndicator(sender:)))
        self.paintColorIndicator.addGestureRecognizer(paintIndicatorTap)
        
        self.paintColorAccept.isHidden = true
        self.paintColorCancel.isHidden = true
        
        // palette
        paletteAddColorAction.type = .add
        paletteAddColorAction.darkIcons = false
        paletteAddColor.actionButtonView = paletteAddColorAction
        
        paletteAddColor.setOnClickListener {
            if SessionSettings.instance.palette.colors.count < Palette.maxColors {
                SessionSettings.instance.palette.addColor(color: SessionSettings.instance.paintColor)
                self.syncPaletteAndColor()
            }
        }
        
        paletteRemoveColorAction.type = .remove
        paletteRemoveColorAction.darkIcons = false
        paletteRemoveColor.actionButtonView = paletteRemoveColorAction
        
        paletteRemoveColor.setOnClickListener {
            self.showPaletteColorRemoveAlert(color: SessionSettings.instance.paintColor)
        }
        
        // lock paint panel
        if SessionSettings.instance.lockPaintPanel {
            lockPaintPanelAction.type = .lockClose
        }
        else {
            lockPaintPanelAction.type = .lockOpen
        }
        lockPaintPanel.actionButtonView = lockPaintPanelAction
        
        lockPaintPanel.setOnClickListener {
            SessionSettings.instance.lockPaintPanel = !SessionSettings.instance.lockPaintPanel
            
            if SessionSettings.instance.lockPaintPanel {
                self.lockPaintPanelAction.type = .lockClose
            }
            else {
                self.lockPaintPanelAction.type = .lockOpen
            }
        }
        
        // summary
        //summaryView.interactiveCanvas = surfaceView.interactiveCanvas
        deviceViewportSummaryView.interactiveCanvas = surfaceView.interactiveCanvas
        
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
        
        //self.paintColorAcceptAction.touchDelegate = self.paintColorIndicator
        
        var tgr = UITapGestureRecognizer(target: self, action: #selector(didTapColorPaletteTitle))
        colorPaletteTitleLabel.addGestureRecognizer(tgr)
        
        colorPaletteTitleLabel.text = SessionSettings.instance.palette.displayName
        self.syncPaletteAndColor()
        
        // paint event time toggle
        tgr = UITapGestureRecognizer(target: self, action: #selector(didTapPaintQuantityBar))
        
        if SessionSettings.instance.showPaintCircle {
            //self.paintQuantityCircle.addGestureRecognizer(tgr)
        }
        else if SessionSettings.instance.showPaintBar {
            //self.paintQuantityBar.addGestureRecognizer(tgr)
        }
        
        StatTracker.instance.achievementListener = self
        
        //InteractiveCanvasSocket.instance.socketStatusDelegate = self
        
        if world {
            //self.startServerStatusChecks()
            
            //getPaintTimerInfo()
        }
        else {
            singlePlaySaveTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true, block: { (tmr) in
                self.surfaceView.interactiveCanvas.save()
            })
            
            if SessionSettings.instance.showPaintCircle {
                //self.paintQuantityCircle.removeGestureRecognizer(tgr)
            }
            else if SessionSettings.instance.showPaintBar {
                //self.paintQuantityBar.removeGestureRecognizer(tgr)
            }
        }
        
        var pgr = UIPanGestureRecognizer(target: self, action: #selector(didPanMenuContainer(sender:)))
        menuContainer.addGestureRecognizer(pgr)
        
        lastViewFrameSize = CGSize(width: 0, height: 0)
        
        applyOptions(fromUnwind: false)
    }
    
    override func viewDidLayoutSubviews() {
        if initial {
            layoutSubviews()
            
            initial = false
        }
        
        // rotation
        if lastViewFrameSize.width != view!.frame.size.width || lastViewFrameSize.height != view!.frame.size.height {
            setPaintPanelBackground(adjust: false)
            
            surfaceView.interactiveCanvas.updateDeviceViewport(screenSize: view!.frame.size)
            self.surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
            lastViewFrameSize = view!.frame.size
            
            self.deviceViewportSummaryView.setNeedsDisplay()
            self.surfaceView.interactiveCanvas.notifyDeviceViewportUpdate()
            
            self.paintColorIndicator.setNeedsDisplay()
        }
    }
    
    func layoutSubviews() {
        if SessionSettings.instance.rightHanded {
            // right-handed
            
            canvasLockLeading.isActive = false
            canvasLockTrailing.isActive = false
            
            canvasLockLeadingRight.isActive = true
            canvasLockTrailingRight.isActive = true
            
            // paint panel
            paintPanelTrailing.isActive = false
            paintPanelLeading.isActive = true
            
            // close paint panel
            closePaintPanelButton.transform = CGAffineTransform.init(rotationAngle: CGFloat(180 * Double.pi / 180.0))
            
            // color picker frame
            colorPIckerFrameLeading.isActive = false
            colorPickerFrameTrailing.isActive = true
            
            // toolbox button
            toolboxButtonLeading.isActive = true
            toolboxButtonTrailing.isActive = false
            
            // toolbox action
            toolboxActionLeading.isActive = true
            toolboxActionTrailing.isActive = false
            
            // recent colors button
            recentColorsButtonLeading.isActive = false
            recentColorsButtonTrailing.isActive = true
            
            // recent colors action
            recentColorsActionLeading.isActive = false
            recentColorsActionTrailing.isActive = true
            
            // recent colors container
            recentColorsContainerLeading.isActive = false
            recentColorsContainerTrailing.isActive = true
            
            // summary view
            summaryViewLeading.isActive = false
            summaryViewTrailing.isActive = true
            
            // device viewport view
            deviceViewportSummaryViewLeading.isActive = false
            deviceViewportSummaryViewTrailing.isActive = true
            
            // toolbox buttons
            let leadingConstraints = [exportButtonLeading, exportActionLeading, changeBackgroundButtonLeading,  changeBackgroundActionLeading, gridLinesButtonLeading, gridLinesActionLeading, summaryButtonLeading,
                summaryActionLeading]
            let trailingConstraints = [exportButtonTrailing, exportActionTrailing, changeBackgroundButtonTrailing, changeBackgroundActionTrailing, gridLinesButtonTrailing, gridLinesActionTrailing, summaryButtonTrailing,
                summaryActionTrailing]
            
            for i in 0...trailingConstraints.count - 1 {
                let leadingConstraint = leadingConstraints[i]!
                let trailingConstraint = trailingConstraints[i]!
                
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }
            
            // paint qty bar
            paintQuantityBar.transform = CGAffineTransform.init(rotationAngle: CGFloat(180 * Double.pi / 180.0))
        }
        else {
            // left-handed
            
            canvasLockLeading.isActive = true
            canvasLockTrailing.isActive = true
            
            canvasLockLeadingRight.isActive = false
            canvasLockTrailingRight.isActive = false
            
            // paint panel
            paintPanelLeading.isActive = false
            paintPanelTrailing.isActive = true
            
            // close paint panel
            closePaintPanelButton.transform = CGAffineTransform.init(rotationAngle: CGFloat(0 * Double.pi / 180.0))
            
            // color picker frame
            colorPIckerFrameLeading.isActive = true
            colorPickerFrameTrailing.isActive = false
            
            // toolbox button
            toolboxButtonLeading.isActive = false
            toolboxButtonTrailing.isActive = true
            
            // toolbox action
            toolboxActionLeading.isActive = false
            toolboxActionTrailing.isActive = true
            
            // recent colors button
            recentColorsButtonLeading.isActive = true
            recentColorsButtonTrailing.isActive = false
            
            // recent colors action
            recentColorsActionLeading.isActive = true
            recentColorsActionTrailing.isActive = false
            
            // recent colors container
            recentColorsContainerLeading.isActive = true
            recentColorsContainerTrailing.isActive = false
            
            // summary view
            summaryViewLeading.isActive = true
            summaryViewTrailing.isActive = false
            
            // device viewport view
            deviceViewportSummaryViewLeading.isActive = true
            deviceViewportSummaryViewTrailing.isActive = false
            
            // toolbox buttons
            let leadingConstraints = [exportButtonLeading, changeBackgroundButtonLeading, gridLinesButtonLeading, summaryButtonLeading]
            let trailingConstraints = [exportButtonTrailing, changeBackgroundButtonTrailing, gridLinesButtonTrailing, summaryButtonTrailing]
            
            for i in 0...leadingConstraints.count - 1 {
                let leadingConstraint = leadingConstraints[i]!
                let trailingConstraint = trailingConstraints[i]!
                
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
            
            // paint qty bar
            paintQuantityBar.transform = CGAffineTransform.init(rotationAngle: CGFloat(0 * Double.pi / 180.0))
        }
        
        // small action buttons
//        if SessionSettings.instance.smallActionButtons {
//            paintColorAcceptActionWidth.constant = paintColorAcceptActionWidth.constant * 0.833
//            paintColorAcceptActionHeight.constant = paintColorAcceptActionHeight.constant * 0.833
//
//            paintYesActionWidth.constant = paintYesActionWidth.constant * 0.833
//            paintYesActionHeight.constant = paintYesActionHeight.constant * 0.833
//
//            paintNoActionWidth.constant = paintNoActionWidth.constant * 0.833
//            paintNoActionHeight.constant = paintNoActionHeight.constant * 0.833
//
//            paintColorCancelActionWidth.constant = paintColorCancelActionWidth.constant * 0.833
//            paintColorCancelActionHeight.constant = paintColorCancelActionHeight.constant * 0.833
//
//            closePaintPanelActionWidth.constant = closePaintPanelActionWidth.constant * 0.833
//            closePaintPanelActionHeight.constant = closePaintPanelActionHeight.constant * 0.833
//        }
        
        setPaintPanelBackground(adjust: false)
        surfaceView.setInitalPositionAndScale()
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if SessionSettings.instance.saveCanvas {
            surfaceView.interactiveCanvas.save()
            
            SessionSettings.instance.saveCanvas = false
        }
        
        if SessionSettings.instance.reloadCanvas {
            surfaceView.interactiveCanvas.reload()
            surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
            
            SessionSettings.instance.reloadCanvas = false
        }
        
        applyOptions(fromUnwind: true)
    }
    
    func applyOptions(fromUnwind: Bool) {
        SessionSettings.instance.darkIcons = (SessionSettings.instance.backgroundColorIndex == 1 || SessionSettings.instance.backgroundColorIndex == 3)
        
        self.updateIconColors()
        
        panelThemeConfig = themeConfigFromBackground()
        
        // panel theme config
        if panelThemeConfig.actionButtonColor == ActionButtonView.blackColor {
            paintColorAccept.isLight = false
            paintColorCancel.isLight = false
            closePaintPanelButton.isLight = false
            paintYes.isLight = false
            paintNo.isLight = false
            
            paletteAddColorAction.colorMode = .black
            paletteRemoveColorAction.colorMode = .black
            lockPaintPanelAction.colorMode = .black
            
            closePaintPanelButton.isLight = false
            
            colorPaletteTitleLabel.textColor = UIColor.black
        }
        else {
            paintColorAccept.isLight = true
            paintColorCancel.isLight = true
            closePaintPanelButton.isLight = true
            paintYes.isLight = true
            paintNo.isLight = true
            
            paletteAddColorAction.colorMode = .white
            paletteRemoveColorAction.colorMode = .white
            lockPaintPanelAction.colorMode = .white
            
            closePaintPanelButton.isLight = true
            
            colorPaletteTitleLabel.textColor = UIColor.white
        }
        
        self.updatePaintColorAcceptColorMode(color: SessionSettings.instance.paintColor)
        
        self.paintQuantityCircle.panelThemeConfig = panelThemeConfig
        self.paintQuantityCircle.setNeedsDisplay()
        
        self.paintQuantityBar.panelThemeConfig = panelThemeConfig
        self.paintQuantityBar.setNeedsDisplay()
        
        self.paintColorIndicator.panelThemeConfig = panelThemeConfig
        
        self.colorPicker(self.colorPickerViewController.colorPicker, selectedColor: self.colorPickerViewController.selectedColor, usingControl: self.colorPickerViewController.colorPicker.radialHsbPalette!)
        
        // paint quantity meter
        SessionSettings.instance.paintQtyDelegates.removeAll()
        
        if SessionSettings.instance.showPaintBar {
            SessionSettings.instance.paintQtyDelegates.append(paintQuantityBar)
            
            paintQuantityBar.isHidden = false
            paintQuantityCircle.isHidden = true
        }
        else if SessionSettings.instance.showPaintCircle {
            SessionSettings.instance.paintQtyDelegates.append(paintQuantityCircle)
            
            paintInfoContainerTop.constant -= 15
            
            paintQuantityBar.isHidden = true
            paintQuantityCircle.isHidden = false
        }
        else {
            paintQuantityCircle.isHidden = true
            paintQuantityBar.isHidden = true
        }
        
        // bocker lock
        if SessionSettings.instance.canvasLockBorder {
            canvasLockView.layer.borderWidth = 4
            canvasLockView.layer.borderColor = UIColor(argb: SessionSettings.instance.canvasLockColor).cgColor
            canvasLockView.layer.cornerRadius = 40
        }
        
        // close button color
        if SessionSettings.instance.paintPanelCloseButtonColor != 0 {
            closePaintPanelButton.color = SessionSettings.instance.paintPanelCloseButtonColor
        }
        
        self.surfaceView.interactiveCanvas.updateRecentColors()
        self.setupColorPalette(colors: self.surfaceView.interactiveCanvas.recentColors)
        
        self.summaryView.setNeedsDisplay()
        self.deviceViewportSummaryView.setNeedsDisplay()
        
        if fromUnwind {
            layoutSubviews()
            
            palettesViewController.updatePanelThemeConfig(panelThemeConfig: panelThemeConfig)
            canvasFrameViewController.updatePanelThemeConfig(panelThemeConfig: panelThemeConfig)
        }
        
        self.surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
        
    @objc func didPanMenuContainer(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            lastPanTranslationX = 0
            lastPanTranslationY = 0
        }
        else if sender.state == .changed {
            let translation = sender.translation(in: sender.view!)
            
            let translateX = lastPanTranslationX - translation.x
            let translateY = lastPanTranslationY - translation.y
            
            if menuContainer.frame.origin.x - translateX >= 0 && menuContainer.frame.origin.x + menuContainer.frame.size.width - translateX <= view.frame.size.width {
                menuContainerCenterX.constant -= translateX
            }
            
            if menuContainer.frame.origin.y - translateY >= 0 && menuContainer.frame.origin.y + menuContainer.frame.size.height - translateY <= view.frame.size.height {
                menuContainerCenterY.constant -= translateY
            }
            
            lastPanTranslationX = translation.x
            lastPanTranslationY = translation.y
        }
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
    
    @objc func didTapColorPaletteTitle() {
        self.togglePalettesView(show: true)
    }
    
    @objc func didTapPaintPanel() {
        self.togglePalettesView(show: false)
    }
    
//    func startServerStatusChecks() {
//        statusCheckTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (tmr) in
//            let connected = Utils.isNetworkAvailable()
//            if !connected {
//                DispatchQueue.main.async {
//                    self.showDisconnectedMessage(type: 0)
//                }
//            }
//            else {
//                URLSessionHandler.instance.sendApiStatusCheck { (success) -> (Void) in
//                    if !success {
//                        self.showDisconnectedMessage(type: 1)
//                    }
//                    else {
//                        if self.world {
//                            InteractiveCanvasSocket.instance.sendSocketStatusCheck()
//                        }
//                    }
//                }
//            }
//        })
//    }
    
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
    
    /*func getPaintTimerInfo() {
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
    }*/
    
    func setDefaultColorsClickListeners() {
        colorPickerViewController.defaultBlackButton.setOnClickListener {
            self.colorPickerViewController.selectedColor = UIColor.black
            self.colorPicker(self.colorPickerViewController.colorPicker, selectedColor: self.colorPickerViewController.selectedColor, usingControl: self.colorPickerViewController.colorPicker.radialHsbPalette!)
        }
        
        colorPickerViewController.defaultWhiteButton.setOnClickListener {
            self.colorPickerViewController.selectedColor = UIColor.white
            self.colorPicker(self.colorPickerViewController.colorPicker, selectedColor: self.colorPickerViewController.selectedColor, usingControl: self.colorPickerViewController.colorPicker.radialHsbPalette!)
        }
    }
    
    // embeds
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ColorPickerEmbed" {
            colorPickerViewController = segue.destination as! ColorPickerOutletsViewController
            colorPickerViewController.delegate = self
            colorPickerViewController.layoutDelegate = self
            colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.paintColor)
            colorPickerViewController.view.backgroundColor = UIColor.black
            
            //setDefaultColorsClickListeners()
        }
        else if segue.identifier == "PixelHistoryEmbed" {
            segue.destination.modalPresentationStyle = .overCurrentContext
            self.pixelHistoryViewController = segue.destination as? PixelHistoryViewController
            self.pixelHistoryViewController.server = server
        }
        else if segue.identifier == "RecentColorsEmbed" {
            self.recentColorsViewController = segue.destination as? RecentColorsViewController
            self.recentColorsViewController.delegate = self
        }
        else if segue.identifier == "ExportEmbed" {
            self.exportViewController = segue.destination as? ExportViewController
            self.exportViewController.delegate = self
        }
        else if segue.identifier == "PalettesEmbed" {
            self.palettesViewController = segue.destination as? PalettesViewController
            self.palettesViewController.delegate = self
            self.palettesViewController.panelThemeConfig = themeConfigFromBackground()
        }
        else if segue.identifier == "CanvasFrameEmbed" {
            self.canvasFrameViewController = segue.destination as? CanvasFrameViewController
            self.canvasFrameViewController.delegate = self
            self.canvasFrameViewController.panelThemeConfig = themeConfigFromBackground()
        }
        else if segue.identifier == "MenuEmbed" {
            menuViewController = segue.destination as? MenuViewController
            menuViewController.menuButtonDelegate = self
            menuViewController.fromInteractiveCanvas = true
        }
        else if segue.identifier == "UnwindToMenu" {
            surfaceView.interactiveCanvas.saveDeviceViewport()
            
            SessionSettings.instance.save()
            
            StatTracker.instance.achievementListener = nil
            
            if world {
                InteractiveCanvasSocket.instance.socket!.disconnect()
                
                statusCheckTimer?.invalidate()
            }
            
            else {
                surfaceView.interactiveCanvas.save()
                
                singlePlaySaveTimer.invalidate()
            }
            
            SessionSettings.instance.interactiveCanvas = nil
            
            SessionSettings.instance.canvasOpen = false
        }
        else if segue.identifier == "ShowOptions" {
            segue.destination.isModalInPresentation = true
            
            (segue.destination as! OptionsViewController).fromCanvas = true
        }
        else if segue.identifier == "ShowHowto" {
            segue.destination.isModalInPresentation = true
            
            (segue.destination as! HowtoViewController).fromCanvas = true
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
            colorPickerFrameWidth.constant *= 2
            
            colorPickerViewController.hsbWheelWidth.constant *= 2
            colorPickerViewController.hsbWheelHeight.constant *= 2
            
            colorPickerViewController.hsbWheelXCenter.constant = 0
            colorPickerViewController.hsbWheelYCenter.constant = 0
            
            colorPickerViewController.brightnessSliderWidth.constant *= 2
            
            resizedColorPicker = true
        }
        else if view.frame.size.height > 600 {
            colorPickerFrameWidth.constant = 330 * 2
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
        
        self.colorPickerViewController.colorHexTextField.delegate = self
        
        self.surfaceView.startPaintSelection()
    }
    
    func closeColorPicker() {
        self.colorPickerFrameWidth.constant = 0
        
        self.colorPickerFrame.isHidden = true
        self.paintColorAccept.isHidden = true
        self.paintColorCancel.isHidden = true
        
        if self.surfaceView.interactiveCanvas.restorePoints.count == 0 {
            self.closePaintPanelButton.isHidden = false
        }
    }
    
    func togglePaintPanel(open: Bool, softHide: Bool = false) {
        if open {
            self.paintPanelButton.isHidden = true
            
            self.paintPanelWidth.constant = 200
            
            self.paintPanel.isHidden = false
            
            self.pixelHistoryView.isHidden = true
            
            self.menuButton.isHidden = true
            
            if SessionSettings.instance.canvasLockBorder {
                self.canvasLockView.isHidden = false
            }
            
            self.toggleSummary(show: false)
            
            self.toggleToolbox(open: false)
            
            toolboxButton.isHidden = false
            
            self.hideCanvasFrameView()
            
            //toggleMenu(show: false)
            
            self.surfaceView.startPainting()
            
            SessionSettings.instance.paintPanelOpen = true
        }
        else if softHide {
            self.paintPanel.isHidden = true
            
            self.paintPanelWidth.constant = 0
            
            self.toolboxButton.isHidden = true
            
            //toggleToolbox(open: false)
        }
        else {
            self.surfaceView.endPainting(accept: false)
            
            self.paintPanelButton.isHidden = false
            
            self.menuButton.isHidden = false
            
            self.toggleRecentColors(open: false)
            
            self.paintPanel.isHidden = true
            if SessionSettings.instance.canvasLockBorder {
                self.canvasLockView.isHidden = true
            }
            
            self.togglePalettesView(show: false)
            
            SessionSettings.instance.paintPanelOpen = false
        }
    }
    
    func togglePalettesView(show: Bool) {
        if show {
            palettesViewController.palettes = SessionSettings.instance.palettes
            palettesViewController.reset()
        }
        else {
            syncPaletteAndColor()
        }
        palettesView.isHidden = !show
    }
    
    func toggleToolbox(open: Bool) {
        if open {
            exportButton.isHidden = false
            changeBackgroundButton.isHidden = false
            gridLinesButton.isHidden = false
            summaryButton.isHidden = false
            
            if SessionSettings.instance.rightHanded {
                Animator.animateMenuButtons(views: [[exportButton], [changeBackgroundButton], [gridLinesButton],
                    [summaryButton]], cascade: false, moveOut: false, inverse: true)
            }
            else {
                Animator.animateMenuButtons(views: [[exportButton], [changeBackgroundButton], [gridLinesButton],
                    [summaryButton]], cascade: false, moveOut: false, inverse: false)
            }
        }
        else {
            if SessionSettings.instance.rightHanded {
                Animator.animateMenuButtons(views: [[exportButton], [changeBackgroundButton], [gridLinesButton],
                    [summaryButton]], cascade: false, moveOut: true, inverse: true)
            }
            else {
                Animator.animateMenuButtons(views: [[exportButton], [changeBackgroundButton], [gridLinesButton],
                    [summaryButton]], cascade: false, moveOut: true, inverse: false)
            }
        }
        SessionSettings.instance.toolboxOpen = open
    }
    
    func toggleRecentColors(open: Bool) {
        if open {
            self.recentColorsImage.isHidden = true
            self.recentColorsContainer.isHidden = false
            
            if (paintPanel.isHidden) {
                self.togglePaintPanel(open: true)
            }
        }
        else {
            self.recentColorsImage.isHidden = false
            self.recentColorsContainer.isHidden = true
        }
    }
    
    func toggleSummary(show: Bool) {
        summaryView.isHidden = !show
        deviceViewportSummaryView.isHidden = !show
        
        if show {
            
        }
    }
    
    func toggleMenu(show: Bool) {
        menuContainer.isHidden = !show
    }

    override func viewDidAppear(_ animated: Bool) {
        self.surfaceView.backgroundColor = UIColor.red
        
        if !SessionSettings.instance.selectedHand {
            self.toggleMenu(show: true)
        }
        else {
            self.toggleToolbox(open: SessionSettings.instance.toolboxOpen)
            self.togglePaintPanel(open: SessionSettings.instance.paintPanelOpen)
        }
    }
    
    // menu button delegate
    func menuButtonPressed(menuButtonType: MenuButtonType) {
        if menuButtonType == .options {
            self.performSegue(withIdentifier: showOptions, sender: nil)
        }
        else if menuButtonType == .howto {
            self.performSegue(withIdentifier: showHowto, sender: nil)
        }
        else if menuButtonType == .lefty {
            self.applyOptions(fromUnwind: true)
            self.menuViewController.showMenuButtons()
        }
        else if menuButtonType == .righty {
            self.applyOptions(fromUnwind: true)
            self.menuViewController.showMenuButtons()
        }
        
        self.surfaceView.interactiveCanvas.saveDeviceViewport()
        self.toggleMenu(show: false)
    }
    
    // paint delegate
    func notifyPaintingStarted() {
        self.closePaintPanelButton.isHidden = true
        self.paintYes.isHidden = false
        self.paintNo.isHidden = false
    }
    
    func notifyPaintingEnded(accept: Bool) {
        self.closePaintPanelButton.isHidden = false
        self.paintYes.isHidden = true
        self.paintNo.isHidden = true
        
        if accept {
            summaryView.setNeedsDisplay()
        }
    }
    
    func notifyPaintColorUpdate() {
        self.paintColorIndicator.setPaintColor(color: SessionSettings.instance.paintColor)
        colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.paintColor)
        
        self.colorPicker(self.colorPickerViewController.colorPicker, selectedColor: self.colorPickerViewController.selectedColor, usingControl: self.colorPickerViewController.colorPicker.radialHsbPalette!)
    }
    
    // color picker delegate
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        let color = selectedColor.argb()
        
        SessionSettings.instance.paintColor = color
        self.paintColorIndicator.setNeedsDisplay()
        
        self.updatePaintColorAcceptColorMode(color: color)
        
        self.colorPickerViewController.colorHexTextField.text = UIColor(argb: color).hexString()
        
        self.syncPaletteAndColor()
    }
    
    func updatePaintColorAcceptColorMode(color: Int32) {
        if PaintColorIndicator.isColorLight(color: color) && panelThemeConfig.actionButtonColor == ActionButtonView.whiteColor {
            paintColorAccept.isLight = false
        }
        else if panelThemeConfig.actionButtonColor == ActionButtonView.whiteColor {
            paintColorAccept.isLight = true
        }
        else if PaintColorIndicator.isColorDark(color: color) && panelThemeConfig.actionButtonColor == ActionButtonView.blackColor {
            paintColorAccept.isLight = true
        }
        else if panelThemeConfig.actionButtonColor == ActionButtonView.blackColor {
            paintColorAccept.isLight = false
        }
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
        if SessionSettings.instance.selectedPaletteIndex == 0 {
            self.setupColorPalette(colors: recentColors)
        }
    }
    
    func setupColorPalette(colors: [Int32]) {
        let itemWidth = CGFloat(10 * SessionSettings.instance.colorPaletteSize)
        let itemHeight = itemWidth
        
        self.recentColorsViewController.itemWidth = itemWidth
        let margin = self.recentColorsViewController.itemMargin
        
        self.recentColorsContainerWidth.constant = itemWidth * 4 + margin * 3
        
        let numRows = (colors.count - 1) / 4 + 1
        self.recentColorsContainerHeight.constant = itemHeight * CGFloat(numRows) + margin * CGFloat(numRows - 1)
        
        self.recentColorsViewController.data = colors.reversed()
        self.recentColorsViewController.collectionView.reloadData()
    }
    
    // recent colors delegate
    func notifyRecentColorSelected(color: Int32) {
        self.notifyPaintColorUpdate()
        self.colorPickerViewController.selectedColor = UIColor(argb: color)
        
        self.toggleRecentColors(open: false)
    }
    
    // export view controller delegate
    func notifyExportViewControllerBackPressed() {
        exportContainer.isHidden = true
        
        self.exportButton.toggleState = .none
        self.exportButton.layer.borderWidth = 0
        
        surfaceView.endExporting()
    }
    
    // art export delegate
    func notifyArtExported(art: [InteractiveCanvas.RestorePoint]) {
        exportButton.highlight = false
        
        exportViewController.art = art
        exportContainer.isHidden = false
        
        self.toggleSummary(show: false)
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
        
        if !SessionSettings.instance.lockPaintPanel {
            self.togglePaintPanel(open: false, softHide: true)
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
            backgroundImage.contentMode = .scaleAspectFill
        }
        
        if paintPanelBackgroundSet {
            self.paintPanel.subviews[0].removeFromSuperview()
        }
        
        self.paintPanel.insertSubview(backgroundImage, at: 0)
        
        paintPanelBackgroundSet = true
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
    
    func setColorFromHexString(hexString: String) {
        self.colorPickerViewController.selectedColor = UIColor(hexString: hexString)
        
        self.colorPicker(self.colorPickerViewController.colorPicker, selectedColor: self.colorPickerViewController.selectedColor, usingControl: self.colorPickerViewController.colorPicker.radialHsbPalette!)
    }
    
    @objc func textFieldDidChange() {
        let textField = self.colorPickerViewController.colorHexTextField!
        let range = NSRange(location: 0, length: textField.text!.count)
        let regex = try! NSRegularExpression(pattern: "[A-F0-9]{6}")
        
        let result = regex.firstMatch(in: textField.text!, options: [], range: range)
    
        if result != nil && textField.text!.count == 6 {
            self.setColorFromHexString(hexString: textField.text!)
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // color picker layout delegate
    func colorPickerDidLayoutSubviews(colorPickerViewController: ColorPickerOutletsViewController) {
        colorPickerViewController.colorHexTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        colorPickerViewController.delegate = self
    }
    
    // palettes delegate
    func isPalettesViewControllerVisible() -> Bool {
        return !palettesView.isHidden
    }
    
    func notifyClosePalettesViewController() {
        self.togglePalettesView(show: false)
    }
    
    // palettes view controller delegate
    func notifyPaletteSelected(palette: Palette, index: Int) {
        self.togglePalettesView(show: false)
    }
    
    func syncPaletteAndColor() {
        // set title
        self.colorPaletteTitleLabel.text = SessionSettings.instance.palette.displayName
        
        // sync buttons color palette
        if SessionSettings.instance.selectedPaletteIndex == 0 {
            paletteAddColor.isHidden = true
            paletteRemoveColor.isHidden = true
            
            self.lockPaintPanelCenterX.constant = 0
            
            self.setupColorPalette(colors: self.surfaceView.interactiveCanvas.recentColors)
        }
        else {
            if SessionSettings.instance.palette.colors.contains(SessionSettings.instance.paintColor) {
                paletteAddColor.isHidden = true
                paletteRemoveColor.isHidden = false
            }
            else {
                paletteAddColor.isHidden = false
                paletteRemoveColor.isHidden = true
            }
            
            self.lockPaintPanelCenterX.constant = 20
            
            self.setupColorPalette(colors: SessionSettings.instance.palette.colors)
        }
    }
    
    func showPaletteColorRemoveAlert(color: Int32) {
        let palette = SessionSettings.instance.palette!
        let alertVC = UIAlertController(title: nil, message: "Remove this color from " + palette.name + "?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            SessionSettings.instance.palette.removeColor(color: color)
            self.syncPaletteAndColor()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // scale delegate
    func notifyInteractiveCanvasPan() {
        deviceViewportSummaryView.setNeedsDisplay()
        hideCanvasFrameView()
    }
    
    func notifyInteractiveCanvasScale() {
        deviceViewportSummaryView.setNeedsDisplay()
    }
    
    func notifyToggleCanvasFrameView(canvasX: Int, canvasY: Int, screenPoint: CGPoint) {
        if !canvasFrameView.isHidden {
            hideCanvasFrameView()
            return
        }
        
        self.canvasFrameViewController.x = canvasX
        self.canvasFrameViewController.y = canvasY
        self.canvasFrameViewController.canvasFrameViewTop = canvasFrameViewTop
        
        var x = screenPoint.x + 10
        var y = screenPoint.y - 130
        
        if x < 20 {
            x = 20
        }
        else if x + canvasFrameView.frame.size.width > self.view.frame.size.width - 20 {
            x = self.view.frame.size.width - canvasFrameView.frame.size.width - 20
        }
        
        if y < 20 {
            y = 20
        }
        else if y + canvasFrameView.frame.size.height > self.view.frame.size.height - 20 {
            y = self.view.frame.size.height - canvasFrameView.frame.size.height - 20
        }
        
        canvasFrameViewLeading.constant = x
        canvasFrameViewTop.constant = y
        
        canvasFrameView.isHidden = false
    }
    
    func notifyCloseCanvasFrameView() {
        hideCanvasFrameView()
    }
    
    func hideCanvasFrameView() {
        canvasFrameViewController.closeKeyboard()
        canvasFrameView.isHidden = true
    }
    
    func createCanvasFrame(centerX: Int, centerY: Int, width: Int, height: Int) {
        print("create frame at (" + String(centerX) + ", " + String(centerY) + ") width =" + String(width) + ", height = " + String(height))
        
        surfaceView.createCanvasFrame(centerX: centerX, centerY: centerY, width: width, height: height, color: SessionSettings.instance.frameColor)
        
        hideCanvasFrameView()
    }
    
    func onTouchCanvasEdge() {
        togglePaintPanel(open: true)
    }
    
    func updateIconColors() {
        if !SessionSettings.instance.darkIcons {
            self.menuButton.isLight = true
            self.paintPanelButton.isLight = true
            self.toolboxButton.isLight = true
            self.recentColorsButton.isLight = true
            self.exportButton.isLight = true
            self.changeBackgroundButton.isLight = true
            self.gridLinesButton.isLight = true
            self.summaryButton.isLight = true
        }
        else {
            self.menuButton.isLight = false
            self.paintPanelButton.isLight = false
            self.toolboxButton.isLight = false
            self.recentColorsButton.isLight = false
            self.exportButton.isLight = false
            self.changeBackgroundButton.isLight = false
            self.gridLinesButton.isLight = false
            self.summaryButton.isLight = false
        }
    }
    
    // selected object view
    func showSelectedObjectYesAndNoButtons(screenPoint: CGPoint) {
        selectedObjectYesButton.actionButtonView = selectedObjectYesAction
        selectedObjectNoButton.actionButtonView = selectedObjectNoAction
        
        selectedObjectYesAction.type = .yes
        selectedObjectYesAction.colorMode = .color
        
        selectedObjectNoAction.type = .no
        selectedObjectNoAction.colorMode = .color
        
        selectedObjectYesNoContainerLeading.constant = screenPoint.x - selectedObjectYesNoContainer.frame.size.width / 2
        selectedObjectYesNoContainerTop.constant = screenPoint.y - selectedObjectYesNoContainer.frame.size.height / 2
        
        selectedObjectYesButton.setOnClickListener {
            self.surfaceView.interactiveCanvas.endMoveSelection(confirm: true)
        }
        
        selectedObjectNoButton.setOnClickListener {
            self.surfaceView.interactiveCanvas.endMoveSelection(confirm: false)
        }
        
        selectedObjectYesNoContainer.layer.cornerRadius = 10
        selectedObjectYesNoContainer.layer.borderWidth = 1
        selectedObjectYesNoContainer.layer.borderColor = UIColor(argb: Utils.int32FromColorHex(hex: "0x99FFFFFF")).cgColor
        
        selectedObjectYesNoContainer.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0x33000000"))
        
        selectedObjectYesNoContainer.isHidden = false
    }
    
    func hideSelectedObjectYesAndNoButtons() {
        selectedObjectYesNoContainer.isHidden = true
    }
    
    func selectedObjectEnded() {
        
    }
    
    // selected object move view
    func showSelectedObjectMoveButtons(bounds: CGRect) {
        let buttons = [objectMoveUpButton, objectMoveDownButton, objectMoveLeftButton, objectMoveRightButton]
        let actions = [objectMoveUpAction, objectMoveDownAction, objectMoveLeftAction, objectMoveRightAction]
        
        for i in 0...buttons.count - 1 {
            let button = buttons[i]!
            let action = actions[i]!
            
            button.actionButtonView = action
            action.type = .solid
            button.isHidden = false
        }
        
        objectMoveUpButton.setOnClickListener {
            self.surfaceView.interactiveCanvas.moveSelection(direction: .up)
        }
        
        objectMoveDownButton.setOnClickListener {
            self.surfaceView.interactiveCanvas.moveSelection(direction: .down)
        }
        
        objectMoveLeftButton.setOnClickListener {
            self.surfaceView.interactiveCanvas.moveSelection(direction: .left)
        }
        
        objectMoveRightButton.setOnClickListener {
            self.surfaceView.interactiveCanvas.moveSelection(direction: .right)
        }
        
        let cX = bounds.origin.x + bounds.width / 2
        let cY = bounds.origin.y + bounds.height / 2
        
        //objectMoveLeftButton.backgroundColor = UIColor.red
        //objectMoveRightButton.backgroundColor = UIColor.yellow
        
        objectMoveUpButtonLeading.constant = cX - objectMoveUpButton.frame.size.width / 2
        objectMoveUpButtonTop.constant = bounds.origin.y - objectMoveUpButton.frame.size.height - 20
        
        objectMoveDownButtonLeading.constant = cX - objectMoveDownButton.frame.size.width / 2
        objectMoveDownButtonTop.constant = bounds.origin.y + bounds.size.height + 20
        
        objectMoveLeftButtonLeading.constant = bounds.origin.x - 20 - objectMoveLeftButton.frame.size.width
        objectMoveLeftButtonTop.constant = cY - objectMoveLeftButton.frame.size.height / 2
        
        objectMoveRightButtonLeading.constant = bounds.origin.x + bounds.size.width + 20
        objectMoveRightButtonTop.constant = cY - objectMoveRightButton.frame.size.height / 2
    }
    
    func updateSelectedObjectMoveButtons(bounds: CGRect) {
        let cX = bounds.origin.x + bounds.width / 2
        let cY = bounds.origin.y + bounds.height / 2
        
        objectMoveUpButtonLeading.constant = cX - objectMoveUpButton.frame.size.width / 2
        objectMoveUpButtonTop.constant = bounds.origin.y - objectMoveUpButton.frame.size.height - 20
        
        objectMoveDownButtonLeading.constant = cX - objectMoveDownButton.frame.size.width / 2
        objectMoveDownButtonTop.constant = bounds.origin.y + bounds.size.height + 20
        
        objectMoveLeftButtonLeading.constant = bounds.origin.x - 20 - objectMoveLeftButton.frame.size.width
        objectMoveLeftButtonTop.constant = cY - objectMoveLeftButton.frame.size.height / 2
        
        objectMoveRightButtonLeading.constant = bounds.origin.x + bounds.size.width + 20
        objectMoveRightButtonTop.constant = cY - objectMoveRightButton.frame.size.height / 2
    }
    
    func hideSelectedObjectMoveButtons() {
        objectMoveUpButton.isHidden = true
        objectMoveDownButton.isHidden = true
        objectMoveLeftButton.isHidden = true
        objectMoveRightButton.isHidden = true
    }
    
    func selectedObjectMoveEnded() {
        self.exportButton.toggleState = .none
        self.exportButton.layer.borderWidth = 0
    }
    
    // socket connection delegate
    func notifySocketConnect() {
        print("Socket reconnected from background!")
        surfaceView.interactiveCanvas.registerForSocketEvents(socket: InteractiveCanvasSocket.instance.socket!)
        
        URLSessionHandler.instance.getRecentPixels(server: SessionSettings.instance.lastVisitedServer!, since: SessionSettings.instance.canvasPauseTime) { jsonArray in
            if jsonArray != nil {
                for pixelInfo in jsonArray! {
                    self.surfaceView.interactiveCanvas.receivePixel(pixelInfo: pixelInfo)
                }
            }
            else {
                self.performSegue(withIdentifier: self.unwindToLoading, sender: nil)
            }
        }
        
        URLSessionHandler.instance.getPaintQty(server: SessionSettings.instance.lastVisitedServer!, uuid: SessionSettings.instance.uniqueId) { jsonObj in
            if jsonObj != nil {
                let paintQty = jsonObj!["paint_qty"] as! Int
                SessionSettings.instance.dropsAmt = paintQty
            }
            else {
                self.performSegue(withIdentifier: self.unwindToLoading, sender: nil)
            }
        }
    }
    
    func notifySocketConnectionError() {
        self.performSegue(withIdentifier: unwindToLoading, sender: nil)
    }
    
    // scene delegate delegate
    func sceneWillEnterForeground() {
        let timeSincePause = NSDate().timeIntervalSince1970 - SessionSettings.instance.canvasPauseTime
        if SessionSettings.instance.canvasPaused {
            if timeSincePause > 60 * 60 {
                self.performSegue(withIdentifier: self.unwindToLoading, sender: nil)
            }
            else {
                InteractiveCanvasSocket.instance.socketConnectionDelegate = self
                InteractiveCanvasSocket.instance.startSocket(server: SessionSettings.instance.lastVisitedServer!)
                
                SessionSettings.instance.canvasPaused = false
            }
        }
    }
    
    // erase delegate
    func notifyErase(left: Int, top: Int, right: Int, bottom: Int) {
        let alertController = UIAlertController(title: nil, message: "Erase selected pixels?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            let message = "\(self.server.adminKey)&\(left)&\(top)&\(right)&\(bottom)"
            InteractiveCanvasSocket.instance.socket?.emit("5ypq8062qs", message, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupBanner() {
        if !server.showBanner {
            return
        }
        
        bannerView.isHidden = false
        
        bannerView.alpha = 0
        
        bannerView.layer.cornerRadius = 15
        bannerView.layer.borderColor = UIColor(argb: ActionButtonView.lightGreenColor).cgColor
        bannerView.layer.borderWidth = 1
        bannerView.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xff1b1b1b"))
        
        bannerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickedBannerView)))
        
        bannerIcon.kf.setImage(
            with: URL(string: server!.iconUrl)) { result in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
                    self.bannerView.alpha = 1
                }
            }
        
        bannerText.textColor = UIColor.white
        bannerText.text = server.bannerText
        bannerWidth.constant = bannerText.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)).width + 10 + 16 + 16 + 20
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
                self.bannerView.alpha = 0
            } completion: { success in
                self.bannerView.isHidden = true
            }

        }
    }
    
    @objc func clickedBannerView() {
        UIApplication.shared.openURL(URL(string: server.iconLink)!)
    }
}


