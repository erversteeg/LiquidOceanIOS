//
//  DeviceViewportSummaryView.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 10/30/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class DeviceViewportSummaryView: UIView {

    var _interactiveCanvas: InteractiveCanvas?
    var interactiveCanvas: InteractiveCanvas? {
        set {
            _interactiveCanvas = newValue
            setNeedsDisplay()
        }
        get {
            return _interactiveCanvas
        }
    }
    
    var ppu = CGFloat(10)
    
    let margin = 2
    
    var _point = CGPoint(x: 0, y: 0)
    var point: CGPoint {
        set {
            _point = newValue
            setNeedsDisplay()
        }
        get {
            return _point
        }
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        commonInit()
    }
    
    func commonInit() {
        let tgr = UITouchGestureRecognizer(target: self, action: #selector(didTouch(sender:)))
        
        self.addGestureRecognizer(tgr)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let ctx = UIGraphicsGetCurrentContext()!
        drawViewport(ctx: ctx)
    }
    
    @objc func didTouch(sender: UITouchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let point = sender.location(in: self)
            moveDeviceViewport(point: point)
        }
    }
    
    func moveDeviceViewport(point: CGPoint) {
        let interactiveCanvas = interactiveCanvas!
        var deviceViewport = interactiveCanvas.deviceViewport!
        
        let scale = CGFloat(interactiveCanvas.cols) / frame.size.width
        
        let dX = point.x * scale - (deviceViewport.origin.x + deviceViewport.size.width / 2)
        let dY = point.y * scale - (deviceViewport.origin.y + deviceViewport.size.height / 2)
        
        deviceViewport.origin.x += dX
        deviceViewport.origin.y += dY
        
        interactiveCanvas.deviceViewport = deviceViewport
        interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        
        setNeedsDisplay()
    }
    
    func drawViewport(ctx: CGContext) {        
        if interactiveCanvas != nil {
            let interactiveCanvas = interactiveCanvas!
            let displayPpu = frame.size.width / CGFloat(interactiveCanvas.cols)
            
            let left = interactiveCanvas.deviceViewport.origin.x * displayPpu
            let top = interactiveCanvas.deviceViewport.origin.y * displayPpu
            let right = (interactiveCanvas.deviceViewport.origin.x + interactiveCanvas.deviceViewport.size.width) * displayPpu
            let bottom = (interactiveCanvas.deviceViewport.origin.y + interactiveCanvas.deviceViewport.size.height) * displayPpu
            
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setLineWidth(2)
            
            ctx.move(to: CGPoint(x: left, y: top))
            ctx.addLine(to: CGPoint(x: right, y: top))
            ctx.addLine(to: CGPoint(x: right, y: bottom))
            ctx.addLine(to: CGPoint(x: left, y: bottom))
            ctx.addLine(to: CGPoint(x: left, y: top))
            
            ctx.drawPath(using: .stroke)
        }
    }
}
