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
    weak var drawCallback: InteractiveCanvasDrawCallback?
}
