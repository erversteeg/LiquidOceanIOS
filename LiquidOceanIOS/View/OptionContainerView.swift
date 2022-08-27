//
//  OptionContainer.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 8/27/22.
//  Copyright © 2022 Eric Versteeg. All rights reserved.
//

import UIKit

class OptionContainerView: UIView {
    
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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setStrokeColor(UIColor(argb: 0x33ffffff).cgColor)
        ctx.setLineWidth(1)
        
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: rect.width, y: 0))
        
        ctx.strokePath()
    }
}
