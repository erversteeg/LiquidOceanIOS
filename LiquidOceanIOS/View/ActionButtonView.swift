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
    static var thirdGrayColor: Int32!
    
    enum ActionType {
        case none
        case clickable
        case paint
        case yes
        case yesLight
        case no
        case closePaint
        case paintSelectYes
        case paintSelectCancel
        case play
        case options
        case stats
        case exit
        case howto
        case back
        case backSolid
        case export
        case exportSolid
        case changeBackground
        case gridLines
        case save
        case dot
        case recentColor
        case share
        case single
        case world
        case dev
        case achievements
    }
    
    var selectable = true
    
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
    
    private var _type = ActionType.none
    var type: ActionType {
        set {
            _type = newValue
            setNeedsDisplay()
        }
        get {
            return _type
        }
    }
    
    enum ColorMode {
        case color
        case black
        case white
    }
    
    var colorMode = ColorMode.color
    
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
        ActionButtonView.thirdGrayColor = Utils.int32FromColorHex(hex: "0xFFAAAAAA")
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
            drawYesAction()
        }
        else if type == .paintSelectCancel {
            drawNoAction()
        }
        else if type == .yes {
            drawYesAction()
        }
        else if type == .yesLight {
            drawYesAction()
        }
        else if type == .no {
            drawNoAction()
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
        else if type == .howto {
            drawHowtoAction()
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
        else if type == .gridLines {
            drawGridLinesAction()
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
        else if type == .dev {
            drawDevAction()
        }
        else if type == .achievements {
            drawAchievementAction()
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
        
        if colorMode != .color {
            if colorMode == .black {
                paint = ActionButtonView.blackColor
            }
            else if colorMode == .white {
                paint = ActionButtonView.whiteColor
            }
        }
        
        if selected {
            if colorMode == .color {
                paint = ActionButtonView.lightYellowColor!
            }
            else  if colorMode == .black {
                   paint = ActionButtonView.thirdGrayColor!
            }
            else if colorMode == .white {
                paint = ActionButtonView.twoThirdGrayColor!
            }
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
        
        if selected && selectable {
            accentColor = ActionButtonView.lightAltGreenColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        drawPixel(ctx: context, x: 3, y: 0, color: accentColor)
        drawPixel(ctx: context, x: 2, y: 1, color: primaryColor)
        drawPixel(ctx: context, x: 1, y: 2, color: primaryColor)
        drawPixel(ctx: context, x: 0, y: 3, color: primaryColor)
    }
    
    func drawYesAction() {
        self.rows = 5
        self.cols = 7
        
        var paint = ActionButtonView.greenColor!
        
        if colorMode != .color {
            if colorMode == .black {
                paint = ActionButtonView.blackColor
            }
            else if colorMode == .white {
                paint = ActionButtonView.whiteColor
            }
        }
        
        if selected {
            if colorMode == .color {
                paint = ActionButtonView.lightGreenColor!
            }
            else  if colorMode == .black {
                   paint = ActionButtonView.thirdGrayColor!
            }
            else if colorMode == .white {
                paint = ActionButtonView.twoThirdGrayColor!
            }
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
    
    func drawNoAction() {
        self.rows = 5
        self.cols = 5
        
        var paint = ActionButtonView.redColor!
        
        if colorMode != .color {
            if colorMode == .black {
                paint = ActionButtonView.blackColor
            }
            else if colorMode == .white {
                paint = ActionButtonView.whiteColor
            }
        }
        
        if selected {
            if colorMode == .color {
                paint = ActionButtonView.lightRedColor!
            }
            else  if colorMode == .black {
                   paint = ActionButtonView.thirdGrayColor!
            }
            else if colorMode == .white {
                paint = ActionButtonView.twoThirdGrayColor!
            }
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
    
    func drawGridLinesAction() {
        rows = 1
        cols = 3
        
        var paint = ActionButtonView.semiColor!
        if SessionSettings.instance.darkIcons {
            paint = ActionButtonView.semiDarkColor!
        }
        
        if selected {
            paint = ActionButtonView.lightYellowColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
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
        
        if selected && selectable {
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
        
        if selected && selectable {
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
    
    func drawHowtoAction() {
        rows = 4
        cols = 21
        
        var paint = ActionButtonView.lightGrayColor!
        
        if selected {
            paint = ActionButtonView.altGreenColor!
        }
        
        let context = UIGraphicsGetCurrentContext()!
        
        // H
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 2, y: 3, color: paint)
        
        
        // O
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 1, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 3, color: paint)
        drawPixel(ctx: context, x: 5, y: 0, color: paint)
        drawPixel(ctx: context, x: 5, y: 3, color: paint)
        drawPixel(ctx: context, x: 6, y: 0, color: paint)
        drawPixel(ctx: context, x: 6, y: 1, color: paint)
        drawPixel(ctx: context, x: 6, y: 2, color: paint)
        drawPixel(ctx: context, x: 6, y: 3, color: paint)
        
        // W
        drawPixel(ctx: context, x: 8, y: 0, color: paint)
        drawPixel(ctx: context, x: 8, y: 1, color: paint)
        drawPixel(ctx: context, x: 8, y: 2, color: paint)
        drawPixel(ctx: context, x: 8, y: 3, color: paint)
        drawPixel(ctx: context, x: 9, y: 2, color: paint)
        drawPixel(ctx: context, x: 10, y: 3, color: paint)
        drawPixel(ctx: context, x: 11, y: 2, color: paint)
        drawPixel(ctx: context, x: 12, y: 0, color: paint)
        drawPixel(ctx: context, x: 12, y: 1, color: paint)
        drawPixel(ctx: context, x: 12, y: 2, color: paint)
        drawPixel(ctx: context, x: 12, y: 3, color: paint)
        
        // T
        drawPixel(ctx: context, x: 14, y: 0, color: paint)
        drawPixel(ctx: context, x: 15, y: 0, color: paint)
        drawPixel(ctx: context, x: 15, y: 1, color: paint)
        drawPixel(ctx: context, x: 15, y: 2, color: paint)
        drawPixel(ctx: context, x: 15, y: 3, color: paint)
        drawPixel(ctx: context, x: 16, y: 0, color: paint)
        
        // O
        drawPixel(ctx: context, x: 18, y: 0, color: paint)
        drawPixel(ctx: context, x: 18, y: 1, color: paint)
        drawPixel(ctx: context, x: 18, y: 2, color: paint)
        drawPixel(ctx: context, x: 18, y: 3, color: paint)
        drawPixel(ctx: context, x: 19, y: 0, color: paint)
        drawPixel(ctx: context, x: 19, y: 3, color: paint)
        drawPixel(ctx: context, x: 20, y: 0, color: paint)
        drawPixel(ctx: context, x: 20, y: 1, color: paint)
        drawPixel(ctx: context, x: 20, y: 2, color: paint)
        drawPixel(ctx: context, x: 20, y: 3, color: paint)
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
    
    func drawDevAction() {
        rows = 4
        cols = 12
       
        var paint = ActionButtonView.lightGrayColor!
       
        if selected {
            paint = ActionButtonView.altGreenColor!
        }
       
        let context = UIGraphicsGetCurrentContext()!
       
        // col 1
        drawPixel(ctx: context, x: 0, y: 0, color: paint)
        drawPixel(ctx: context, x: 0, y: 1, color: paint)
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        
        // col 2
        drawPixel(ctx: context, x: 1, y: 0, color: paint)
        drawPixel(ctx: context, x: 1, y: 3, color: paint)
        
        // col 3
        drawPixel(ctx: context, x: 2, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        
        // col 5
        drawPixel(ctx: context, x: 4, y: 0, color: paint)
        drawPixel(ctx: context, x: 4, y: 1, color: paint)
        drawPixel(ctx: context, x: 4, y: 2, color: paint)
        drawPixel(ctx: context, x: 4, y: 3, color: paint)
        
        // col 6
        drawPixel(ctx: context, x: 5, y: 0, color: paint)
        drawPixel(ctx: context, x: 5, y: 1, color: paint)
        drawPixel(ctx: context, x: 5, y: 3, color: paint)
        
        // col 7
        drawPixel(ctx: context, x: 6, y: 0, color: paint)
        drawPixel(ctx: context, x: 6, y: 3, color: paint)
        
        // col 9
        drawPixel(ctx: context, x: 8, y: 0, color: paint)
        drawPixel(ctx: context, x: 8, y: 1, color: paint)
        drawPixel(ctx: context, x: 8, y: 2, color: paint)
        
        // col 10
        drawPixel(ctx: context, x: 9, y: 3, color: paint)
        
        // col 11
        drawPixel(ctx: context, x: 10, y: 2, color: paint)
        
        // col 12
        drawPixel(ctx: context, x: 11, y: 0, color: paint)
        drawPixel(ctx: context, x: 11, y: 1, color: paint)
    }
    
    func drawAchievementAction() {
        rows = 4
        cols = 51
       
        var paint = ActionButtonView.lightGrayColor!
       
        if selected && selectable {
            paint = ActionButtonView.altGreenColor!
        }
       
        let context = UIGraphicsGetCurrentContext()!
       
        // A
        drawPixel(ctx: context, x: 0, y: 2, color: paint)
        drawPixel(ctx: context, x: 0, y: 3, color: paint)
        drawPixel(ctx: context, x: 1, y: 1, color: paint)
        drawPixel(ctx: context, x: 2, y: 0, color: paint)
        drawPixel(ctx: context, x: 2, y: 2, color: paint)
        drawPixel(ctx: context, x: 3, y: 1, color: paint)
        drawPixel(ctx: context, x: 3, y: 2, color: paint)
        drawPixel(ctx: context, x: 3, y: 3, color: paint)
       
        // C
        drawPixel(ctx: context, x: 5, y: 1, color: paint)
        drawPixel(ctx: context, x: 5, y: 2, color: paint)
        drawPixel(ctx: context, x: 6, y: 0, color: paint)
        drawPixel(ctx: context, x: 6, y: 3, color: paint)
        drawPixel(ctx: context, x: 7, y: 0, color: paint)
        drawPixel(ctx: context, x: 7, y: 3, color: paint)
        
        // H
        drawPixel(ctx: context, x: 9, y: 0, color: paint)
        drawPixel(ctx: context, x: 9, y: 1, color: paint)
        drawPixel(ctx: context, x: 9, y: 2, color: paint)
        drawPixel(ctx: context, x: 9, y: 3, color: paint)
        drawPixel(ctx: context, x: 10, y: 1, color: paint)
        drawPixel(ctx: context, x: 11, y: 1, color: paint)
        drawPixel(ctx: context, x: 12, y: 0, color: paint)
        drawPixel(ctx: context, x: 12, y: 1, color: paint)
        drawPixel(ctx: context, x: 12, y: 2, color: paint)
        drawPixel(ctx: context, x: 12, y: 3, color: paint)
        
        // I
        drawPixel(ctx: context, x: 14, y: 0, color: paint)
        drawPixel(ctx: context, x: 14, y: 1, color: paint)
        drawPixel(ctx: context, x: 14, y: 2, color: paint)
        drawPixel(ctx: context, x: 14, y: 3, color: paint)
        
        // E
        drawPixel(ctx: context, x: 16, y: 0, color: paint)
        drawPixel(ctx: context, x: 16, y: 1, color: paint)
        drawPixel(ctx: context, x: 16, y: 2, color: paint)
        drawPixel(ctx: context, x: 16, y: 3, color: paint)
        drawPixel(ctx: context, x: 17, y: 0, color: paint)
        drawPixel(ctx: context, x: 17, y: 1, color: paint)
        drawPixel(ctx: context, x: 17, y: 3, color: paint)
        drawPixel(ctx: context, x: 18, y: 0, color: paint)
        drawPixel(ctx: context, x: 18, y: 3, color: paint)
        
        // V
        drawPixel(ctx: context, x: 20, y: 0, color: paint)
        drawPixel(ctx: context, x: 20, y: 1, color: paint)
        drawPixel(ctx: context, x: 20, y: 2, color: paint)
        drawPixel(ctx: context, x: 21, y: 3, color: paint)
        drawPixel(ctx: context, x: 22, y: 2, color: paint)
        drawPixel(ctx: context, x: 23, y: 0, color: paint)
        drawPixel(ctx: context, x: 23, y: 1, color: paint)
        
        // E
        drawPixel(ctx: context, x: 25, y: 0, color: paint)
        drawPixel(ctx: context, x: 25, y: 1, color: paint)
        drawPixel(ctx: context, x: 25, y: 2, color: paint)
        drawPixel(ctx: context, x: 25, y: 3, color: paint)
        drawPixel(ctx: context, x: 26, y: 0, color: paint)
        drawPixel(ctx: context, x: 26, y: 1, color: paint)
        drawPixel(ctx: context, x: 26, y: 3, color: paint)
        drawPixel(ctx: context, x: 27, y: 0, color: paint)
        drawPixel(ctx: context, x: 27, y: 3, color: paint)
        
        // M
        drawPixel(ctx: context, x: 29, y: 0, color: paint)
        drawPixel(ctx: context, x: 29, y: 1, color: paint)
        drawPixel(ctx: context, x: 29, y: 2, color: paint)
        drawPixel(ctx: context, x: 29, y: 3, color: paint)
        drawPixel(ctx: context, x: 30, y: 1, color: paint)
        drawPixel(ctx: context, x: 31, y: 0, color: paint)
        drawPixel(ctx: context, x: 32, y: 1, color: paint)
        drawPixel(ctx: context, x: 33, y: 0, color: paint)
        drawPixel(ctx: context, x: 33, y: 1, color: paint)
        drawPixel(ctx: context, x: 33, y: 2, color: paint)
        drawPixel(ctx: context, x: 33, y: 3, color: paint)
        
        // E
        drawPixel(ctx: context, x: 35, y: 0, color: paint)
        drawPixel(ctx: context, x: 35, y: 1, color: paint)
        drawPixel(ctx: context, x: 35, y: 2, color: paint)
        drawPixel(ctx: context, x: 35, y: 3, color: paint)
        drawPixel(ctx: context, x: 36, y: 0, color: paint)
        drawPixel(ctx: context, x: 36, y: 1, color: paint)
        drawPixel(ctx: context, x: 36, y: 3, color: paint)
        drawPixel(ctx: context, x: 37, y: 0, color: paint)
        drawPixel(ctx: context, x: 37, y: 3, color: paint)
        
        // N
        drawPixel(ctx: context, x: 39, y: 0, color: paint)
        drawPixel(ctx: context, x: 39, y: 1, color: paint)
        drawPixel(ctx: context, x: 39, y: 2, color: paint)
        drawPixel(ctx: context, x: 39, y: 3, color: paint)
        drawPixel(ctx: context, x: 40, y: 1, color: paint)
        drawPixel(ctx: context, x: 41, y: 2, color: paint)
        drawPixel(ctx: context, x: 42, y: 0, color: paint)
        drawPixel(ctx: context, x: 42, y: 1, color: paint)
        drawPixel(ctx: context, x: 42, y: 2, color: paint)
        drawPixel(ctx: context, x: 42, y: 3, color: paint)
        
        // T
        drawPixel(ctx: context, x: 44, y: 0, color: paint)
        drawPixel(ctx: context, x: 45, y: 0, color: paint)
        drawPixel(ctx: context, x: 45, y: 1, color: paint)
        drawPixel(ctx: context, x: 45, y: 2, color: paint)
        drawPixel(ctx: context, x: 45, y: 3, color: paint)
        drawPixel(ctx: context, x: 46, y: 0, color: paint)
        
        // S
        drawPixel(ctx: context, x: 48, y: 0, color: paint)
        drawPixel(ctx: context, x: 48, y: 3, color: paint)
        drawPixel(ctx: context, x: 49, y: 0, color: paint)
        drawPixel(ctx: context, x: 49, y: 1, color: paint)
        drawPixel(ctx: context, x: 49, y: 3, color: paint)
        drawPixel(ctx: context, x: 50, y: 0, color: paint)
        drawPixel(ctx: context, x: 50, y: 2, color: paint)
        drawPixel(ctx: context, x: 50, y: 3, color: paint)
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
