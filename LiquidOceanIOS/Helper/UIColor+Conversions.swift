//
//  UIColor+Conversions.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int32) {
        self.init(
            red: Int((argb >> 16) & 0xFF),
            green: Int((argb >> 8) & 0xFF),
            blue: Int(argb & 0xFF),
            a: Int((argb >> 24) & 0xFF)
        )
    }
    
    func argb() -> Int32 {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int32(fRed * 255.0)
            let iGreen = Int32(fGreen * 255.0)
            let iBlue = Int32(fBlue * 255.0)
            let iAlpha = Int32(fAlpha * 255.0)
            
            let rgb = (iRed << 16) | (iGreen << 8) | (iBlue) | (iAlpha << 24)
            return rgb
        } else {
            // Could not extract RGBA components:
            return 0
        }
    }
}
