//
//  ArtView.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/18/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class ArtView: UIView {

    var _art: [InteractiveCanvas.RestorePoint]?
    var art: [InteractiveCanvas.RestorePoint]? {
        set {
            _art = newValue
            setNeedsDisplay()
        }
        get {
            return _art
        }
    }
    
    var _jsonFile = ""
    var jsonFile: String {
        set {
            _jsonFile = newValue
            
            art = ArtView.artFromJsonFile(named: newValue)
        }
        get {
            return _jsonFile
        }
    }
    
    var showBackground = false
    
    var _actualSize = false
    var actualSize: Bool {
        set {
            _actualSize = newValue
            setNeedsDisplay()
        }
        get {
            return _actualSize
        }
    }
    
    var ppu = CGFloat(10)
    
    let margin = 2
    
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
        drawArt(ctx: ctx, size: self.frame.size, background: showBackground, actualSize: actualSize, export: false)
    }
    
    @objc func onImageSavedToPhotos(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if (error != nil) {
            print("Error saving to photos!")
        }
    }
    
    func drawArt(ctx: CGContext, size: CGSize, background: Bool = false, actualSize: Bool, export: Bool) {
        let gridPpu = CGFloat(10)
        
        if actualSize && export {
            ppu = 1
        }
        else if actualSize {
            ppu = gridPpu
        }
        else {
            adjustPpu(size: size)
        }
        
        let minX = getMinX()
        let minY = getMinY()
        
        var offsetX = (size.width - (CGFloat(artWidth()) * ppu)) / 2
        var offsetY = (size.height - (CGFloat(artHeight()) * ppu)) / 2
        
        if actualSize && !export {
            let offsetGridByX = offsetX.truncatingRemainder(dividingBy: gridPpu)
            let offsetGridByY = offsetY.truncatingRemainder(dividingBy: gridPpu)
            
            offsetX -= offsetGridByX
            offsetY -= offsetGridByY
        }
        
        let widthUnits = Int(size.width / gridPpu) + 1
        let heightUnits = Int(size.height / gridPpu) + 1
        
        let whiteColor = ActionButtonView.whiteColor!
        let grayColor = ActionButtonView.photoshopGrayColor!
        
        if background {
            for x in 0...widthUnits - 1 {
                for y in 0...heightUnits - 1 {
                    if (x + y) % 2 == 0 {
                        ctx.setFillColor(UIColor(argb: whiteColor).cgColor)
                        ctx.fill(CGRect(x: CGFloat(x) * gridPpu, y: CGFloat(y) * gridPpu, width: gridPpu, height: gridPpu))
                    }
                    else {
                        ctx.setFillColor(UIColor(argb: grayColor).cgColor)
                        ctx.fill(CGRect(x: CGFloat(x) * gridPpu, y: CGFloat(y) * gridPpu, width: gridPpu, height: gridPpu))
                    }
                }
            }
        }
        
        if (art != nil) {
            for pixelPoint in art! {
                let x = round(CGFloat(pixelPoint.x - minX) * ppu + offsetX)
                let y = round(CGFloat(pixelPoint.y - minY) * ppu + offsetY)
                
                ctx.setFillColor(UIColor(argb: pixelPoint.color).cgColor)
                ctx.fill(CGRect(x: x, y: y, width: ppu, height: ppu))
            }
        }
    }
    
    func getMinX() -> Int {
        var min = -1
        if art != nil {
            for pixelPoint in art! {
                if pixelPoint.x < min || min == -1 {
                    min = pixelPoint.x
                }
            }
        }
        
        return min
    }
    
    func getMaxX() -> Int {
        var max = -1
        if art != nil {
            for pixelPoint in art! {
                if pixelPoint.x > max || max == -1 {
                    max = pixelPoint.x
                }
            }
        }
        
        return max
    }
    
    func getMinY() -> Int {
        var min = -1
        if art != nil {
            for pixelPoint in art! {
                if pixelPoint.y < min || min == -1 {
                    min = pixelPoint.y
                }
            }
        }
        
        return min
    }
    
    func getMaxY() -> Int {
        var max = -1
        if art != nil {
            for pixelPoint in art! {
                if pixelPoint.y > max || max == -1 {
                    max = pixelPoint.y
                }
            }
        }
        
        return max
    }
    
    func artWidth() -> Int {
        return getMaxX() - getMinX() + 1
    }
    
    func artHeight() -> Int {
        return getMaxY() - getMinY() + 1
    }
    
    func adjustPpu(size: CGSize) {
        let artW = artWidth()
        let artH = artHeight()
        
        let fillWidthPpu = size.width / CGFloat(artW)
        let fillHeightPpu = size.height / CGFloat(artH)
        
        ppu = fmin(fillWidthPpu, fillHeightPpu)
        
        ppu *= 0.8
        
        ppu = round(ppu)
    }
    
    func saveArtToPhotos() {
        let image = getArtImage()
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(onImageSavedToPhotos), nil)
    }
    
    func getArtImage() -> UIImage {
        let saveWidth = 1375
        let saveHeight = 825
        
        var rect = CGRect(x: 0, y: 0, width: saveWidth, height: saveHeight)
        
        if actualSize {
            rect = CGRect(x: 0, y: 0, width: artWidth(), height: artHeight())
        }
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        // Create a context of the starting image size and set it as the current one
        UIGraphicsBeginImageContext(image.size)
        
        // Draw the starting image in the current context as background
        image.draw(at: CGPoint.zero)

        // Get the current context
        let context = UIGraphicsGetCurrentContext()!

        self.drawArt(ctx: context, size: rect.size, background: false, actualSize: self.actualSize, export: true)
        
        // Save the context as a new UIImage
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Change to png format
        let pngData = image.pngData()!
        image = UIImage(data: pngData)!
        
        // Return modified image
        return image
    }
    
    static func artFromJsonFile(named: String) -> [InteractiveCanvas.RestorePoint]? {
        let path = Bundle.main.path(forResource: named, ofType: "json")!
        
        var contents = "{}"
        
        do {
            contents = try String(contentsOfFile: path, encoding: .utf8)
            
            let jsonObj = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!, options: []) as! [String: AnyObject]
            
            let artJsonArray = jsonObj["pixels"] as! [[String: AnyObject]]
            
            var art = [InteractiveCanvas.RestorePoint]()
            
            for j in artJsonArray.indices {
                let jsonObj = artJsonArray[j]
                
                art.append(InteractiveCanvas.RestorePoint(x: Int(jsonObj["x"] as! Int), y: Int(jsonObj["y"] as! Int), color: jsonObj["color"] as! Int32, newColor: jsonObj["color"] as! Int32))
            }
            
            return art
        }
        
        catch {
            
        }
        
        return nil
    }
}
