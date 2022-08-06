//
//  ViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import FlexColorPicker

class InteractiveCanvasViewController: UIViewController, InteractiveCanvasPaintDelegate, ColorPickerDelegate, InteractiveCanvasPixelHistoryDelegate, InteractiveCanvasRecentColorsDelegate, RecentColorsDelegate, ExportViewControllerDelegate, InteractiveCanvasArtExportDelegate, AchievementListener, InteractiveCanvasSocketStatusDelegate, PaintActionDelegate, PaintQtyDelegate, ObjectSelectionDelegate, UITextFieldDelegate, ColorPickerLayoutDelegate, InteractiveCanvasPalettesDelegate, PalettesViewControllerDelegate, InteractiveCanvasGestureDelegate, CanvasFrameViewControllerDelegate, CanvasFrameDelegate, CanvasEdgeTouchDelegate, InteractiveCanvasSelectedObjectViewDelegate, InteractiveCanvasSelectedObjectMoveViewDelegate, MenuButtonDelegate {
    
    @IBOutlet var surfaceView: InteractiveCanvasView!
    
    @IBOutlet var paintPanel: UIView!
    
    @IBOutlet weak var paintPanelButton: ActionButtonFrame!
    @IBOutlet weak var paintPanelAction: ActionButtonView!
    
    @IBOutlet weak var closePaintPanelButton: ActionButtonFrame!
    @IBOutlet weak var closePaintPanelButtonAction: ActionButtonView!
    
    @IBOutlet weak var colorPickerFrame: UIView!
    
    @IBOutlet weak var paintColorIndicator: PaintColorIndicator!
    
    @IBOutlet var paintPanelLeading: NSLayoutConstraint!
    @IBOutlet var paintPanelTrailing: NSLayoutConstraint!
    
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
    
    @IBOutlet weak var paletteAddColor: ActionButtonFrame!
    @IBOutlet weak var paletteAddColorAction: ActionButtonView!
    
    @IBOutlet weak var paletteRemoveColor: ActionButtonFrame!
    @IBOutlet weak var paletteRemoveColorAction: ActionButtonView!
    
    @IBOutlet weak var lockPaintPanel: ActionButtonFrame!
    @IBOutlet weak var lockPaintPanelAction: ActionButtonView!
    @IBOutlet weak var lockPaintPanelCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var menuButton: ActionButtonFrame!
    @IBOutlet weak var menuAction: ActionButtonView!
    
    @IBOutlet weak var exportButton: ActionButtonFrame!
    @IBOutlet weak var exportAction: ActionButtonView!
    
    @IBOutlet weak var changeBackgroundButton: ActionButtonFrame!
    @IBOutlet weak var changeBackgroundAction: ActionButtonView!
    
    @IBOutlet weak var gridLinesButton: ActionButtonFrame!
    @IBOutlet weak var gridLinesAction: ActionButtonView!
    
    @IBOutlet weak var toolboxButton: ActionButtonFrame!
    @IBOutlet weak var toolboxActionView: ActionButtonView!
    
    @IBOutlet var toolboxActionLeading: NSLayoutConstraint!
    @IBOutlet var toolboxActionTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var recentColorsButton: ActionButtonFrame!
    @IBOutlet weak var recentColorsActionView: ActionButtonView!
    
    @IBOutlet var recentColorsActionLeading: NSLayoutConstraint!
    @IBOutlet var recentColorsActionTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var recentColorsContainer: UIView!
    
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
    
    @IBOutlet var changeBackgroundButtonLeading: NSLayoutConstraint!
    @IBOutlet var changeBackgroundButtonTrailing: NSLayoutConstraint!
    
    @IBOutlet var gridLinesButtonLeading: NSLayoutConstraint!
    @IBOutlet var gridLinesButtonTrailing: NSLayoutConstraint!
    
    @IBOutlet var summaryButtonLeading: NSLayoutConstraint!
    @IBOutlet var summaryButtonTrailing: NSLayoutConstraint!
    
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
    
    @IBOutlet weak var summaryView: InteractiveCanvasSummaryView!
    @IBOutlet weak var deviceViewportSummaryView: DeviceViewportSummaryView!
    
