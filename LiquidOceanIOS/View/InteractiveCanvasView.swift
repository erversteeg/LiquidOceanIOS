//
//  InteractiveCanvasView.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol PaintActionDelegate: AnyObject {
    func notifyPaintActionStarted()
}

protocol InteractiveCanvasPaintDelegate: AnyObject {
    func notifyPaintingStarted()
    func notifyPaintingEnded(accept: Bool)
    func notifyPaintColorUpdate()
}

protocol ObjectSelectionDelegate: AnyObject {
    func notifyObjectSelectionBoundsChanged(upperLeft: CGPoint, lowerRight: CGPoint)
    
    func notifyObjectSelectionEnded()
}

protocol InteractiveCanvasPalettesDelegate: AnyObject {
    func isPalettesViewControllerVisible() -> Bool
    func notifyClosePalettesViewController()
}

protocol InteractiveCanvasGestureDelegate: AnyObject {
    func notifyInteractiveCanvasPan()
    func notifyInteractiveCanvasScale()
}

protocol CanvasFrameDelegate: AnyObject {
    func notifyToggleCanvasFrameView(canvasX: Int, canvasY: Int, screenPoint: CGPoint)
    func notifyCloseCanvasFrameView()
}

protocol CanvasEdgeTouchDelegate: AnyObject {
    func onTouchCanvasEdge()
}

class InteractiveCanvasView: UIView, InteractiveCanvasDrawCallback, InteractiveCanvasScaleCallback, InteractiveCanvasDeviceViewportResetDelegate {

    enum Mode {
        case exploring
        case painting
        case paintSelection
        case exporting
    }
    
    var mode: Mode = .exploring
    
    var scaleFactor = CGFloat(1.0)
    var oldScaleFactor: CGFloat!
    
    var oldPpu: Int!
    
    var undo = false
    
    var interactiveCanvas: InteractiveCanvas!
    
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var drawGestureRecognizer: UIDrawGestureRecognizer!
    
    weak var paintActionDelegate: PaintActionDelegate?
    weak var paintDelegate: InteractiveCanvasPaintDelegate?
    weak var objectSelectionDelegate: ObjectSelectionDelegate?
    weak var palettesDelegate: InteractiveCanvasPalettesDelegate?
    weak var gestureDelegate: InteractiveCanvasGestureDelegate?
    weak var canvasFrameDelegate: CanvasFrameDelegate?
    weak var canvasEdgeTouchDelegate: CanvasEdgeTouchDelegate?
    
    var objectSelectionStartUnit: CGPoint!
    var objectSelectionStartPoint: CGPoint!
    
    var lastPanTranslationX: CGFloat = 0
    var lastPanTranslationY: CGFloat = 0
    
    var startScaleFactor: CGFloat = 0
    
    var touchedCanvasEdge = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        interactiveCanvas = InteractiveCanvas()
        interactiveCanvas.drawCallback = self
        interactiveCanvas.scaleCallback = self
        interactiveCanvas.deviceViewportResetDelegate = self
        
        interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        
        // gestures
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        addPan()
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        addTap()
        
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        addLongPress()
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
        self.addGestureRecognizer(pinchGestureRecognizer)
        
        self.drawGestureRecognizer = UIDrawGestureRecognizer(target: self, action: #selector(didDraw(sender:)))
        
        /*Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { (tmr) in
            let rT = arc4random() % 20 + 1
            Timer.scheduledTimer(withTimeInterval: Double(rT), repeats: false) { (tmr) in
                self.simulateDraw()
            }
        }*/
    }
    
