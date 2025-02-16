//
//  ErrorPixel.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/16/25.
//  Copyright © 2025 Eric Versteeg. All rights reserved.
//

import Foundation
import UIKit

class ErrorPixel: NSObject {
    
    var isActive = true
    private var startTime = NSDate().timeIntervalSince1970
    var x: Int
    var y: Int
    private var duration: TimeInterval
    
    init(x: Int, y: Int, duration: TimeInterval) {
        self.x = x
        self.y = y
        self.duration = duration
        
        super.init()
    }
    
    func getColor() -> CGColor {
        let percent = (NSDate().timeIntervalSince1970 - self.startTime) / self.duration
        if percent >= 1.0 {
            self.isActive = false
            return UIColor(red: 0, green: 0, blue: 0, a: 0).cgColor
        }
        
        let opacity = Int((1.0 - percent) * 255)
        return UIColor(red: 255, green: 0, blue: 0, a: opacity).cgColor
    }
}
