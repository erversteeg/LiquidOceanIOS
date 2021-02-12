//
//  InteractiveCanvasView.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol PaintActionDelegate {
    func notifyPaintActionStarted()
}

class InteractiveCanvasView: UIView, InteractiveCanvasDrawCallback, InteractiveCanvasScaleCallback {

    enum Mode {
        case exploring
        case painting
        case paintSelection
    }
    
    var mode: Mode = .exploring
    
    var scaleFactor = CGFloat(1.0)
    var oldScaleFactor: CGFloat!
    
    var oldPpu: Int!
    
    var undo = false
    
    var interactiveCanvas: InteractiveCanvas!
    
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var drawGestureRecognizer: UIDrawGestureRecognizer!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        interactiveCanvas = InteractiveCanvas()
        interactiveCanvas.drawCallback = self
        interactiveCanvas.scaleCallback = self
        
        interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        
        interactiveCanvas.updateDeviceViewport(screenSize: self.frame.size, canvasCenterX: 256.0, canvasCenterY: 256.0)
        
        // gestures
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        addPan()
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
        self.addGestureRecognizer(pinchGestureRecognizer)
        
        self.drawGestureRecognizer = UIDrawGestureRecognizer(target: self, action: #selector(didDraw(sender:)))
    }
    
    @objc func didDraw(sender: UIDrawGestureRecognizer) {
        let location = sender.location(in: self)
        
        if sender.state == .began {
            if mode == .painting {
                interactiveCanvas.drawCallback?.notifyCanvasRedraw()
                
                let unitPoint = interactiveCanvas.screenPointForUnit(x: location.x, y: location.y)
                
                self.undo = interactiveCanvas.unitInRestorePoints(x: Int(unitPoint.x), y: Int(unitPoint.y)) != nil
                
                if self.undo {
                    interactiveCanvas.paintUnitOrUndo(x: Int(unitPoint.x), y: Int(unitPoint.y), mode: 1)
                }
                else {
                    interactiveCanvas.paintUnitOrUndo(x: Int(unitPoint.x), y: Int(unitPoint.y))
                }
                
                if interactiveCanvas.restorePoints.count == 1 {
                    interactiveCanvas.paintDelegate?.notifyPaintingStarted()
                }
                else if interactiveCanvas.restorePoints.count == 0 {
                    interactiveCanvas.paintDelegate?.notifyPaintingEnded()
                }
            }
            else if mode == .paintSelection {
                let unitPoint = interactiveCanvas.screenPointForUnit(x: location.x, y: location.y)
                SessionSettings.instance.paintColor = interactiveCanvas.arr[Int(unitPoint.y)][Int(unitPoint.x)]
                interactiveCanvas.paintDelegate?.notifyPaintColorUpdate()
            }
        }
        else if sender.state == .changed {
            let unitPoint = interactiveCanvas.screenPointForUnit(x: location.x, y: location.y)
            
            if self.undo {
                // undo
                interactiveCanvas.paintUnitOrUndo(x: Int(unitPoint.x), y: Int(unitPoint.y), mode: 1)
            }
            else {
                // paint
                interactiveCanvas.paintUnitOrUndo(x: Int(unitPoint.x), y: Int(unitPoint.y))
            }
            
            if interactiveCanvas.restorePoints.count == 1 {
                interactiveCanvas.paintDelegate?.notifyPaintingStarted()
            }
            else if interactiveCanvas.restorePoints.count == 0 {
                interactiveCanvas.paintDelegate?.notifyPaintingEnded()
            }
        }
    }
    
    func addPan() {
        self.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    func removePan() {
        self.removeGestureRecognizer(self.panGestureRecognizer)
    }
    
    func addDraw() {
        self.addGestureRecognizer(self.drawGestureRecognizer)
    }
    
    func removeDraw() {
        self.removeGestureRecognizer(self.drawGestureRecognizer)
    }
    
    // pan
    @objc func didPan(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: self)
        
        
        if mode == .exploring {
            interactiveCanvas.translateBy(x: -velocity.x, y: -velocity.y)
        }
        else if mode == .painting {
            
        }
    }
    
    // pinch
    @objc func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        oldScaleFactor = scaleFactor
        scaleFactor *= scale
        
        scaleFactor = CGFloat(max(interactiveCanvas.minScaleFactor, min(Double(scaleFactor), interactiveCanvas.maxScaleFactor)))
        