    /*func simulateDraw() {
        let smallAmt = Int(arc4random() % 20) + 2
        let bigAmt = Int(arc4random() % 100) + 50
        
        startPainting()
        
        let r = arc4random() % 10
        
        if r < 2 {
            for _ in 0...smallAmt - 1 {
                let rX = Int(arc4random() % UInt32(interactiveCanvas.cols))
                let rY = Int(arc4random() % UInt32(interactiveCanvas.rows))
                interactiveCanvas.paintUnitOrUndo(x: rX, y: rY, mode: 0)
            }
        }
        else {
            for _ in 0...bigAmt - 1 {
                let rX = Int(arc4random() % UInt32(interactiveCanvas.cols))
                let rY = Int(arc4random() % UInt32(interactiveCanvas.rows))
                interactiveCanvas.paintUnitOrUndo(x: rX, y: rY, mode: 0)
            }
        }
        
        endPainting(accept: true)
    }*/
    
    // draw
    @objc func didDraw(sender: UIDrawGestureRecognizer) {
        let location = sender.location(in: self)
        let view = sender.view!
        
        if sender.state == .began {
            if mode == .painting {
                if palettesDelegate != nil && palettesDelegate!.isPalettesViewControllerVisible() {
                    palettesDelegate?.notifyClosePalettesViewController()
                    return
                }
                
                //interactiveCanvas.drawCallback?.notifyCanvasRedraw()
                
                paintActionDelegate?.notifyPaintActionStarted()
                
                if (location.x > view.frame.size.width - 50 && !SessionSettings.instance.rightHanded) ||
                    (location.x < 50 && SessionSettings.instance.rightHanded || touchedCanvasEdge) {
                    canvasEdgeTouchDelegate?.onTouchCanvasEdge()
                    touchedCanvasEdge = true
                    return
                }
                
                let unitPoint = interactiveCanvas.unitForScreenPoint(x: location.x, y: location.y)
                
                self.undo = interactiveCanvas.unitInRestorePoints(x: Int(unitPoint.x), y: Int(unitPoint.y), restorePointsArr: interactiveCanvas.restorePoints) != nil
                
                if self.undo {
                    interactiveCanvas.paintUnitOrUndo(x: Int(unitPoint.x), y: Int(unitPoint.y), mode: 1)
                }
                else {
                    interactiveCanvas.paintUnitOrUndo(x: Int(unitPoint.x), y: Int(unitPoint.y))
                }
                
                if interactiveCanvas.restorePoints.count == 1 {
                    paintDelegate?.notifyPaintingStarted()
                }
                else if interactiveCanvas.restorePoints.count == 0 {
                    paintDelegate?.notifyPaintingEnded(accept: false)
                }
            }
            else if mode == .paintSelection {
                let unitPoint = interactiveCanvas.unitForScreenPoint(x: location.x, y: location.y)
                let x = Int(unitPoint.x)
                let y = Int(unitPoint.y)
                
                if x >= 0 && x < interactiveCanvas.cols && y >= 0 && y < interactiveCanvas.rows {
                    SessionSettings.instance.paintColor = interactiveCanvas.arr[y][x]
                    paintDelegate?.notifyPaintColorUpdate()
                }
            }
            else if mode == .exporting {
                let unitPoint = interactiveCanvas.unitForScreenPoint(x: location.x, y: location.y)
                
                if interactiveCanvas.isCanvas(unitPoint: unitPoint) {
                    objectSelectionStartUnit = unitPoint
                    objectSelectionStartPoint = location
                }
                
                // interactiveCanvas.exportSelection(unitPoint: unitPoint)
            }
        }
        else if sender.state == .changed {
            if mode == .painting {
                if touchedCanvasEdge {
                    return
                }
                
                let unitPoint = interactiveCanvas.unitForScreenPoint(x: location.x, y: location.y)
                
                if self.undo {
                    // undo
                    interactiveCanvas.paintUnitOrUndo(x: Int(unitPoint.x), y: Int(unitPoint.y), mode: 1)
                }
                else {
                    // paint
                    interactiveCanvas.paintUnitOrUndo(x: Int(unitPoint.x), y: Int(unitPoint.y))
                }
                
                if interactiveCanvas.restorePoints.count == 1 {
                    paintDelegate?.notifyPaintingStarted()
                }
                else if interactiveCanvas.restorePoints.count == 0 {
                    paintDelegate?.notifyPaintingEnded(accept: false)
                }
            }
            else if mode == .exporting {
                let unitPoint = interactiveCanvas.unitForScreenPoint(x: location.x, y: location.y)
                
                if interactiveCanvas.isCanvas(unitPoint: unitPoint) {
                    let minX = fmin(location.x, objectSelectionStartPoint.x)
                    let minY = fmin(location.y, objectSelectionStartPoint.y)
                    
                    let maxX = fmax(location.x, objectSelectionStartPoint.x)
                    let maxY = fmax(location.y, objectSelectionStartPoint.y)
                    
                    objectSelectionDelegate?.notifyObjectSelectionBoundsChanged(upperLeft: CGPoint(x: minX, y: minY), lowerRight: CGPoint(x: maxX, y: maxY))
                }
            }
        }
        else if sender.state == .ended {
            if mode == .exporting {
                let unitPoint = interactiveCanvas.unitForScreenPoint(x: location.x, y: location.y)
                
                if interactiveCanvas.isCanvas(unitPoint: unitPoint) {
                    if unitPoint.x == objectSelectionStartUnit.x && unitPoint.y == objectSelectionStartUnit.y {
                        interactiveCanvas.exportSelection(unitPoint: unitPoint)
                    }
                    else {
                        let minX = fmin(unitPoint.x, objectSelectionStartUnit.x)
                        let minY = fmin(unitPoint.y, objectSelectionStartUnit.y)
                        
                        let maxX = fmax(unitPoint.x, objectSelectionStartUnit.x)
                        let maxY = fmax(unitPoint.y, objectSelectionStartUnit.y)
                        
                        interactiveCanvas.exportSelection(startUnit: CGPoint(x: minX, y: minY), endUnit: CGPoint(x: maxX, y: maxY))
                    }
                    objectSelectionDelegate?.notifyObjectSelectionEnded()
                }
            }
            else if mode == .painting {
                touchedCanvasEdge = false
            }
        }
    }
    
