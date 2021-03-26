//
//  AchievementIcon.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 3/26/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class AchievementIcon: UIView {
    
    var single1 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var single2 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 0, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var single3 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 0, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var single4 = [
        1, 1, 0, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 0, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var single5 = [
        1, 1, 0, 1, 1,
        1, 0, 1, 0, 1,
        1, 1, 0, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var single6 = [
        1, 1, 0, 1, 1,
        1, 0, 1, 0, 1,
        1, 1, 0, 1, 0,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var single7 = [
        1, 1, 0, 1, 1,
        1, 0, 1, 0, 1,
        1, 1, 0, 1, 0,
        1, 0, 1, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var single8 = [
        1, 1, 0, 1, 1,
        1, 0, 1, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 1, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var world1 = [
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world2 = [
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world3 = [
        1, 1, 1, 0, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world4 = [
        1, 1, 0, 0, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world5 = [
        1, 1, 0, 0, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world6 = [
        1, 1, 0, 0, 0,
        1, 1, 1, 0, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world7 = [
        0, 1, 0, 0, 0,
        1, 1, 1, 0, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world8 = [
        0, 1, 0, 0, 0,
        0, 1, 1, 0, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world9 = [
        0, 0, 0, 0, 0,
        0, 1, 1, 0, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world10 = [
        0, 0, 0, 0, 0,
        0, 1, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world11 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var world12 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 0
    ]
    
    var world13 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 1, 0
    ]
    
    var world14 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 1, 0,
        1, 1, 1, 0, 0
    ]
    
    var world15 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 1, 0,
        1, 1, 0, 0, 0
    ]
    
    var world16 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 0, 0,
        1, 1, 0, 0, 0
    ]
    
    var world17 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 0, 0,
        0, 1, 0, 0, 0
    ]
    
    var world18 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 0, 0,
        0, 1, 0, 0, 0
    ]
    
    var world19 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 0, 0,
        0, 0, 0, 0, 0
    ]
    
    var world20 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        0, 0, 1, 0, 0,
        0, 0, 0, 0, 0
    ]
    
    var world21 = [
        0, 0, 0, 0, 0,
        0, 0, 1, 0, 0,
        0, 1, 0, 1, 0,
        0, 0, 1, 0, 0,
        0, 0, 0, 0, 0
    ]
    
    var world22 = [
        0, 0, 0, 0, 0,
        0, 1, 1, 0, 0,
        0, 1, 0, 1, 0,
        0, 0, 1, 0, 0,
        0, 0, 0, 0, 0
    ]
    
    var world23 = [
        0, 0, 0, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 0, 1, 0,
        0, 0, 1, 0, 0,
        0, 0, 0, 0, 0
    ]
    
    var world24 = [
        0, 0, 0, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 0, 1, 0,
        0, 0, 1, 1, 0,
        0, 0, 0, 0, 0
    ]
    
    var world25 = [
        0, 0, 0, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 0, 1, 0,
        0, 1, 1, 1, 0,
        0, 0, 0, 0, 0
    ]
    
    var world26 = [
        0, 0, 0, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 1, 0,
        0, 0, 0, 0, 0
    ]
    
    var world27 = [
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 1, 0,
        0, 0, 0, 0, 0
    ]
    
    var world28 = [
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 1, 0,
        0, 0, 1, 0, 0
    ]
    
    var world29 = [
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        0, 1, 1, 1, 1,
        0, 1, 1, 1, 0,
        0, 0, 1, 0, 0
    ]
    
    var world30 = [
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 1, 1, 1,
        0, 1, 1, 1, 0,
        0, 0, 1, 0, 0
    ]
    
    var world31 = [
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 1, 0, 1, 1,
        0, 1, 1, 1, 0,
        0, 0, 1, 0, 0
    ]
    
    var world32 = [
        0, 0, 1, 0, 0,
        0, 1, 1, 1, 0,
        1, 0, 0, 0, 1,
        0, 1, 1, 1, 0,
        0, 0, 1, 0, 0
    ]
    
    var world33 = [
        0, 0, 1, 0, 0,
        0, 1, 0, 1, 0,
        1, 0, 0, 0, 1,
        0, 1, 0, 1, 0,
        0, 0, 1, 0, 0
    ]
    
    var world34 = [
        1, 0, 1, 0, 0,
        0, 1, 0, 1, 0,
        1, 0, 0, 0, 1,
        0, 1, 0, 1, 0,
        0, 0, 1, 0, 0
    ]
    
    var world35 = [
        1, 0, 1, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 0, 0, 1,
        0, 1, 0, 1, 0,
        0, 0, 1, 0, 0
    ]
    
    var world36 = [
        1, 0, 1, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 0, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 1, 0, 0
    ]
    
    var world37 = [
        1, 0, 1, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 0, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 1, 0, 1
    ]
    
    var world38 = [
        1, 0, 1, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 0, 0, 1,
        0, 0, 0, 0, 0,
        1, 0, 1, 0, 1
    ]
    
    var world39 = [
        1, 0, 1, 0, 1,
        0, 0, 0, 0, 0,
        1, 0, 0, 0, 1,
        0, 0, 0, 0, 0,
        1, 0, 1, 0, 1
    ]
    
    var world40 = [
        1, 0, 1, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 2, 0, 1,
        0, 1, 0, 1, 0,
        1, 0, 1, 0, 1
    ]
    
    var oIn1 = [
        1, 1, 1, 1, 1,
        1, 0, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oIn2 = [
        1, 1, 1, 1, 1,
        1, 0, 1, 1, 1,
        1, 0, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oIn3 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 1, 1,
        1, 0, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oIn4 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 1, 1,
        1, 0, 0, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oIn5 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 1, 1,
        1, 0, 0, 1, 1,
        1, 0, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oIn6 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 1, 1,
        1, 0, 0, 1, 1,
        1, 0, 0, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oIn7 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 0, 1,
        1, 0, 0, 1, 1,
        1, 0, 0, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oIn8 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 0, 1,
        1, 0, 0, 0, 1,
        1, 0, 0, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut1 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut2 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut3 = [
        1, 1, 1, 1, 1,
        1, 1, 0, 0, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut4 = [
        1, 1, 1, 1, 1,
        1, 1, 0, 0, 1,
        1, 1, 0, 0, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut5 = [
        1, 1, 1, 1, 1,
        1, 1, 0, 0, 1,
        1, 1, 0, 0, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut6 = [
        1, 1, 1, 1, 1,
        1, 1, 0, 0, 1,
        1, 1, 0, 0, 1,
        1, 1, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut7 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 0, 1,
        1, 1, 0, 0, 1,
        1, 1, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut8 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 0, 1,
        1, 0, 0, 0, 1,
        1, 1, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var oOut9 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 0, 1,
        1, 0, 1, 0, 1,
        1, 0, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var paint1 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var paint2 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var paint3 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 0, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var paint4 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 1, 1, 0, 1,
        1, 0, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var paint5 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 0, 1, 0, 1,
        1, 0, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var paint6 = [
        1, 1, 1, 1, 1,
        1, 1, 1, 1, 1,
        1, 0, 0, 0, 1,
        1, 0, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    var paint7 = [
        1, 1, 1, 1, 1,
        1, 0, 0, 0, 1,
        1, 0, 0, 0, 1,
        1, 0, 0, 0, 1,
        1, 1, 1, 1, 1
    ]
    
    static var whiteColor: Int32!
    static var blackColor: Int32!
    static var blueColor: Int32!
    
    var eventType: StatTracker.EventType!
    var thresholds = 0
    
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
        
        AchievementIcon.whiteColor = Utils.int32FromColorHex(hex: "0xFFFFFFFF")
        AchievementIcon.blackColor = Utils.int32FromColorHex(hex: "0xFF000000")
        AchievementIcon.blueColor = Utils.int32FromColorHex(hex: "0xFF1A1ED7")
    }
    
    func setType(achievementType: StatTracker.EventType, thresholds: Int) {
        self.eventType = achievementType
        self.thresholds = thresholds
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        
        if thresholds > 0 {
            drawIcon(ctx: ctx)
        }
    }
    
    func drawIcon(ctx: CGContext) {
        if thresholds == 0 {
            return
        }
        
        var icon: [Int]!
        
        let singleIcons = [single1, single2, single3, single4, single5, single6, single7, single8]
        
        let worldIcons = [world1, world2, world3, world4, world5, world6, world7, world8, world9, world10,
        world11, world12, world13, world14, world15, world16, world17, world18, world19, world20, world21, world22,
        world23, world24, world25, world26, world27, world28, world29, world30, world31, world32, world33, world34,
        world35, world36, world37, world38, world39, world40]
        
        let pixelIn = [oIn1, oIn2, oIn3, oIn4, oIn5, oIn6, oIn7, oIn8]
        
        let pixelOut = [oOut1, oOut2, oOut3, oOut4, oOut5, oOut6, oOut7, oOut8, oOut9]
        
        let paint = [paint1, paint2, paint3, paint4, paint5, paint6, paint7]
        
        if eventType == StatTracker.EventType.pixelPaintedSingle {
            icon = singleIcons[thresholds - 1]
        }
        else if eventType == StatTracker.EventType.pixelPaintedWorld {
            icon = worldIcons[thresholds - 1]
        }
        else if eventType == StatTracker.EventType.pixelOverwriteIn {
            icon = pixelIn[thresholds - 1]
        }
        else if eventType == StatTracker.EventType.pixelOverwriteOut {
            icon = pixelOut[thresholds - 1]
        }
        else if eventType == StatTracker.EventType.paintReceived {
            icon = paint[thresholds - 1]
        }
        
        for y in 0...4 {
            for x in 0...4 {
                if icon[y * 5 + x] == 1 {
                    drawPixel(ctx: ctx, x: x, y: y, color: AchievementIcon.blackColor)
                }
                else if icon[y * 5 + x] == 2 {
                    drawPixel(ctx: ctx, x: x, y: y, color: AchievementIcon.blueColor)
                }
                else {
                    drawPixel(ctx: ctx, x: x, y: y, color: AchievementIcon.whiteColor)
                }
            }
        }
    }
    
    func rectForPixel(x: Int, y: Int) -> CGRect {
        let pxWidth = round(self.frame.size.width / 5)
        let pxHeight = round(self.frame.size.height / 5)
        
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
