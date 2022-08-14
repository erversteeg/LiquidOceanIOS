//
//  PaintQuantityBar.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/12/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class PaintQuantityBar: UIView, PaintQtyDelegate, PaintActionDelegate {

    let rows = 3
    let cols = 13
    
    var primaryColor: Int32!
    var greenColor: Int32!
    var whiteColor: Int32!
    var blueColor: Int32!
    var brownColor: Int32!
    var lightGrayColor: Int32!
    var lineColor: Int32!
    var darkGrayColor: Int32!
    var grayAccentColor: Int32!
    var darkLineColor: Int32!
    
    var thirdGraySemiColor: Int32!
    var twoThirdGraySemiColor: Int32!

    var lineWidth: CGFloat = 1.0
    
    var flashingError = false
    
    var world = false
    
    var panelThemeConfig: PanelThemeConfig!
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        commonInit()
    }
    
    func commonInit() {
        panelThemeConfig = PanelThemeConfig.defaultLightTheme()
        
        primaryColor = SessionSettings.instance.paintIndicatorColor
        
        greenColor = Utils.int32FromColorHex(hex: "0xFF42FF7B")
        whiteColor = Utils.int32FromColorHex(hex: "0xFFFFFFFF")
        blueColor = Utils.int32FromColorHex(hex: "0xFF84BAFF")
        brownColor = Utils.int32FromColorHex(hex: "0xFF633D21")
        lightGrayColor = Utils.int32FromColorHex(hex: "0xFFE6EBE6")
        
        darkGrayColor = Utils.int32FromColorHex(hex: "0xff2f2f2f")
        grayAccentColor = Utils.int32FromColorHex(hex: "0xff484948")
        
        darkLineColor = darkGrayColor
        
        lineColor = Utils.int32FromColorHex(hex: "0xFFFFFFFF")
        
        thirdGraySemiColor = Utils.int32FromColorHex(hex: "0x99AAAAAA")
        twoThirdGraySemiColor = Utils.int32FromColorHex(hex: "0x99555555")
        
        self.backgroundColor = UIColor.clear
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        
        //drawPixelBorder(ctx: ctx)
        drawQuantity(ctx: ctx)
    }
    
    func drawPixelBorder(ctx: CGContext) {
        if panelThemeConfig.darkPaintQtyBar {
            for x in 1...cols - 2 {
                drawPixel(ctx: ctx, x: x, y: 0, color: darkGrayColor)
            }
            for x in 1...cols - 2 {
                drawPixel(ctx: ctx, x: x, y: 2, color: darkGrayColor)
            }
            
            // decor
            //drawPixel(ctx: ctx, x: 6, y: 0, color: grayAccentColor)
            //drawPixel(ctx: ctx, x: 2, y: 2, color: grayAccentColor)
            //drawPixel(ctx: ctx, x: 8, y: 2, color: grayAccentColor)
            
            // ends
            drawPixel(ctx: ctx, x: 0, y: 1, color: darkGrayColor)
            drawPixel(ctx: ctx, x: cols - 1, y: 1, color: darkGrayColor)
        }
        else {
            for x in 1...cols - 2 {
                drawPixel(ctx: ctx, x: x, y: 0, color: whiteColor)
            }
            for x in 1...cols - 2 {
                drawPixel(ctx: ctx, x: x, y: 2, color: whiteColor)
            }
            
            // decor
            //drawPixel(ctx: ctx, x: 6, y: 0, color: lightGrayColor)
            //drawPixel(ctx: ctx, x: 2, y: 2, color: lightGrayColor)
            //drawPixel(ctx: ctx, x: 8, y: 2, color: lightGrayColor)
            
            // ends
            drawPixel(ctx: ctx, x: 0, y: 1, color: whiteColor)
            drawPixel(ctx: ctx, x: cols - 1, y: 1, color: whiteColor)
        }
    }
    
    func drawQuantity(ctx: CGContext) {
        let relQty = CGFloat(SessionSettings.instance.dropsAmt) / CGFloat(SessionSettings.instance.maxPaintAmt)
        
        ctx.setLineCap(CGLineCap.round)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(frame.size.height)
        ctx.move(to: CGPoint(x: frame.size.height / 2, y: frame.size.height / 2))
        ctx.addLine(to: CGPoint(x: frame.size.width - frame.size.height / 2, y: frame.size.height / 2))
        ctx.drawPath(using: .stroke)
        
        if relQty == 0 { return }
            
        ctx.setStrokeColor(UIColor(argb: SessionSettings.instance.paintIndicatorColor).cgColor)
        ctx.move(to: CGPoint(x: (1 - relQty) * frame.size.width + frame.size.height / 2, y: frame.size.height / 2))
        ctx.addLine(to: CGPoint(x: frame.size.width - frame.size.height / 2, y: frame.size.height / 2))
        ctx.drawPath(using: .stroke)
        
        /*let pxWidth = self.frame.size.width / CGFloat(cols)
        let pxHeight = self.frame.size.height / CGFloat(rows)
        
        var relQty = CGFloat(SessionSettings.instance.dropsAmt) / CGFloat(SessionSettings.instance.maxPaintAmt)
        
        let numPixels = cols - 2
        let qtyPer = 1.0 / CGFloat(numPixels)
        var curProg: CGFloat = 0.0
        
        for x in 1...cols - 2 {
            if relQty > curProg {
                /*if world {
                    drawPixel(ctx: ctx, x: (cols - 1) - x, y: 1, color: blueColor)
                }
                else {
                    if panelThemeConfig.darkPaintQtyBar {
                        drawPixel(ctx: ctx, x: (cols - 1) - x, y: 1, color: ActionButtonView.thirdGrayColor)
                    }
                    else {
                        drawPixel(ctx: ctx, x: (cols - 1) - x, y: 1, color: ActionButtonView.twoThirdGrayColor)
                    }
                }*/
                drawPixel(ctx: ctx, x: (cols - 1) - x, y: 1, color: primaryColor)
            }
            else {
                if flashingError && world && relQty == 0 {
                    drawPixel(ctx: ctx, x: (cols - 1) - x, y: 1, color: ActionButtonView.redColor)
                }
                else {
                    drawPixel(ctx: ctx, x: (cols - 1) - x, y: 1, color: UIColor.black.argb()!)
                }
            }
            
            /*if x < cols - 2 {
                if panelThemeConfig.darkPaintQtyBar {
                    drawLine(ctx: ctx, start: CGPoint(x: CGFloat(cols - 1 - x) * pxWidth, y: pxHeight), end: CGPoint(x: CGFloat(cols - 1 - x) * pxWidth, y: pxHeight * 2), color: twoThirdGraySemiColor)
                }
                else {
                    drawLine(ctx: ctx, start: CGPoint(x: CGFloat(cols - 1 - x) * pxWidth, y: pxHeight), end: CGPoint(x: CGFloat(cols - 1 - x) * pxWidth, y: pxHeight * 2), color: thirdGraySemiColor)
                }
            }*/
            
            curProg += qtyPer
        }*/
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
    
    func drawLine(ctx: CGContext, start: CGPoint, end: CGPoint, color: Int32) {
        ctx.setStrokeColor(UIColor(argb: color).cgColor)
        ctx.move(to: start)
        ctx.addLine(to: end)
        ctx.drawPath(using: .stroke)
    }
    
    func flashError() {
        flashingError = true
        setNeedsDisplay()
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (tmr) in
            self.flashingError = false
            self.setNeedsDisplay()
        }
    }
    
    // paint qty delegate
    func notifyPaintQtyChanged(qty: Int) {
        setNeedsDisplay()
    }
    
    // paint action delegate
    func notifyPaintActionStarted() {
        if SessionSettings.instance.dropsAmt == 0 {
            flashError()
        }
    }
}