    func setInitalPositionAndScale() {
        // scale
        if SessionSettings.instance.restoreCanvasScaleFactor == CGFloat(0) {
            self.scaleFactor = interactiveCanvas.startScaleFactor
        }
        else {
            self.scaleFactor = SessionSettings.instance.restoreCanvasScaleFactor
        }
        
        self.interactiveCanvas.scaleFactor = self.scaleFactor
        self.interactiveCanvas.ppu = Int(CGFloat(interactiveCanvas.basePpu) * self.scaleFactor)
        
        // position
        if SessionSettings.instance.restoreDeviceViewportLeft == CGFloat(0) {
            interactiveCanvas.updateDeviceViewport(screenSize: self.frame.size, canvasCenterX: CGFloat(interactiveCanvas.cols / 2), canvasCenterY: CGFloat(interactiveCanvas.rows / 2))
        }
        else {
            let x = SessionSettings.instance.restoreDeviceViewportLeft
            let y = SessionSettings.instance.restoreDeviceViewportTop
            let width = SessionSettings.instance.restoreDeviceViewportRight - x
            let height = SessionSettings.instance.restoreDeviceViewportBottom - y
            
            let restoreDeviceViewport = CGRect(x: x, y: y, width: width, height: height)
            interactiveCanvas.deviceViewport = restoreDeviceViewport
        }
    }
    
