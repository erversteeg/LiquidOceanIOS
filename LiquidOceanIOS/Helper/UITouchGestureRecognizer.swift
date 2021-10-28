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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
    }
}
