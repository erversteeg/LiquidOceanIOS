//
//  UITouchGestureRecognizer.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 10/28/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class UITouchGestureRecognizer: UIGestureRecognizer {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .changed
        
        let bounds = view!.bounds
        
        for touch in touches {
            let loc = touch.location(in: view)
            
            if loc.x < bounds.origin.x || loc.y < bounds.origin.y || loc.x > bounds.width || loc.y > bounds.height {
                self.state = .cancelled
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
    }
}
