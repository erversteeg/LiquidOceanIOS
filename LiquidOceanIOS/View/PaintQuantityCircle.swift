//
//  PaintQuantityCircle.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 3/16/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class PaintQuantityCircle: UIView, PaintQtyDelegate, PaintActionDelegate {

    let rows = 3
    let cols = 13
    
    var bgColor: Int32!
    var primaryColor: Int32!
    
    var flashingError = false
    
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
        
        if panelThemeConfig.darkPaintQtyBar {
            bgColor = Utils.int32FromColorHex(hex: "0xff2f2f2f")
        }
        else {
            bgColor = UIColor.white.argb()
        }
        
        self.backgroundColor = UIColor.clear
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        
        let relQty = CGFloat(SessionSettings.instance.dropsAmt) / CGFloat(SessionSettings.instance.maxPaintAmt)
        
        if flashingError {
            bgColor = ActionButtonView.redColor
        }
        else {
            if panelThemeConfig.darkPaintQtyBar {
                bgColor = Utils.int32FromColorHex(hex: "0xff2f2f2f")
            }
            else {
                bgColor = UIColor.white.argb()
            }
        }
        
        let circleMask = UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2).cgPath
        ctx.addPath(circleMask)
        ctx.clip()
        
        ctx.setFillColor(UIColor(argb: bgColor).cgColor)
        ctx.addRect(CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        ctx.drawPath(using: .fill)
        
        ctx.setFillColor(UIColor(argb: primaryColor).cgColor)
        ctx.addRect(CGRect(x: 0, y: (1 - relQty) * frame.height, width: frame.width, height: relQty * frame.height))
        ctx.drawPath(using: .fill)
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

