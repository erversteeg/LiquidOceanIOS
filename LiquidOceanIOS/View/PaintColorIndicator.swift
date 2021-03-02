//
//  PaintColorIndicator.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/11/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol PaintColorSelectionDelegate: AnyObject {
    func notifyPaintColorSelected(color: Int)
}

class PaintColorIndicator: UIView {
    
    weak var paintColorSelectionDelegate: PaintColorSelectionDelegate?
    
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
        
    }
    
    func setPaintColor(color: Int32) {
        SessionSettings.instance.paintColor = color
        setNeedsDisplay()
        
        self.paintColorSelectionDelegate?.notifyPaintColorSelected(color: 0)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        
        var fillAndStroke = false
        if SessionSettings.instance.paintIndicatorFill || SessionSettings.instance.paintIndicatorSquare {
            fillAndStroke = true
        }
        
        let indicatorColor = SessionSettings.instance.paintColor!
        ctx.setStrokeColor(UIColor(argb: indicatorColor).cgColor)
        ctx.setFillColor(UIColor(argb: indicatorColor).cgColor)
        
        var indicatorStrokeWidth = CGFloat(1.0)
        let borderStrokeWidth = CGFloat(1.0)
        
        if SessionSettings.instance.paintIndicatorSquare {
            let width = squareSizeFromOption(widthVal: SessionSettings.instance.paintIndicatorWidth)
            ctx.addRect(CGRect(x: frame.size.width / 2 - width / 2, y: frame.size.height / 2 - width / 2, width: width, height: width))
            ctx.drawPath(using: .fill)
        }
        else if SessionSettings.instance.paintIndicatorFill {
            let width = circleSizeFromOption(widthVal: SessionSettings.instance.paintIndicatorWidth)
            ctx.addArc(center: CGPoint(x: self.frame.size.width / CGFloat(2), y: self.frame.size.height / CGFloat(2)), radius: width, startAngle: 0, endAngle: 6.28319, clockwise: true)
            ctx.drawPath(using: .fill)
        }
        else {
            indicatorStrokeWidth = ringSizeFromOption(widthVal: SessionSettings.instance.paintIndicatorWidth)
            
            ctx.setLineWidth(indicatorStrokeWidth)
            
            var radius = self.frame.width / CGFloat(3)
            
            let w = SessionSettings.instance.paintIndicatorWidth
            if w == 4 {
                radius = frame.size.width * 0.38
            }
            else if w == 5 {
                radius = frame.size.width * 0.43
            }
            
            ctx.addArc(center: CGPoint(x: self.frame.size.width / CGFloat(2), y: self.frame.size.height / CGFloat(2)), radius: radius, startAngle: 0, endAngle: 6.28319, clockwise: true)
            
            ctx.drawPath(using: .stroke)
        }
        
        if SessionSettings.instance.paintIndicatorOutline {
            var radius = frame.size.width / 3
            
            let w = SessionSettings.instance.paintIndicatorWidth
            if !SessionSettings.instance.paintIndicatorFill && !SessionSettings.instance.paintIndicatorSquare && w > 3 {
                if w == 4 {
                    radius = frame.size.width * 0.38
                }
                else if w == 5 {
                    radius = frame.size.width * 0.43
                }
                
            }
            
            ctx.setLineWidth(borderStrokeWidth)
            
            if panelThemeConfig.paintColorIndicatorLineColor == ActionButtonView.blackColor {
                ctx.setStrokeColor(UIColor.black.cgColor)
            }
            else {
                ctx.setStrokeColor(UIColor.white.cgColor)
            }
            
            ctx.addArc(center: CGPoint(x: self.frame.size.width / CGFloat(2), y: self.frame.size.height / CGFloat(2)), radius: radius - (indicatorStrokeWidth / 2  + borderStrokeWidth / 2), startAngle: 0, endAngle: 6.28319, clockwise: true)
            
            if !SessionSettings.instance.paintIndicatorFill && !SessionSettings.instance.paintIndicatorSquare {
                ctx.addArc(center: CGPoint(x: self.frame.size.width / CGFloat(2), y: self.frame.size.height / CGFloat(2)), radius: radius + (indicatorStrokeWidth / 2  + borderStrokeWidth / 2), startAngle: 0, endAngle: 6.28319, clockwise: true)
            }
            
            ctx.drawPath(using: .stroke)
        }
    }
    
    func ringSizeFromOption(widthVal: Int) -> CGFloat {
        switch widthVal {
            case 1:
                return 12
            case 2:
                return 14
            case 3:
                return 16
            case 4:
                return 16
            case 5:
                return 16
            default:
                return 0
        }
    }
    
    func squareSizeFromOption(widthVal: Int) -> CGFloat {
        switch widthVal {
            case 1:
                return frame.size.width * 0.6
            case 2:
                return frame.size.width * 0.7
            case 3:
                return frame.size.width * 0.8
            case 4:
                return frame.size.width * 0.9
            case 5:
                return frame.size.width
            default:
                return 0
        }
    }
    
    func circleSizeFromOption(widthVal: Int) -> CGFloat {
        switch widthVal {
            case 1:
                return frame.size.width * 0.3
            case 2:
                return frame.size.width * 0.35
            case 3:
                return frame.size.width * 0.4
            case 4:
                return frame.size.width * 0.45
            case 5:
                return frame.size.width * 0.5
            default:
                return 0
        }
    }
}