    @IBOutlet weak var canvasFrameView: UIView!
    
    @IBOutlet weak var summaryButton: ActionButtonFrame!
    @IBOutlet weak var summaryAction: ActionButtonView!
    
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
    
    let showOptions = "ShowOptions"
    let showHowto = "ShowHowto"
    
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
    
    var pixelHistoryViewController: PixelHistoryViewController!
    weak var recentColorsViewController: RecentColorsViewController!
    weak var exportViewController: ExportViewController!
    weak var colorPickerViewController: ColorPickerOutletsViewController!
    weak var palettesViewController: PalettesViewController!
    weak var canvasFrameViewController: CanvasFrameViewController!
    weak var menuViewController: MenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SessionSettings.instance.canvasOpen = true
        
        realmId = 1
        
        surfaceView.interactiveCanvas.realmId = realmId
        surfaceView.interactiveCanvas.world = world
        
        // paintQuantityMeter.world = world
        
        SessionSettings.instance.interactiveCanvas = self.surfaceView.interactiveCanvas
        
        surfaceView.paintActionDelegate = self
        surfaceView.objectSelectionDelegate = self
        
        self.surfaceView.interactiveCanvas.pixelHistoryDelegate = self
        self.surfaceView.interactiveCanvas.recentColorsDelegate = self
        self.surfaceView.interactiveCanvas.artExportDelegate = self
        self.surfaceView.paintDelegate = self
        self.surfaceView.palettesDelegate = self
        self.surfaceView.gestureDelegate = self
        self.surfaceView.canvasFrameDelegate = self
        self.surfaceView.canvasEdgeTouchDelegate = self
        self.surfaceView.selectedObjectView = self
        self.surfaceView.selectedObjectMoveView = self
        
        // surfaceView.setInitalScale()
        