    func addPan() {
        self.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    func addTap() {
        self.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    func addLongPress() {
        self.addGestureRecognizer(self.longPressGestureRecognizer)
    }
    
    func removePan() {
        self.removeGestureRecognizer(self.panGestureRecognizer)
    }
    
    func removeTap() {
        self.removeGestureRecognizer(self.tapGestureRecognizer)
    }
    
    func removeLongPress() {
        self.removeGestureRecognizer(self.longPressGestureRecognizer)
    }
    
    func addDraw() {
        self.addGestureRecognizer(self.drawGestureRecognizer)
    }
    
    func removeDraw() {
        self.removeGestureRecognizer(self.drawGestureRecognizer)
    }
    
    // pan
    @objc func didPan(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            lastPanTranslationX = 0
            lastPanTranslationY = 0
        }
        else if sender.state == .changed {
            let translation = sender.translation(in: self)
            
            let translateX = lastPanTranslationX - translation.x
            let translateY = lastPanTranslationY - translation.y
            
            if mode == .exploring {
                interactiveCanvas.pixelHistoryDelegate?.notifyHidePixelHistory()
                
                interactiveCanvas.translateBy(x: translateX, y: translateY)
                
                gestureDelegate?.notifyInteractiveCanvasPan()
            }
            else if mode == .painting {
                
            }
            
            lastPanTranslationX = translation.x
            lastPanTranslationY = translation.y
        }
    }
    
    // tap
    @objc func didTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        
        let unitPoint = interactiveCanvas.unitForScreenPoint(x: location.x, y: location.y)
        
        if interactiveCanvas.world {
            if !interactiveCanvas.isBackground(unitPoint: unitPoint) {
                self.interactiveCanvas.getPixelHistoryForUnitPoint(unitPoint: unitPoint) { (success, data) in
                    self.interactiveCanvas.pixelHistoryDelegate?.notifyShowPixelHistory(data: data, screenPoint: location)
                }
            }
        }
        else {
            canvasFrameDelegate?.notifyCloseCanvasFrameView()
        }
    }
    
    // long press
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let location = sender.location(in: self)
            
            let unitPoint = interactiveCanvas.unitForScreenPoint(x: location.x, y: location.y)
            