        oldPpu = interactiveCanvas.ppu
        interactiveCanvas.ppu = Int((CGFloat(interactiveCanvas.basePpu) * scaleFactor))
        
        interactiveCanvas.updateDeviceViewport(screenSize: self.frame.size, fromScale: true)
        interactiveCanvas.drawCallback?.notifyCanvasRedraw()
    }
    
    // scale callback
    func notifyScaleCancelled() {
        scaleFactor = oldScaleFactor
        interactiveCanvas.ppu = oldPpu
    }
    
    func startPainting() {
        self.mode = .painting
        
        removePan()
        addDraw()
    }
    
    func endPainting(accept: Bool) {
        if !accept {
            interactiveCanvas.undoPendingPaint()
            SessionSettings.instance.dropsAmt += interactiveCanvas.restorePoints.count
        }
        else {
            interactiveCanvas.commitPixels()
        }
        
        interactiveCanvas.clearRestorePoints()
        
        interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        
        self.mode = .exploring
        
        removeDraw()
        addPan()
    }
    
    func startPaintSelection() {
        self.mode = .paintSelection
    }
    
    func endPaintSelection() {
        self.mode = .painting
    }
    
    // draw callback
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
        let deviceViewport = interactiveCanvas.deviceViewport!
        let ppu = interactiveCanvas.ppu!
        
        drawUnits(ctx: ctx, deviceViewport: deviceViewport, ppu: ppu)
        
        if interactiveCanvas.ppu >= interactiveCanvas.gridLineThreshold {
            drawGridLines(ctx: ctx, deviceViewport: deviceViewport, ppu: ppu)
        }
    }
    
    func drawGridLines(ctx: CGContext, deviceViewport: CGRect, ppu: Int) {
        if ppu > 0 {
            ctx.setStrokeColor(UIColor(argb: Utils.int32FromColorHex(hex: "0xFFFFFFFF")).cgColor)
            ctx.setLineWidth(1.0)
            
            let unitsWide = Int(self.frame.size.width) / ppu
            let unitsTall = Int(self.frame.size.height) / ppu
            
            let gridXOffsetPx = ((ceil(deviceViewport.origin.x)) - deviceViewport.origin.x) * CGFloat(ppu)
            let gridYOffsetPx = ((ceil(deviceViewport.origin.y)) - deviceViewport.origin.y) * CGFloat(ppu)
            
            for y in 0...unitsTall {
                let curY = CGFloat(y * ppu) + gridYOffsetPx
                drawLine(ctx: ctx, s: CGPoint(x: 0.0, y: curY), e: CGPoint(x: self.frame.size.width, y: curY))
            }
            
            for x in 0...unitsWide {
                let curX = CGFloat(x * ppu) + gridXOffsetPx
                drawLine(ctx: ctx, s: CGPoint(x: curX, y: 0.0), e: CGPoint(x: curX, y: self.frame.size.height))
            }
            
            ctx.drawPath(using: .stroke)
        }
    }
    
    func drawUnits(ctx: CGContext, deviceViewport: CGRect, ppu: Int) {
        let startUnitIndexX = Int(floor(deviceViewport.origin.x))
        let startUnitIndexY = Int(floor(deviceViewport.origin.y))
        let endUnitIndexX = Int(ceil(deviceViewport.origin.x + deviceViewport.size.width))
        let endUnitIndexY = Int(ceil(deviceViewport.origin.y + deviceViewport.size.height))
        
        let rangeX = endUnitIndexX - startUnitIndexX
        let rangeY = endUnitIndexY - startUnitIndexY
        
        for x in 0...rangeX {
            for y in 0...rangeY {
                let unitX = x + startUnitIndexX
                let unitY = y + startUnitIndexY
                
                if unitX >= 0 && unitX < interactiveCanvas.cols && unitY >= 0 && unitY < interactiveCanvas.rows {
                    let color = interactiveCanvas.arr[unitY][unitX]
                    ctx.setFillColor(UIColor(argb: color).cgColor)
                    ctx.addRect(interactiveCanvas.getScreenSpaceForUnit(x: unitX, y: unitY))
                    ctx.drawPath(using: .fill)
                }
            }
        }
    }
    
    func drawLine(ctx: CGContext, s: CGPoint, e: CGPoint) {
        ctx.move(to: s)
        ctx.addLine(to: e)
    }
}
