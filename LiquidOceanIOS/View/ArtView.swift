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
    
    var showBackground = false
    
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
        drawArt(ctx: ctx, size: self.frame.size, background: true)
    }
    
    @objc func onImageSavedToPhotos(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if (error != nil) {
            print("Error saving to photos!")
        }
    }
    
    func drawArt(ctx: CGContext, size: CGSize, background: Bool = false) {
        adjustPpu(size: size)
        
        let minX = getMinX()
        let minY = getMinY()
        
        let offsetX = (size.width - (CGFloat(artWidth()) * ppu)) / 2
        let offsetY = (size.height - (CGFloat(artHeight()) * ppu)) / 2
        
        let gridPpu = CGFloat(10)
        
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
        
        let rect = CGRect(x: 0, y: 0, width: saveWidth, height: saveHeight)
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

        self.drawArt(ctx: context, size: rect.size, background: false)
        
        // Save the context as a new UIImage
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Change to png format
        let pngData = image.pngData()!
        image = UIImage(data: pngData)!
        
        // Return modified image
        return image
    }
}