            if !interactiveCanvas.world {
                canvasFrameDelegate?.notifyToggleCanvasFrameView(canvasX: Int(unitPoint.x), canvasY: Int(unitPoint.y), screenPoint: location)
            }
        }
    }
    
    // pinch
    @objc func didPinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            startScaleFactor = scaleFactor
        }
        else if sender.state == .changed {
            let scale = sender.scale
            
            oldScaleFactor = scaleFactor
            scaleFactor = scale * startScaleFactor
            
            scaleFactor = CGFloat(max(interactiveCanvas.minScaleFactor, min(scaleFactor, interactiveCanvas.maxScaleFactor)))
            interactiveCanvas.scaleFactor = scaleFactor
            
            oldPpu = interactiveCanvas.ppu
            interactiveCanvas.ppu = Int((CGFloat(interactiveCanvas.basePpu) * scaleFactor))
            
            interactiveCanvas.updateDeviceViewport(screenSize: self.frame.size, fromScale: true)
            gestureDelegate?.notifyInteractiveCanvasScale()
            
            interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        }
    }
    
    // scale callback
    func notifyScaleCancelled() {
        scaleFactor = oldScaleFactor
        interactiveCanvas.ppu = oldPpu
    }
    
    func startPainting() {
        self.mode = .painting
        
        removePan()
        removeTap()
        removeLongPress()
        
        addDraw()
    }
    
    func endPainting(accept: Bool) {
        if !accept {
            if interactiveCanvas.restorePoints.count > 0 {
                interactiveCanvas.undoPendingPaint()
                SessionSettings.instance.dropsAmt += interactiveCanvas.restorePoints.count
                
                interactiveCanvas.drawCallback?.notifyCanvasRedraw()
            }
        }
        else {
            interactiveCanvas.commitPixels()
        }
        
        interactiveCanvas.clearRestorePoints()
        
        paintDelegate?.notifyPaintingEnded(accept: accept)
        
        self.mode = .exploring
        
        removeDraw()
        
        addPan()
        addTap()
        addLongPress()
    }
    
    func startPaintSelection() {
        self.mode = .paintSelection
    }
    
    func endPaintSelection() {
        self.mode = .painting
    }
    
    func startExporting() {
        self.mode = .exporting
        
        removePan()
        removeTap()
        removeLongPress()
        
        addDraw()
    }
    
    func endExporting() {
        self.mode = .exploring
        
        addPan()
        addTap()
        addLongPress()
        
        removeDraw()
    }
    
    func isExporting() -> Bool {
        return mode == .exporting
    }
    
    func createCanvasFrame(centerX: Int, centerY: Int, width: Int, height: Int, color: Int32) {
        startPainting()
        
        let oldColor = SessionSettings.instance.paintColor
        SessionSettings.instance.paintColor = color
        
        var minX = centerX - width / 2
        var maxX = centerX + width / 2 + 1
        var minY = centerY - height / 2
        var maxY = centerY + height / 2 + 1
        
        if width % 2 != 0 {
            minX = centerX - (width + 1) / 2
            maxX = centerX + (width + 1) / 2
        }
        
        if height % 2 != 0 {
            minY = centerY - (height + 1) / 2
            maxY = centerY + (height + 1) / 2
        }
        
        // left
        for y in minY...maxY {
            interactiveCanvas.paintUnitOrUndo(x: minX, y: y, redraw: false)
        }
        // right
        for y in minY...maxY {
            interactiveCanvas.paintUnitOrUndo(x: maxX, y: y, redraw: false)
        }
        // top
        for x in minX...maxX {
            interactiveCanvas.paintUnitOrUndo(x: x, y: minY, redraw: false)
        }
        // bottom
        for x in minX...maxX {
            interactiveCanvas.paintUnitOrUndo(x: x, y: maxY, redraw: false)
        }
        
        SessionSettings.instance.paintColor = oldColor
        
        endPainting(accept: true)
        interactiveCanvas.drawCallback?.notifyCanvasRedraw()
    }
    
    func resetDeviceViewport() {
        SessionSettings.instance.restoreDeviceViewportLeft = 0
        SessionSettings.instance.restoreCanvasScaleFactor = 0
        
        setInitalPositionAndScale()
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
        let startTime = Date().timeIntervalSince1970
        let deviceViewport = interactiveCanvas.deviceViewport!
        let ppu = interactiveCanvas.ppu!
        
        drawUnits(ctx: ctx, deviceViewport: deviceViewport, ppu: ppu)
        
        if interactiveCanvas.ppu >= interactiveCanvas.gridLineThreshold {
            drawGridLines(ctx: ctx, deviceViewport: deviceViewport, ppu: ppu)
        }
        //print("draw time (1 / " + String(1 / (Date().timeIntervalSince1970 - startTime)) + " secs)")
    }
    
    func drawGridLines(ctx: CGContext, deviceViewport: CGRect, ppu: Int) {
        if ppu > interactiveCanvas.gridLineThreshold && SessionSettings.instance.showGridLines {
            let gridLineColor = interactiveCanvas.getGridLineColor()
            ctx.setStrokeColor(UIColor(argb: gridLineColor).cgColor)
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
        
        let backgroundColors = interactiveCanvas.getBackgroundColors(index: SessionSettings.instance.backgroundColorIndex)!
        
        let primaryBackground = UIColor(argb: backgroundColors.primary).cgColor
        let secondaryBackground = UIColor(argb: backgroundColors.secondary).cgColor
        
        for x in 0...rangeX {
            for y in 0...rangeY {
                let unitX = x + startUnitIndexX
                let unitY = y + startUnitIndexY
                
                if unitX >= 0 && unitX < interactiveCanvas.cols && unitY >= 0 && unitY < interactiveCanvas.rows {
                    let color = interactiveCanvas.arr[unitY][unitX]

                    if color == 0 {
                        if ((unitX + unitY) % 2 == 0) {
                            ctx.setFillColor(primaryBackground)
                        }
                        else {
                            ctx.setFillColor(secondaryBackground)
                        }
                        
                        ctx.addRect(interactiveCanvas.getScreenSpaceForUnit(x: unitX, y: unitY))
                        ctx.drawPath(using: .fill)
                        
                    }
                    else {
                        ctx.setFillColor(UIColor(argb: color).cgColor)
                        ctx.addRect(interactiveCanvas.getScreenSpaceForUnit(x: unitX, y: unitY))
                        ctx.drawPath(using: .fill)
                    }
                }
                else {
                    ctx.setFillColor(UIColor.black.cgColor)
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
