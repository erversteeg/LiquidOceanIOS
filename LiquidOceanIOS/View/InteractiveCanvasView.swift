//
//  InteractiveCanvasView.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class InteractiveCanvasView: UIView, InteractiveCanvasDrawCallback {

    var interactiveCanvas: InteractiveCanvas!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        interactiveCanvas = InteractiveCanvas()
        interactiveCanvas.drawCallback = self
        
        interactiveCanvas.drawCallback?.notifyCanvasRedraw()
    }
    
    func notifyCanvasRedraw() {
        self.setNeedsDisplay()
    }
    
    // drawing
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            print("could not get graphics context")
            return
        }
        
        drawInteractiveCanvas(ctx: context)
    }
    
    func drawInteractiveCanvas(ctx: CGContext) {
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fill(CGRect(x: 10, y: 10, width: 100, height: 100))
    }
    
    func drawGridLines(ctx: CGContext) {
        
    }
    
    func drawUnits(ctx: CGContext, deviceViewport: CGRect, ppu: Int) {
        
    }
}
