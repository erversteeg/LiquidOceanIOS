//
//  InteractiveCanvas.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import SocketIO

protocol InteractiveCanvasDrawCallback: AnyObject {
    func notifyCanvasRedraw()
}

protocol InteractiveCanvasScaleCallback: AnyObject {
    func notifyScaleCancelled()
}

protocol InteractiveCanvasPaintDelegate: AnyObject {
    func notifyPaintingStarted()
    func notifyPaintingEnded()
    func notifyPaintColorUpdate()
}

protocol InteractiveCanvasPixelHistoryDelegate: AnyObject {
    func notifyShowPixelHistory(data: [AnyObject], screenPoint: CGPoint)
    func notifyHidePixelHistory()
}

class InteractiveCanvas: NSObject, URLSessionDelegate {
    var rows = 512
    var cols = 512
    
    var arr = [[Int32]]()
    
    var basePpu = 100
    var ppu: Int!
    
    var gridLineThreshold = 50
    
    var deviceViewport: CGRect!
    
    weak var drawCallback: InteractiveCanvasDrawCallback?
    weak var scaleCallback: InteractiveCanvasScaleCallback?
    weak var paintDelegate: InteractiveCanvasPaintDelegate?
    weak var pixelHistoryDelegate: InteractiveCanvasPixelHistoryDelegate?
    
    var startScaleFactor = CGFloat(0.2)
    
    let minScaleFactor = CGFloat(0.07)
    let maxScaleFactor = CGFloat(7)
    
    let backgroundBlack = 0
    let backgroundWhite = 1
    let backgroundGrayThirds = 2
    let backgroundPhotoshop = 3
    let backgroundClassic = 4
    let backgroundChess = 5
    
    let numBackgrounds = 6
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    var restorePoints =  [RestorePoint]()
    
    class RestorePoint {
        var x: Int
        var y: Int
        var color: Int32
        var newColor: Int32
        
        init(x: Int, y: Int, color: Int32, newColor: Int32) {
            self.x = x
            self.y = y
            self.color = color
            self.newColor = newColor
        }
    }
    
