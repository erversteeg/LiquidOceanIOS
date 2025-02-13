//
//  InteractiveCanvasSummaryView.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 10/30/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class InteractiveCanvasSummaryView: UIView {
    
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
        drawIneractiveCanvas(ctx: ctx)
    }
    
    @objc func onImageSavedToPhotos(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if (error != nil) {
            print("Error saving to photos!")
        }
    }
    
    func drawIneractiveCanvas(ctx: CGContext) {
        if SessionSettings.instance.backgroundColorIndex == InteractiveCanvas.backgroundBlack {
            ctx.setFillColor(UIColor(hexString: "222222").cgColor)
        }
        else {
            ctx.setFillColor(UIColor.black.cgColor)
        }
        
        ctx.fill(CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        if interactiveCanvas != nil {
            let interactiveCanvas = interactiveCanvas!
            let displayPpu = frame.width / CGFloat(interactiveCanvas.cols)
            
            for pixel in interactiveCanvas.summary {
                var color = UIColor(argb: pixel.color).cgColor
                
                if pixel.color == 0 {
                    if SessionSettings.instance.backgroundColorIndex == InteractiveCanvas.backgroundBlack {
                        color = UIColor(hexString: "222222").cgColor
                    }
                    else {
                        color = UIColor.black.cgColor
                    }
                }
                
                ctx.setFillColor(color)
                
                let x = floor(CGFloat(pixel.x) * displayPpu)
                let y = floor(CGFloat(pixel.y) * displayPpu)
                
                ctx.fill(CGRect(x: x, y: y, width: 1, height: 1))
            }
        }
        
        /*if (art != nil) {
            for pixelPoint in art! {
                let x = round(CGFloat(pixelPoint.x - minX) * ppu + offsetX)
                let y = round(CGFloat(pixelPoint.y - minY) * ppu + offsetY)
                
                ctx.setFillColor(UIColor(argb: pixelPoint.color).cgColor)
                ctx.fill(CGRect(x: x, y: y, width: ppu, height: ppu))
            }
        }*/
    }

}
