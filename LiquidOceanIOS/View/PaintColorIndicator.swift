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
        
        let borderStrokeWidth = CGFloat(1.0)
        let indicatorStrokeWidth = CGFloat(12.0)
        
        let indicatorColor = SessionSettings.instance.paintColor!
        
        ctx.setLineWidth(indicatorStrokeWidth)
        ctx.setStrokeColor(UIColor(argb: indicatorColor).cgColor)
        
        ctx.addArc(center: CGPoint(x: self.frame.size.width / CGFloat(2), y: self.frame.size.height / CGFloat(2)), radius: self.frame.width / CGFloat(3), startAngle: 0, endAngle: 6.28319, clockwise: true)
        
        ctx.drawPath(using: .stroke)
    }
}
