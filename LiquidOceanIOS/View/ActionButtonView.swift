//
//  ActionButtonView.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/11/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class ActionButtonView: UIView {

    static var altGreenColor = 0xFF42FF7B
    static var whiteColor = 0xFFFFFFFF
    static var blackColor = 0xFF000000
    static var lightAltGreenColor = 0xFFB0FFC5
    static var semiLightColor = 0x33FFFFFF
    static var lightYellowColor = 0xFFFAE38D
    static var yellowColor = 0xFFFAD452
    static var greenColor = 0xFF05AD2E
    static var lightGreenColor = 0x62AD6C
    static var redColor = 0xFFFA3A47
    static var lightRedColor = 0xFFFB7E87
    
    enum ActionType {
        case none
        case paint
        case yes
        case no
        case closePaint
        case paintSelectYes
        case paintSelectCancel
    }
    
    var selected = false
    
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
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        //addGestureRecognizer(tapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        longPressGestureRecognizer.minimumPressDuration = 0
        addGestureRecognizer(longPressGestureRecognizer)
    }
    
    override func draw(_ rect: CGRect) {
        if type == .paint {
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
    }

    //
    @objc func didTap(sender: UITapGestureRecognizer) {
        self.selected = false
        setNeedsDisplay()
    }
    
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.selected = true
            setNeedsDisplay()
        }
        else if sender.state == .cancelled || sender.state == .failed || sender.state == .ended {
            self.selected = false
            setNeedsDisplay()
        }
        
        if sender.state == .ended {
            self.clickHandler?()
        }
    }
    
    func setOnClickListener(handler: @escaping () -> Void) {
        self.clickHandler = handler
    }
    
    func drawClosePaintAction() {
        rows = 5
        cols = 7
        
        var paint = ActionButtonView.yellowColor
        
        if selected {
            paint = ActionButtonView.lightYellowColor
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
        
        let primaryColor = ActionButtonView.whiteColor
        var accentColor = ActionButtonView.altGreenColor
        if selected {
            accentColor = ActionButtonView.lightAltGreenColor
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
        
        var paint = ActionButtonView.greenColor
        if self.selected {
            paint = ActionButtonView.lightGreenColor
        }
        
        if !color {
            paint = ActionButtonView.whiteColor
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
        
        var paint = ActionButtonView.redColor
        if self.selected {
            paint = ActionButtonView.lightRedColor
        }
        
        if !color {
            paint = ActionButtonView.whiteColor
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
    
    func rectForPixel(x: Int, y: Int) -> CGRect {
        let pxWidth = self.frame.size.width / CGFloat(self.cols)
        let pxHeight = self.frame.size.height / CGFloat(self.rows)
        
        let top = CGFloat(y) * pxHeight
        let left = CGFloat(x) * pxWidth
        
        return CGRect(x: left, y: top, width: pxWidth, height: pxHeight)
    }
    
    func drawPixel(ctx: CGContext, x: Int, y: Int, color: Int) {
        ctx.setFillColor(UIColor(argb: color).cgColor)
        ctx.addRect(rectForPixel(x: x, y: y))
        ctx.drawPath(using: .fill)
    }
}
