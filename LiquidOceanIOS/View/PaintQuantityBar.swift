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
    
    var greenColor: Int32!
    var whiteColor: Int32!
    var blueColor: Int32!
    var brownColor: Int32!
    var lightGrayColor: Int32!
    var lineColor: Int32!

    var lineWidth: CGFloat = 1.0
    
    var flashingError = false
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        commonInit()
    }
    
    func commonInit() {
        greenColor = Utils.int32FromColorHex(hex: "0xFF42FF7B")
        whiteColor = Utils.int32FromColorHex(hex: "0xFFFFFFFF")
        blueColor = Utils.int32FromColorHex(hex: "0xFF84BAFF")
        brownColor = Utils.int32FromColorHex(hex: "0xFF633D21")
        lightGrayColor = Utils.int32FromColorHex(hex: "0xFFE6EBE6")
        
        lineColor = Utils.int32FromColorHex(hex: "0xFFFFFFFF")
        
        self.backgroundColor = UIColor.clear
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        
        drawPixelBorder(ctx: ctx)
        drawQuantity(ctx: ctx)
    }
    
    func drawPixelBorder(ctx: CGContext) {
        for x in 1...cols - 2 {
            drawPixel(ctx: ctx, x: x, y: 0, color: whiteColor)
        }
        for x in 1...cols - 2 {
            drawPixel(ctx: ctx, x: x, y: 2, color: whiteColor)
        }
        
        // decor
        drawPixel(ctx: ctx, x: 6, y: 0, color: lightGrayColor)
        drawPixel(ctx: ctx, x: 2, y: 2, color: lightGrayColor)
        drawPixel(ctx: ctx, x: 8, y: 2, color: lightGrayColor)
        
        // ends
        drawPixel(ctx: ctx, x: 0, y: 1, color: greenColor)
        drawPixel(ctx: ctx, x: cols - 1, y: 1, color: whiteColor)
    }
    
    func drawQuantity(ctx: CGContext) {
        let pxWidth = self.frame.size.width / CGFloat(cols)
        let pxHeight = self.frame.size.height / CGFloat(rows)
        
        let relQty = CGFloat(SessionSettings.instance.dropsAmt) / CGFloat(SessionSettings.instance.maxPaintAmt)
        
        let numPixels = cols - 2
        let qtyPer = 1.0 / CGFloat(numPixels)
        var curProg: CGFloat = 0.0
        
        for x in 1...cols - 2 {
            if relQty > curProg {
                drawPixel(ctx: ctx, x: (cols - 1) - x, y: 1, color: blueColor)
            }
            else {
                if flashingError {
                    drawPixel(ctx: ctx, x: (cols - 1), y: 1, color: ActionButtonView.redColor)
                }
                else {
                    drawPixel(ctx: ctx, x: (cols - 1) - x, y: 1, color: brownColor)
                }
            }
            
            if x < cols - 2 {
                drawLine(ctx: ctx, start: CGPoint(x: CGFloat(cols - 1 - x) * pxWidth, y: pxHeight), end: CGPoint(x: CGFloat(cols - 1 - x) * pxWidth, y: pxHeight * 2), color: lineColor)
            }
            
            curProg += qtyPer
        }
    }

    func rectForPixel(x: Int, y: Int) -> CGRect {
        let pxWidth = self.frame.size.width / CGFloat(self.cols)
        let pxHeight = self.frame.size.height / CGFloat(self.rows)
        
        let top = CGFloat(y) * pxHeight
        let left = CGFloat(x) * pxWidth
        
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