        // back button
        menuButton.actionButtonView = menuAction
        self.menuAction.type = .menu
        self.menuButton.setOnClickListener {
            
            if self.surfaceView.isExporting() {
                self.exportAction.toggleState = .none
                self.surfaceView.endExporting()
                
                self.exportAction.layer.borderWidth = 0
            }
            else if self.surfaceView.isObjectMoveSelection() || self.surfaceView.isObjectMoving() {
                if self.surfaceView.isObjectMoving() {
                    self.surfaceView.interactiveCanvas.cancelMoveSelectedObject()
                }
                else {
                    self.surfaceView.startExporting()
                    
                    self.exportAction.toggleState = .single
                    self.exportAction.layer.borderWidth = 1
                    self.exportAction.layer.borderColor = UIColor(argb: ActionButtonView.lightYellowColor).cgColor
                }
            }
            else {
                /*if SessionSettings.instance.promptBack {
                    self.promptBack()
                }
                else {
                    self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
                }*/
                self.toggleMenu(show: self.menuContainer.isHidden)
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
        paintPanelAction.type = .paint
        paintPanelButton.actionButtonView = paintPanelAction
        
        closePaintPanelButtonAction.type = .closePaint
        closePaintPanelButton.actionButtonView = closePaintPanelButtonAction
        
        exportButton.actionButtonView = exportAction
        exportAction.type = .export
        
        changeBackgroundButton.actionButtonView = changeBackgroundAction
        changeBackgroundAction.type = .changeBackground
        
        gridLinesButton.actionButtonView = gridLinesAction
        gridLinesAction.type = .gridLines
        
        summaryButton.actionButtonView = summaryAction
        summaryAction.type = .summary
        
        // toolbox
        self.toolboxActionView.type = .dot
        self.toolboxButton.actionButtonView = self.toolboxActionView
        
        self.toolboxButton.setOnClickListener {
            self.toggleToolbox(open: self.exportButton.isHidden)
        }
        
        exportButton.isHidden = true
        changeBackgroundButton.isHidden = true
        gridLinesButton.isHidden = true
        summaryButton.isHidden = true
        
        // recent colors
        self.recentColorsActionView.type = .dot
        self.recentColorsButton.actionButtonView = self.recentColorsActionView
        
        self.recentColorsButton.setOnClickListener {
            self.toggleRecentColors(open: self.recentColorsContainer.isHidden)
        }
        
        // export
        self.exportButton.setOnClickListener {
            if (self.exportAction.toggleState == .none) {
                self.surfaceView.startExporting()
                self.exportAction.toggleState = .single
                self.exportAction.layer.borderColor = UIColor(argb: ActionButtonView.lightYellowColor).cgColor
                self.exportAction.layer.borderWidth = 1
            }
            else if (self.exportAction.toggleState == .single) {
                self.surfaceView.endExporting()
                self.surfaceView.startObjectMoveSelection()
                self.exportAction.toggleState = .double
                self.exportAction.layer.borderColor = UIColor(argb: ActionButtonView.lightGreenColor).cgColor
            }
            else if (self.exportAction.toggleState == .double) {
                self.surfaceView.endObjectMove()
                self.surfaceView.interactiveCanvas.cancelMoveSelectedObject()
                self.exportAction.toggleState = .none
                self.exportAction.layer.borderWidth = 0
            }
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
            
            self.exportAction.setNeedsDisplay()
            self.changeBackgroundAction.setNeedsDisplay()
            self.gridLinesAction.setNeedsDisplay()
            self.summaryAction.setNeedsDisplay()
            self.paintPanelAction.setNeedsDisplay()
            self.menuAction.setNeedsDisplay()
            self.paletteAddColorAction.setNeedsDisplay()
            self.paletteRemoveColorAction.setNeedsDisplay()
            
            self.toolboxActionView.setNeedsDisplay()
            self.recentColorsActionView.setNeedsDisplay()
            
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
        
        paintColorAcceptAction.type = .paintSelectYes
        paintColorAccept.actionButtonView = paintColorAcceptAction
        
        paintColorCancelAction.type = .paintSelectCancel
        paintColorCancel.actionButtonView = paintColorCancelAction
        
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
        summaryView.interactiveCanvas = surfaceView.interactiveCanvas
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
        
        self.paintColorAcceptAction.touchDelegate = self.paintColorIndicator
        
        var tgr = UITapGestureRecognizer(target: self, action: #selector(didTapColorPaletteTitle))
        colorPaletteTitleLabel.addGestureRecognizer(tgr)
        
        colorPaletteTitleLabel.text = SessionSettings.instance.palette.displayName
        self.syncPaletteAndColor()
        
        // paint event time toggle
        tgr = UITapGestureRecognizer(target: self, action: #selector(didTapPaintQuantityBar))
        
        if SessionSettings.instance.showPaintCircle {
            self.paintQuantityCircle.addGestureRecognizer(tgr)
        }
        else if SessionSettings.instance.showPaintBar {
            self.paintQuantityBar.addGestureRecognizer(tgr)
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
                self.paintQuantityCircle.removeGestureRecognizer(tgr)
            }
            else if SessionSettings.instance.showPaintBar {
                self.paintQuantityBar.removeGestureRecognizer(tgr)
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
            let leadingConstraints = [exportButtonLeading, changeBackgroundButtonLeading, gridLinesButtonLeading, summaryButtonLeading]
            let trailingConstraints = [exportButtonTrailing, changeBackgroundButtonTrailing, gridLinesButtonTrailing, summaryButtonTrailing]
            
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
        
        setPaintPanelBackground(adjust: false)
        surfaceView.setInitalPositionAndScale()
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
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
        
        panelThemeConfig = themeConfigFromBackground()
        
        // bold action buttons
        let boldActionButtons = SessionSettings.instance.boldActionButtons
        
        menuAction.bold = boldActionButtons
        paintPanelAction.bold = boldActionButtons
        exportAction.bold = boldActionButtons
        changeBackgroundAction.bold = boldActionButtons
        gridLinesAction.bold = boldActionButtons
        summaryAction.bold = boldActionButtons
        toolboxActionView.bold = boldActionButtons
        recentColorsActionView.bold = boldActionButtons
        
        // panel theme config
        if panelThemeConfig.actionButtonColor == ActionButtonView.blackColor {
            paintColorAcceptAction.colorMode = .black
            paintColorCancelAction.colorMode = .black
            
            paletteAddColorAction.colorMode = .black
            paletteRemoveColorAction.colorMode = .black
            lockPaintPanelAction.colorMode = .black
            
            closePaintPanelButtonAction.colorMode = .black
            
            colorPaletteTitleLabel.textColor = UIColor.black
        }
        else {
            paintColorAcceptAction.colorMode = .white
            paintColorCancelAction.colorMode = .white
            
            paletteAddColorAction.colorMode = .white
            paletteRemoveColorAction.colorMode = .white
            lockPaintPanelAction.colorMode = .white
            
            closePaintPanelButtonAction.colorMode = .white
            
            colorPaletteTitleLabel.textColor = UIColor.white
        }
        
        self.updatePaintColorAcceptColorMode(color: SessionSettings.instance.paintColor)
        
        self.paintQuantityCircle.panelThemeConfig = panelThemeConfig
        self.paintQuantityBar.panelThemeConfig = panelThemeConfig
        
        self.paintColorIndicator.panelThemeConfig = panelThemeConfig
        
        self.colorPicker(self.colorPickerViewController.colorPicker, selectedColor: self.colorPickerViewController.selectedColor, usingControl: self.colorPickerViewController.colorPicker.radialHsbPalette!)
        
        // bocker lock
        if SessionSettings.instance.canvasLockBorder {
            canvasLockView.layer.borderWidth = 4
            canvasLockView.layer.borderColor = UIColor(argb: SessionSettings.instance.canvasLockColor).cgColor
            canvasLockView.layer.cornerRadius = 40
        }
        
        // close button color
        if SessionSettings.instance.paintPanelCloseButtonColor != 0 {
            closePaintPanelButtonAction.representingColor = SessionSettings.instance.paintPanelCloseButtonColor
            closePaintPanelButtonAction.colorMode = .color
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
            colorPickerViewController.view.backgroundColor = UIColor.clear
            
            setDefaultColorsClickListeners()
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
                InteractiveCanvasSocket.instance.socket.disconnect()
                
                statusCheckTimer?.invalidate()
            }
            
            else {
                surfaceView.interactiveCanvas.save()
                
                singlePlaySaveTimer.invalidate()
            }
            
            SessionSettings.instance.interactiveCanvas = nil
            
            SessionSettings.instance.canvasOpen = false
        }
        else if segue.identifier == "ShowOptions" || segue.identifier == "ShowHowto" {
            segue.destination.isModalInPresentation = true
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
            
            toggleMenu(show: false)
            
            self.surfaceView.startPainting()
            
            SessionSettings.instance.paintPanelOpen = true
        }
        else if softHide {
            self.paintPanel.isHidden = true
            
            self.paintPanelWidth.constant = 0
            
            self.toolboxButton.isHidden = true
            
            toggleToolbox(open: false)
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
            self.recentColorsActionView.isHidden = true
            self.recentColorsContainer.isHidden = false
            
            if (paintPanel.isHidden) {
                self.togglePaintPanel(open: true)
            }
        }
        else {
            self.recentColorsActionView.isHidden = false
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
            paintColorAcceptAction.colorMode = .black
        }
        else if panelThemeConfig.actionButtonColor == ActionButtonView.whiteColor {
            paintColorAcceptAction.colorMode = .white
        }
        else if PaintColorIndicator.isColorDark(color: color) && panelThemeConfig.actionButtonColor == ActionButtonView.blackColor {
            paintColorAcceptAction.colorMode = .white
        }
        else if panelThemeConfig.actionButtonColor == ActionButtonView.blackColor {
            paintColorAcceptAction.colorMode = .black
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
        
        self.exportAction.toggleState = .none
        self.exportAction.layer.borderWidth = 0
        
        surfaceView.endExporting()
    }
    
    // art export delegate
    func notifyArtExported(art: [InteractiveCanvas.RestorePoint]) {
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
        self.exportAction.toggleState = .none
        self.exportAction.layer.borderWidth = 0
    }
}


