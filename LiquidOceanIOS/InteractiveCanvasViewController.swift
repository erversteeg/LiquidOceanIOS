//
//  ViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class InteractiveCanvasViewController: UIViewController, InteractiveCanvasPaintDelegate {
    
    @IBOutlet var surfaceView: InteractiveCanvasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SessionSettings.instance.interactiveCanvas = self.surfaceView.interactiveCanvas
        
        self.surfaceView.interactiveCanvas.paintDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.surfaceView.backgroundColor = UIColor.red
    }
    
    // paint delegate
    
    func notifyPaintingStarted() {
        
    }
    
    func notifyPaintingEnded() {
        
    }
}