    override init() {
        super.init()
        
        ppu = basePpu
        
        let dataJsonStr = SessionSettings.instance.userDefaults().object(forKey: "arr") as? String
        
        if dataJsonStr == nil {
            loadDefault()
        }
        else {
            initPixels(arrJsonStr: dataJsonStr!)
        }
        
        // socket init
        manager = SocketManager(socketURL: URL(string: "https://192.168.200.69:5010")!, config: [.log(true), .compress, .selfSigned(true), .sessionDelegate(self)])
        
        socket = manager.defaultSocket
        
        socket.connect()
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print(data)
        }
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print(data)
        }
        
        socket.on(clientEvent: .error) { (data, ack) in
            print(data)
        }
        
        registerForSocketEvents(socket: socket)
    }
    
    func registerForSocketEvents(socket: SocketIOClient) {
        socket.on("pixels_commit") { (data, ack) in
            let pixelsJsonArr = data[0] as! [[String: Any]]
            
            for pixelObj in pixelsJsonArr {
                let unit1DIndex = (pixelObj["id"] as! Int) - 1
                
                let y = unit1DIndex / self.cols
                let x = unit1DIndex % self.cols
                
                self.arr[y][x] = pixelObj["color"] as! Int32
            }
            
            self.drawCallback?.notifyCanvasRedraw()
        }
    }
    
    func initPixels(arrJsonStr: String) {
        do {
            if let outerArray = try JSONSerialization.jsonObject(with: arrJsonStr.data(using: .utf8)!, options: []) as? [Any] {
                
                for i in 0...outerArray.count - 1 {
                    let innerArr = outerArray[i] as! [Int32]
                    var arrRow = [Int32]()
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
            var innerArr = [Int32]()
            for j in 0...cols - 1 {
                if (i + j) % 2 == 0 {
                    innerArr.append(Utils.int32FromColorHex(hex: "0xFF333333"))
                }
                else {
                    innerArr.append(Utils.int32FromColorHex(hex: "0xFF666666"))
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
    
    func paintUnitOrUndo(x: Int, y: Int, mode: Int = 0) {
        let restorePoint = unitInRestorePoints(x: x, y: y)
        
        if mode == 0 {
            if restorePoint == nil && SessionSettings.instance.dropsAmt > 0 {
                // paint
                restorePoints.append(RestorePoint(x: x, y: y, color: arr[y][x], newColor: SessionSettings.instance.paintColor!))
                
                arr[y][x] = SessionSettings.instance.paintColor
                
                SessionSettings.instance.dropsAmt -= 1
            }
        }
        else if mode == 1 {
            if restorePoint != nil {
                let index = restorePoints.firstIndex{$0 === restorePoint}
                
                if index != nil {
                    restorePoints.remove(at: index!)
                    arr[y][x] = restorePoint!.color
                    
                    SessionSettings.instance.dropsAmt += 1
                }
            }
        }
        
        drawCallback?.notifyCanvasRedraw()
    }
    
    func commitPixels() {
        print(SessionSettings.instance.paintColor)
        
        var pixelInfoArr = [[String: Int32]]()
        
        for restorePoint in self.restorePoints {
            var map = [String: Int32]()
            map["id"] = Int32((restorePoint.y * cols + restorePoint.x) + 1)
            map["color"] = restorePoint.newColor
            
            pixelInfoArr.append(map)
        }
        
        var reqObj = [String: Any]()
        
        reqObj["uuid"] = SessionSettings.instance.uniqueId
        reqObj["pixels"] = pixelInfoArr
        
        print(reqObj)
        
        socket.emit("pixels_event", reqObj)
    }
    
    func getGridLineColor() -> Int32 {
        let white = Utils.int32FromColorHex(hex: "0xFFFFFFFF")
        let black = Utils.int32FromColorHex(hex: "0xFF000000")
        switch SessionSettings.instance.backgroundColorIndex {
            case backgroundWhite:
                return black
            case backgroundPhotoshop:
                return black
            default:
                return white
        }
    }
    
    func getBackgroundColors(index: Int) -> (primary: Int32, secondary: Int32)? {
        switch index {
            case backgroundBlack:
                return (Utils.int32FromColorHex(hex: "0xFF000000"), Utils.int32FromColorHex(hex: "0xFF000000"))
            case backgroundWhite:
                return (Utils.int32FromColorHex(hex: "0xFFFFFFFF"), Utils.int32FromColorHex(hex: "0xFFFFFFFF"))
            case backgroundGrayThirds:
                return (Utils.int32FromColorHex(hex: "0xFFAAAAAA"), Utils.int32FromColorHex(hex: "0xFF555555"))
            case backgroundPhotoshop:
                return (Utils.int32FromColorHex(hex: "0xFFFFFFFF"), Utils.int32FromColorHex(hex: "0xFFCCCCCC"))
            case backgroundClassic:
                return (Utils.int32FromColorHex(hex: "0xFF666666"), Utils.int32FromColorHex(hex: "0xFF333333"))
            case backgroundChess:
                return (Utils.int32FromColorHex(hex: "0xFFB59870"), Utils.int32FromColorHex(hex: "0xFF000000"))
            default:
                return nil
        }
    }
    
    func getPixelHistoryForUnitPoint(unitPoint: CGPoint, completionHandler: @escaping (Bool, [AnyObject]) -> Void) {
        let x = Int(unitPoint.x)
        let y = Int(unitPoint.y)
        
        let pixelId = y * cols + x + 1
        URLSessionHandler.instance.downloadPixelHistory(pixelId: pixelId, completionHandler: completionHandler)
    }
    
    // restore points
    
    func undoPendingPaint() {
        for restorePoint: RestorePoint in restorePoints {
            arr[restorePoint.y][restorePoint.x] = restorePoint.color
        }
    }
    
    func clearRestorePoints() {
        self.restorePoints = [RestorePoint]()
    }
    
    func unitInRestorePoints(x: Int, y: Int) -> RestorePoint? {
        for restorePoint in self.restorePoints {
            if restorePoint.x == x && restorePoint.y == y {
                return restorePoint
            }
        }
        
        return nil
    }
    
    func updateDeviceViewport(screenSize: CGSize, fromScale: Bool = false) {
        updateDeviceViewport(screenSize: screenSize, canvasCenterX: deviceViewport.origin.x + deviceViewport.size.width / 2, canvasCenterY: deviceViewport.origin.y + deviceViewport.size.height / 2)
    }
    
    func updateDeviceViewport(screenSize: CGSize, canvasCenterX: CGFloat, canvasCenterY: CGFloat, fromScale: Bool = false) {
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let canvasCenterXPx = Int((canvasCenterX * CGFloat(ppu)))
        let canvasCenterYPx = Int((canvasCenterY * CGFloat(ppu)))
        
        let canvasTop = canvasCenterYPx - Int(screenHeight) / 2
        let canvasBottom = canvasCenterYPx + Int(screenHeight) / 2
        let canvasLeft = canvasCenterXPx - Int(screenWidth) / 2
        let canvasRight = canvasCenterXPx + Int(screenWidth) / 2
        
        let top = CGFloat(canvasTop) / CGFloat(ppu)
        let bottom = CGFloat(canvasBottom) / CGFloat(ppu)
        let left = CGFloat(canvasLeft) / CGFloat(ppu)
        let right = CGFloat(canvasRight) / CGFloat(ppu)
        
        if (top < 0.0 || bottom > CGFloat(rows) || CGFloat(left) > 0.0 || right > CGFloat(cols)) {
            if (fromScale) {
                
            }
        }
        
        deviceViewport = CGRect(x: left, y: top, width: (right - left), height: (bottom - top))
    }
    
    func getScreenSpaceForUnit(x: Int, y: Int) -> CGRect {
        let offsetX = (CGFloat(x) - deviceViewport.origin.x) * CGFloat(ppu)
        let offsetY = (CGFloat(y) - deviceViewport.origin.y) * CGFloat(ppu)
        
        return CGRect(x: max(offsetX, 0.0), y: max(offsetY, 0.0), width: offsetX + CGFloat(ppu), height: offsetY + CGFloat(ppu))
    }
    
    func unitForScreenPoint(x: CGFloat, y: CGFloat) -> CGPoint {
        let topViewportPx = deviceViewport.origin.y * CGFloat(ppu)
        let leftViewportPx = deviceViewport.origin.x * CGFloat(ppu)
        
        let absXPx = leftViewportPx + x
        let absYPx = topViewportPx + y
        
        let absX = absXPx / CGFloat(ppu)
        let absY = absYPx / CGFloat(ppu)
        
        return CGPoint(x: floor(absX), y: floor(absY))
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
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
