//
//  InteractiveCanvas.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol InteractiveCanvasDrawCallback: AnyObject {
    func notifyCanvasRedraw()
}

class InteractiveCanvas: NSObject {
    var rows = 512
    var cols = 512
    
    var arr = [[Int]]()
    
    var basePpu = 100
    var ppu: Int!
    
    var deviceViewport: CGRect!
    
    weak var drawCallback: InteractiveCanvasDrawCallback?
    
    var startScaleFactor = 0.2
    
    override init() {
        super.init()
        
        ppu = Int(Double(basePpu) * startScaleFactor)
        
        var dataJsonStr = SessionSettings.instance.userDefaults().object(forKey: "arr") as? String
        
        if dataJsonStr == nil {
            loadDefault()
        }
        else {
            initPixels(arrJsonStr: dataJsonStr!)
        }
    }
    
    func initPixels(arrJsonStr: String) {
        do {
            if let outerArray = try JSONSerialization.jsonObject(with: arrJsonStr.data(using: .utf8)!, options: []) as? [Any] {
                
                for i in 0...outerArray.count - 1 {
                    let innerArr = outerArray[i] as! [Int]
                    var arrRow = [Int]()
                    for j in 0...innerArr.count - 1 {
                        arrRow.append(innerArr[j])
                    }
                    arr.append(arrRow)
                }
            }
        }
        catch {
            
        }
    }
    
    func loadDefault() {
        for i in 0...rows - 1 {
            var innerArr = [Int]()
            for j in 0...cols - 1 {
                if (i + j) % 2 == 0 {
                    innerArr.append(0xFF333333)
                }
                else {
                    innerArr.append(0xFF666666)
                }
            }
            
            arr.append(innerArr)
        }
    }
    
    func save() {
        do {
            SessionSettings.instance.userDefaults().set(try JSONSerialization.data(withJSONObject: arr, options: .fragmentsAllowed), forKey: "arr")
        }
        catch {
            
        }
    }
    
    func updateDeviceViewport(screenSize: CGSize, canvasCenterX: Float, canvasCenterY: Float) {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let canvasCenterXPx = Int((canvasCenterX * Float(ppu)))
        let canvasCenterYPx = Int((canvasCenterY * Float(ppu)))
        
        let canvasTop = canvasCenterYPx - Int(screenHeight) / 2
        let canvasBottom = canvasCenterYPx + Int(screenHeight) / 2
        let canvasLeft = canvasCenterXPx - Int(screenWidth) / 2
        let canvasRight = canvasCenterXPx + Int(screenWidth) / 2
        
        let top = Double(canvasTop) / Double(ppu)
        let bottom = Double(canvasBottom) / Double(ppu)
        let left = Double(canvasLeft) / Double(ppu)
        let right = Double(canvasRight) / Double(ppu)
        
        deviceViewport = CGRect(x: left, y: top, width: (right - left), height: (bottom - top))
    }
    
    func getScreenSpaceForUnit(x: Int, y: Int) -> CGRect {
        let offsetX = (CGFloat(x) - deviceViewport.origin.x) * CGFloat(ppu)
        let offsetY = (CGFloat(y) - deviceViewport.origin.y) * CGFloat(ppu)
        
        return CGRect(x: max(offsetX, 0.0), y: max(offsetY, 0.0), width: offsetX + CGFloat(ppu), height: offsetY + CGFloat(ppu))
    }
    
    func translateBy(x: CGFloat, y: CGFloat) {
        var dX = x / CGFloat(ppu)
        var dY = y / CGFloat(ppu)
        
        var left = deviceViewport.origin.x
        var top = deviceViewport.origin.y
        var right = left + deviceViewport.size.width
        var bottom = top + deviceViewport.size.height
        
        if left + dX < 0.0 {
            let diff = left
            dX = diff
        }
        
        if right + dX > CGFloat(cols) {
            let diff = CGFloat(cols) - right
            dX = diff
        }
        
        if top + dY < 0 {
            let diff = top
            dY = diff
        }
        
        if bottom + dY > CGFloat(rows) {
            let diff = CGFloat(rows) - bottom
            dY = diff
        }
        
        left += dX
        right += dX
        top += dY
        bottom += dY
        
        deviceViewport = CGRect(x: left, y: top, width: right - left, height: bottom - top)
        
        drawCallback?.notifyCanvasRedraw()
    }
}
