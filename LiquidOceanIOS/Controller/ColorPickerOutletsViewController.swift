//
//  ColorPickerOutletsViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 3/12/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import FlexColorPicker

class ColorPickerOutletsViewController: CustomColorPickerViewController {

    @IBOutlet weak var hsbWheelXCenter: NSLayoutConstraint!
    @IBOutlet weak var hsbWheelYCenter: NSLayoutConstraint!
    
    @IBOutlet weak var hsbWheelWidth: NSLayoutConstraint!
    @IBOutlet weak var hsbWheelHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        if view.frame.size.height > 600 {
            hsbWheelYCenter.constant = 0
        }
    }
}
