//
//  ActionButtonView.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/11/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class ActionButtonView: UIView {

    static var altGreenColor: Int32!
    static var whiteColor: Int32!
    static var blackColor: Int32!
    static var lightAltGreenColor: Int32!
    static var semiLightColor: Int32!
    static var lightYellowColor: Int32!
    static var yellowColor: Int32!
    static var greenColor: Int32!
    static var lightGreenColor: Int32!
    static var redColor: Int32!
    static var lightRedColor: Int32!
    static var semiDarkLightColor: Int32!
    static var semiColor: Int32!
    static var semiDarkColor: Int32!
    static var lightYellowSemiColor: Int32!
    static var photoshopGrayColor: Int32!
    static var lightGrayColor: Int32!
    static var twoThirdGrayColor: Int32!
    
    enum ActionType {
        case none
        case clickable
        case paint
        case yes
        case no
        case closePaint
        case paintSelectYes
        case paintSelectCancel
        case play
        case options
        case stats
        case exit
        case back
        case backSolid
        case export
        case exportSolid
        case changeBackground
        case save
        case dot
        case recentColor
        case share
        case single
        case world
    }
    
    let menuButtonRows = 4
    let menuButtonCols = 26
    
    private var _selected = false
    var selected: Bool {
        set {
            _selected = newValue
            setNeedsDisplay()
        }
        get {
            return _selected
        }
    }
    
    private var _representingColor: Int32 = 0
    var representingColor: Int32 {
        set {
            _representingColor = newValue
            setNeedsDisplay()
        }
        get {
            return _representingColor
        }
    }
    
    var rows: Int!
    var cols: Int!
    
    var type = ActionType.none
    
    var clickHandler: (() -> Void)?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.clear
        
        // colors
        
        ActionButtonView.altGreenColor = Utils.int32FromColorHex(hex: "0xFF42FF7B")
        ActionButtonView.whiteColor = Utils.int32FromColorHex(hex: "0xFFFFFFFF")
        ActionButtonView.blackColor = Utils.int32FromColorHex(hex: "0xFF000000")
        ActionButtonView.lightAltGreenColor = Utils.int32FromColorHex(hex: "0xFFB0FFC5")
        ActionButtonView.semiLightColor = Utils.int32FromColorHex(hex: "0x33FFFFFF")
        ActionButtonView.lightYellowColor = Utils.int32FromColorHex(hex: "0xFFFAE38D")
        ActionButtonView.yellowColor = Utils.int32FromColorHex(hex: "0xFFFAD452")
        ActionButtonView.greenColor = Utils.int32FromColorHex(hex: "0xFF05AD2E")
        ActionButtonView.lightGreenColor = Utils.int32FromColorHex(hex: "0xFF62AD6C")
        ActionButtonView.redColor = Utils.int32FromColorHex(hex: "0xFFFA3A47")
        ActionButtonView.lightRedColor = Utils.int32FromColorHex(hex: "0xFFFB7E87")
        ActionButtonView.semiDarkLightColor = Utils.int32FromColorHex(hex: "0x11000000")
        ActionButtonView.semiColor = Utils.int32FromColorHex(hex: "0x99FFFFFF")
        ActionButtonView.semiDarkColor = Utils.int32FromColorHex(hex: "0x33000000")
        ActionButtonView.lightYellowSemiColor = Utils.int32FromColorHex(hex: "0x99FAE38D")
        ActionButtonView.photoshopGrayColor = Utils.int32FromColorHex(hex: "0xFFCCCCCC")
        ActionButtonView.lightGrayColor = Utils.int32FromColorHex(hex: "0xFFDDDDDD")
        ActionButtonView.twoThirdGrayColor = Utils.int32FromColorHex(hex: "0xFF555555")
    }
    
    override func draw(_ rect: CGRect) {
        if type == .clickable {
            drawClickableAction()
        }
        else if type == .paint {
            drawPaintAction()
        }
        else if type == .closePaint {
            drawClosePaintAction()
        }
        else if type == .paintSelectYes {
            drawYesAction(color: false)
        }
        else if type == .paintSelectCancel {
            drawNoAction(color: false)
        }
        else if type == .yes {
            drawYesAction(color: true)
        }
        else if type == .no {
            drawNoAction(color: true)
        }
        else if type == .play {
            drawPlayAction()
        }
        else if type == .options {
            drawOptionsAction()
        }
        else if type == .stats {
            drawStatsAction()
        }
        else if type == .exit {
            drawExitAction()
        }
        else if type == .back {
            drawBackAction()
        }
        else if type == .backSolid {
            drawBackSolidAction()
        }
        else if type == .export {
            drawExportAction()
        }
        else if type == .exportSolid {
            drawExportSolidAction()
        }
        else if type == .save {
            drawSaveAction()
        }
        else if type == .changeBackground {
            drawChangeBackgroundAction()
        }
        else if type == .dot {
            drawDotAction()
        }
        else if type == .recentColor {
            drawRecentColorAction()
        }
        else if type == .share {
            drawShareAction()
        }
        else if type == .single {
            drawSingleAction()
        }
        else if type == .world {
            drawWorldAction()
        }
    }
    
    @objc func onTouchAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.selected = true
            setNeedsDisplay()
        }
        else if sender.state == .changed  {
            self.selected = false
            setNeedsDisplay()
        }
        
        if sender.state == .ended {
            self.selected = false
            setNeedsDisplay()
            self.clickHandler?()
        }
    }
    
    func setOnClickListener(handler: @escaping () -> Void) {
        let dgr = UIDrawGestureRecognizer(target: self, action: #selector(onTouchAction(sender:)))
        addGestureRecognizer(dgr)
        
        self.clickHandler = handler
    }
    
    func drawClickableAction() {
        rows = 1
        cols = 1
        
        let context = UIGraphicsGetCurrentContext()!
        
        drawPixel(ctx: context, x: 0, y: 0, color: Utils.int32FromColorHex(hex: "0x00000000"))
    }
    
    func drawClosePaintAction() {
        rows = 5
        cols = 7
        
        var paint = ActionButtonView.yellowColor!
        
        if selected {
            paint = ActionButtonView.lightYellowColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 5, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 1, y: 2, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 3, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 6, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 5, y: 3, color: paint)
        
        // row 5
        drawPixel(ctx: context, x: 4, y: 4, color: paint)
    }
    
    func drawPaintAction() {
        self.rows = 4
        self.cols = 4
        
        var primaryColor = ActionButtonView.whiteColor!
        var accentColor = ActionButtonView.altGreenColor!
        
        if SessionSettings.instance.darkIcons {
            primaryColor = ActionButtonView.blackColor!
        }
        
        if selected {
            accentColor = ActionButtonView.lightAltGreenColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        drawPixel(ctx: context, x: 3, y: 0, color: accentColor)
        drawPixel(ctx: context, x: 2, y: 1, color: primaryColor)
        drawPixel(ctx: context, x: 1, y: 2, color: primaryColor)
        drawPixel(ctx: context, x: 0, y: 3, color: primaryColor)
    }
    
    func drawYesAction(color: Bool) {
        self.rows = 5
        self.cols = 7
        
        var paint = ActionButtonView.greenColor!
        if self.selected {
            paint = ActionButtonView.lightGreenColor!
        }
        
        if !color {
            paint = ActionButtonView.whiteColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 6, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 5, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 3, y: 3, color: paint)
        
        // row 5
        drawPixel(ctx: context, x: 2, y: 4, color: paint)
    }
    
    func drawNoAction(color: Bool) {
        self.rows = 5
        self.cols = 5
        
        var paint = ActionButtonView.redColor!
        if self.selected {
            paint = ActionButtonView.lightRedColor!
        }
        
        if !color {
            paint = ActionButtonView.whiteColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
        drawPixel(ctx: context, x: 3, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 3, y: 3, color: paint)
        
        // row 5
        drawPixel(ctx: context, x: 0, y: 4, color: paint)
        drawPixel(ctx: context, x: 4, y: 4, color: paint)
    }
    
    func drawBackAction() {
        self.rows = 5
        self.cols = 7
       
        var paint = ActionButtonView.semiLightColor!
        if SessionSettings.instance.darkIcons {
            paint = ActionButtonView.semiDarkLightColor!
        }
        
        if self.selected {
            paint = ActionButtonView.lightYellowColor!
        }
       
        let context = UIGraphicsGetCurrentContext()!
       
        // row 1
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
       
        // row 2
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
       
        // row 3
        drawPixel(ctx: context, x: 6, y: 2, color: paint)
        drawPixel(ctx: context, x: 5, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 3, y: 2, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
       
        // row 4
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
       
        // row 5
        drawPixel(ctx: context, x: 2, y: 4, color: paint)
    }
    
    func drawBackSolidAction() {
        self.rows = 5
        self.cols = 7
       
        var paint = ActionButtonView.semiColor!
        if SessionSettings.instance.darkIcons {
            paint = ActionButtonView.semiDarkColor!
        }
        
        if self.selected {
            paint = ActionButtonView.lightYellowColor!
        }
       
        let context = UIGraphicsGetCurrentContext()!
       
        // row 1
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
       
        // row 2
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
       
        // row 3
        drawPixel(ctx: context, x: 6, y: 2, color: paint)
        drawPixel(ctx: context, x: 5, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 3, y: 2, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
       
        // row 4
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
       
        // row 5
        drawPixel(ctx: context, x: 2, y: 4, color: paint)
    }
    
    func drawRecentColorAction() {
        self.rows = 4
        self.cols = 4
        
        var paint = ActionButtonView.whiteColor!
        if SessionSettings.instance.darkIcons {
            paint = ActionButtonView.blackColor
        }
        
        if selected {
            paint = ActionButtonView.lightAltGreenColor!
        }
        
        let colorPaint = representingColor
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 3, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 1, y: 1, color: colorPaint)
        drawPixel(ctx: context, x: 2, y: 1, color: colorPaint)
        drawPixel(ctx: context, x: 3, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 1, y: 2, color: colorPaint)
        drawPixel(ctx: context, x: 2, y: 2, color: colorPaint)
        drawPixel(ctx: context, x: 3, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
        drawPixel(ctx: context, x: 3, y: 3, color: paint)
    }
    
    func drawExportAction() {
        rows = 3
        cols = 3
        
        var paint = ActionButtonView.semiColor!
        if SessionSettings.instance.darkIcons {
            paint = ActionButtonView.semiDarkColor!
        }
        
        if selected {
            paint = ActionButtonView.lightYellowColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
    }
    
    func drawShareAction() {
        rows = 3
        cols = 3
        
        var paint = ActionButtonView.semiColor!
        
        if selected {
            paint = ActionButtonView.lightYellowColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
    }
    
    func drawExportSolidAction() {
        rows = 3
        cols = 3
        
        var paint = ActionButtonView.semiColor!
        
        if selected {
            paint = ActionButtonView.lightYellowColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
    }
    
    func drawSaveAction() {
        rows = 5
        cols = 4
        
        var paint = ActionButtonView.semiColor!
        
        if selected {
            paint = ActionButtonView.lightYellowColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 3, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 3, y: 1, color: paint)

        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 3, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
        drawPixel(ctx: context, x: 3, y: 3, color: paint)
        
        // row 5
        drawPixel(ctx: context, x: 0, y: 4, color: paint)
        drawPixel(ctx: context, x: 1, y: 4, color: paint)
        drawPixel(ctx: context, x: 2, y: 4, color: paint)
        drawPixel(ctx: context, x: 3, y: 4, color: paint)
    }
    
    func drawChangeBackgroundAction() {
        rows = 4
        cols = 3
        
        var paint = ActionButtonView.semiColor!
        if SessionSettings.instance.darkIcons {
            paint = ActionButtonView.semiDarkColor!
        }
        
        if selected {
            paint = ActionButtonView.lightYellowColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 1, color: paint)

        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 1, y: 2, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
    }
    
    func drawDotAction() {
        rows = 1
        cols = 1
        
        var paint = ActionButtonView.semiLightColor!
        if SessionSettings.instance.darkIcons {
            paint = ActionButtonView.semiDarkLightColor!
        }
        
        if selected {
            paint = ActionButtonView.lightYellowColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
    }
    
    // menu buttons
    func drawPlayAction() {
        rows = 4
        cols = 16
        
        var paint = ActionButtonView.lightGrayColor!
        
        if selected {
            paint = ActionButtonView.altGreenColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        drawPixel(ctx: context, x: 10, y: 0, color: paint)
        drawPixel(ctx: context, x: 13, y: 0, color: paint)
        drawPixel(ctx: context, x: 15, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 1, color: paint)
        drawPixel(ctx: context, x: 4, y: 1, color: paint)
        drawPixel(ctx: context, x: 9, y: 1, color: paint)
        drawPixel(ctx: context, x: 11, y: 1, color: paint)
        drawPixel(ctx: context, x: 13, y: 1, color: paint)
        drawPixel(ctx: context, x: 15, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 1, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 8, y: 2, color: paint)
        drawPixel(ctx: context, x: 10, y: 2, color: paint)
        drawPixel(ctx: context, x: 11, y: 2, color: paint)
        drawPixel(ctx: context, x: 14, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 4, y: 3, color: paint)
        drawPixel(ctx: context, x: 5, y: 3, color: paint)
        drawPixel(ctx: context, x: 6, y: 3, color: paint)
        drawPixel(ctx: context, x: 8, y: 3, color: paint)
        drawPixel(ctx: context, x: 11, y: 3, color: paint)
        drawPixel(ctx: context, x: 14, y: 3, color: paint)
    }
    
    func drawOptionsAction() {
        rows = 4
        cols = 26
        
        var paint = ActionButtonView.lightGrayColor!
        
        if selected {
            paint = ActionButtonView.altGreenColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        drawPixel(ctx: context, x: 5, y: 0, color: paint)
        drawPixel(ctx: context, x: 8, y: 0, color: paint)
        drawPixel(ctx: context, x: 9, y: 0, color: paint)
        drawPixel(ctx: context, x: 10, y: 0, color: paint)
        drawPixel(ctx: context, x: 12, y: 0, color: paint)
        drawPixel(ctx: context, x: 14, y: 0, color: paint)
        drawPixel(ctx: context, x: 15, y: 0, color: paint)
        drawPixel(ctx: context, x: 16, y: 0, color: paint)
        drawPixel(ctx: context, x: 18, y: 0, color: paint)
        drawPixel(ctx: context, x: 21, y: 0, color: paint)
        drawPixel(ctx: context, x: 23, y: 0, color: paint)
        drawPixel(ctx: context, x: 24, y: 0, color: paint)
        drawPixel(ctx: context, x: 25, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 1, color: paint)
        drawPixel(ctx: context, x: 4, y: 1, color: paint)
        drawPixel(ctx: context, x: 6, y: 1, color: paint)
        drawPixel(ctx: context, x: 9, y: 1, color: paint)
        drawPixel(ctx: context, x: 12, y: 1, color: paint)
        drawPixel(ctx: context, x: 14, y: 1, color: paint)
        drawPixel(ctx: context, x: 16, y: 1, color: paint)
        drawPixel(ctx: context, x: 18, y: 1, color: paint)
        drawPixel(ctx: context, x: 19, y: 1, color: paint)
        drawPixel(ctx: context, x: 21, y: 1, color: paint)
        drawPixel(ctx: context, x: 24, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 5, y: 2, color: paint)
        drawPixel(ctx: context, x: 9, y: 2, color: paint)
        drawPixel(ctx: context, x: 12, y: 2, color: paint)
        drawPixel(ctx: context, x: 14, y: 2, color: paint)
        drawPixel(ctx: context, x: 16, y: 2, color: paint)
        drawPixel(ctx: context, x: 18, y: 2, color: paint)
        drawPixel(ctx: context, x: 20, y: 2, color: paint)
        drawPixel(ctx: context, x: 21, y: 2, color: paint)
        drawPixel(ctx: context, x: 25, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
        drawPixel(ctx: context, x: 4, y: 3, color: paint)
        drawPixel(ctx: context, x: 9, y: 3, color: paint)
        drawPixel(ctx: context, x: 12, y: 3, color: paint)
        drawPixel(ctx: context, x: 14, y: 3, color: paint)
        drawPixel(ctx: context, x: 15, y: 3, color: paint)
        drawPixel(ctx: context, x: 16, y: 3, color: paint)
        drawPixel(ctx: context, x: 18, y: 3, color: paint)
        drawPixel(ctx: context, x: 21, y: 3, color: paint)
        drawPixel(ctx: context, x: 23, y: 3, color: paint)
        drawPixel(ctx: context, x: 24, y: 3, color: paint)
        drawPixel(ctx: context, x: 25, y: 3, color: paint)
    }
    
    func drawStatsAction() {
        rows = 4
        cols = 20
        
        var paint = ActionButtonView.lightGrayColor!
        
        if selected {
            paint = ActionButtonView.altGreenColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        drawPixel(ctx: context, x: 5, y: 0, color: paint)
        drawPixel(ctx: context, x: 6, y: 0, color: paint)
        drawPixel(ctx: context, x: 10, y: 0, color: paint)
        drawPixel(ctx: context, x: 13, y: 0, color: paint)
        drawPixel(ctx: context, x: 14, y: 0, color: paint)
        drawPixel(ctx: context, x: 15, y: 0, color: paint)
        drawPixel(ctx: context, x: 17, y: 0, color: paint)
        drawPixel(ctx: context, x: 18, y: 0, color: paint)
        drawPixel(ctx: context, x: 19, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
        drawPixel(ctx: context, x: 5, y: 1, color: paint)
        drawPixel(ctx: context, x: 9, y: 1, color: paint)
        drawPixel(ctx: context, x: 11, y: 1, color: paint)
        drawPixel(ctx: context, x: 14, y: 1, color: paint)
        drawPixel(ctx: context, x: 18, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 5, y: 2, color: paint)
        drawPixel(ctx: context, x: 8, y: 2, color: paint)
        drawPixel(ctx: context, x: 10, y: 2, color: paint)
        drawPixel(ctx: context, x: 11, y: 2, color: paint)
        drawPixel(ctx: context, x: 14, y: 2, color: paint)
        drawPixel(ctx: context, x: 19, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
        drawPixel(ctx: context, x: 5, y: 3, color: paint)
        drawPixel(ctx: context, x: 8, y: 3, color: paint)
        drawPixel(ctx: context, x: 11, y: 3, color: paint)
        drawPixel(ctx: context, x: 14, y: 3, color: paint)
        drawPixel(ctx: context, x: 17, y: 3, color: paint)
        drawPixel(ctx: context, x: 18, y: 3, color: paint)
        drawPixel(ctx: context, x: 19, y: 3, color: paint)
    }
    
    func drawExitAction() {
        rows = 4
        cols = 15
        
        var paint = ActionButtonView.lightGrayColor!
        
        if selected {
            paint = ActionButtonView.altGreenColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        drawPixel(ctx: context, x: 6, y: 0, color: paint)
        drawPixel(ctx: context, x: 8, y: 0, color: paint)
        drawPixel(ctx: context, x: 9, y: 0, color: paint)
        drawPixel(ctx: context, x: 10, y: 0, color: paint)
        drawPixel(ctx: context, x: 12, y: 0, color: paint)
        drawPixel(ctx: context, x: 13, y: 0, color: paint)
        drawPixel(ctx: context, x: 14, y: 0, color: paint)
        
        // row 2
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
        drawPixel(ctx: context, x: 5, y: 1, color: paint)
        drawPixel(ctx: context, x: 9, y: 1, color: paint)
        drawPixel(ctx: context, x: 13, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 5, y: 2, color: paint)
        drawPixel(ctx: context, x: 9, y: 2, color: paint)
        drawPixel(ctx: context, x: 13, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
        drawPixel(ctx: context, x: 4, y: 3, color: paint)
        drawPixel(ctx: context, x: 6, y: 3, color: paint)
        drawPixel(ctx: context, x: 8, y: 3, color: paint)
        drawPixel(ctx: context, x: 9, y: 3, color: paint)
        drawPixel(ctx: context, x: 10, y: 3, color: paint)
        drawPixel(ctx: context, x: 13, y: 3, color: paint)
    }
    
    func drawSingleAction() {
        rows = 4
        cols = 22
       
        var paint = ActionButtonView.lightGrayColor!
       
        if selected {
            paint = ActionButtonView.altGreenColor!
        }
       
        let context = UIGraphicsGetCurrentContext()!
       
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        drawPixel(ctx: context, x: 6, y: 0, color: paint)
        drawPixel(ctx: context, x: 9, y: 0, color: paint)
        drawPixel(ctx: context, x: 11, y: 0, color: paint)
        drawPixel(ctx: context, x: 12, y: 0, color: paint)
        drawPixel(ctx: context, x: 13, y: 0, color: paint)
        drawPixel(ctx: context, x: 15, y: 0, color: paint)
        drawPixel(ctx: context, x: 19, y: 0, color: paint)
        drawPixel(ctx: context, x: 20, y: 0, color: paint)
        drawPixel(ctx: context, x: 21, y: 0, color: paint)
       
        // row 2
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
        drawPixel(ctx: context, x: 4, y: 1, color: paint)
        drawPixel(ctx: context, x: 6, y: 1, color: paint)
        drawPixel(ctx: context, x: 7, y: 1, color: paint)
        drawPixel(ctx: context, x: 9, y: 1, color: paint)
        drawPixel(ctx: context, x: 11, y: 1, color: paint)
        drawPixel(ctx: context, x: 15, y: 1, color: paint)
        drawPixel(ctx: context, x: 19, y: 1, color: paint)
        drawPixel(ctx: context, x: 20, y: 1, color: paint)
       
        // row 3
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 6, y: 2, color: paint)
        drawPixel(ctx: context, x: 8, y: 2, color: paint)
        drawPixel(ctx: context, x: 9, y: 2, color: paint)
        drawPixel(ctx: context, x: 11, y: 2, color: paint)
        drawPixel(ctx: context, x: 13, y: 2, color: paint)
        drawPixel(ctx: context, x: 15, y: 2, color: paint)
        drawPixel(ctx: context, x: 19, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
        drawPixel(ctx: context, x: 4, y: 3, color: paint)
        drawPixel(ctx: context, x: 6, y: 3, color: paint)
        drawPixel(ctx: context, x: 9, y: 3, color: paint)
        drawPixel(ctx: context, x: 11, y: 3, color: paint)
        drawPixel(ctx: context, x: 12, y: 3, color: paint)
        drawPixel(ctx: context, x: 13, y: 3, color: paint)
        drawPixel(ctx: context, x: 15, y: 3, color: paint)
        drawPixel(ctx: context, x: 16, y: 3, color: paint)
        drawPixel(ctx: context, x: 17, y: 3, color: paint)
        drawPixel(ctx: context, x: 19, y: 3, color: paint)
        drawPixel(ctx: context, x: 20, y: 3, color: paint)
        drawPixel(ctx: context, x: 21, y: 3, color: paint)
    }
       
    func drawWorldAction() {
        rows = 4
        cols = 21
       
        var paint = ActionButtonView.lightGrayColor!
       
        if selected {
            paint = ActionButtonView.altGreenColor!
        }
       
        let context = UIGraphicsGetCurrentContext()!
       
        // row 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        drawPixel(ctx: context, x: 6, y: 0, color: paint)
        drawPixel(ctx: context, x: 7, y: 0, color: paint)
        drawPixel(ctx: context, x: 8, y: 0, color: paint)
        drawPixel(ctx: context, x: 10, y: 0, color: paint)
        drawPixel(ctx: context, x: 11, y: 0, color: paint)
        drawPixel(ctx: context, x: 14, y: 0, color: paint)
        drawPixel(ctx: context, x: 18, y: 0, color: paint)
        drawPixel(ctx: context, x: 19, y: 0, color: paint)
       
        // row 2
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 4, y: 1, color: paint)
        drawPixel(ctx: context, x: 6, y: 1, color: paint)
        drawPixel(ctx: context, x: 8, y: 1, color: paint)
        drawPixel(ctx: context, x: 10, y: 1, color: paint)
        drawPixel(ctx: context, x: 12, y: 1, color: paint)
        drawPixel(ctx: context, x: 14, y: 1, color: paint)
        drawPixel(ctx: context, x: 18, y: 1, color: paint)
        drawPixel(ctx: context, x: 20, y: 1, color: paint)
        
        // row 3
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 1, y: 2, color: paint)
        drawPixel(ctx: context, x: 3, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 6, y: 2, color: paint)
        drawPixel(ctx: context, x: 8, y: 2, color: paint)
        drawPixel(ctx: context, x: 10, y: 2, color: paint)
        drawPixel(ctx: context, x: 11, y: 2, color: paint)
        drawPixel(ctx: context, x: 14, y: 2, color: paint)
        drawPixel(ctx: context, x: 18, y: 2, color: paint)
        drawPixel(ctx: context, x: 20, y: 2, color: paint)
        
        // row 4
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
        drawPixel(ctx: context, x: 4, y: 3, color: paint)
        drawPixel(ctx: context, x: 6, y: 3, color: paint)
        drawPixel(ctx: context, x: 7, y: 3, color: paint)
        drawPixel(ctx: context, x: 8, y: 3, color: paint)
        drawPixel(ctx: context, x: 10, y: 3, color: paint)
        drawPixel(ctx: context, x: 12, y: 3, color: paint)
        drawPixel(ctx: context, x: 14, y: 3, color: paint)
        drawPixel(ctx: context, x: 15, y: 3, color: paint)
        drawPixel(ctx: context, x: 16, y: 3, color: paint)
        drawPixel(ctx: context, x: 18, y: 3, color: paint)
        drawPixel(ctx: context, x: 19, y: 3, color: paint)
    }
    
    func rectForPixel(x: Int, y: Int) -> CGRect {
        let pxWidth = round(self.frame.size.width / CGFloat(self.cols))
        let pxHeight = round(self.frame.size.height / CGFloat(self.rows))
        
        let top = round(CGFloat(y) * pxHeight)
        let left = round(CGFloat(x) * pxWidth)
        
        return CGRect(x: left, y: top, width: pxWidth, height: pxHeight)
    }
    
    func drawPixel(ctx: CGContext, x: Int, y: Int, color: Int32) {
        ctx.setFillColor(UIColor(argb: color).cgColor)
        ctx.addRect(rectForPixel(x: x, y: y))
        ctx.drawPath(using: .fill)
    }
}
