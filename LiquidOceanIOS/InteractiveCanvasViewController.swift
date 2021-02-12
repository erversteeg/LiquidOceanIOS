//
//  ViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import ChromaColorPicker

class InteractiveCanvasViewController: UIViewController, InteractiveCanvasPaintDelegate {
    
    @IBOutlet var surfaceView: InteractiveCanvasView!
    
    @IBOutlet var paintPanel: UIView!
    
    @IBOutlet weak var paintPanelButton: ActionButtonView!
    @IBOutlet weak var closePaintPanelButton: ActionButtonView!
    
    @IBOutlet weak var colorPickerFrame: UIView!
    
    @IBOutlet weak var paintColorIndicator: PaintColorIndicator!
    
    
    @IBOutlet weak var paintPanelWidth: NSLayoutConstraint!
    @IBOutlet weak var colorPickerFrameWidth: NSLayoutConstraint!
    
    @IBOutlet weak var paintColorAccept: ActionButtonView!
    @IBOutlet weak var paintColorCancel: ActionButtonView!
    
    @IBOutlet weak var paintYes: ActionButtonView!
    @IBOutlet weak var paintNo: ActionButtonView!
    
    @IBOutlet weak var paintQuantityBar: PaintQuantityBar!
    
    @IBOutlet weak var backButton: ActionButtonView!
    
    var previousColor: Int32!
    
    var colorHandle: ChromaColorHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SessionSettings.instance.interactiveCanvas = self.surfaceView.interactiveCanvas
        
        self.surfaceView.interactiveCanvas.paintDelegate = self
        
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: self.view.frame.size.height))
        backgroundImage.image = UIImage(named: "wood_texture_light.jpg")
        backgroundImage.contentMode = .scaleToFill
        
        self.backButton.type = .back
        self.backButton.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }
        
        self.paintPanelWidth.constant = 0
        
        self.paintPanel.insertSubview(backgroundImage, at: 0)
        
        self.paintPanelButton.type = .paint
        self.closePaintPanelButton.type = .closePaint
        
        self.paintPanel.isHidden = true
        self.paintPanelButton.setOnClickListener {
            self.paintPanelWidth.constant = 200
            self.paintPanel.isHidden = false
            
            self.surfaceView.startPainting()
        }
        
        self.closePaintPanelButton.setOnClickListener {
            self.surfaceView.endPainting(accept: false)
            
            self.paintPanelWidth.constant = 0
            self.paintPanel.isHidden = true
        }
        
        // paint quantity bar
        SessionSettings.instance.paintQtyDelegates.append(self.paintQuantityBar)
        
        let paintIndicatorTap = UITapGestureRecognizer(target: self, action: #selector(didTapColorIndicator(sender:)))
        self.paintColorIndicator.addGestureRecognizer(paintIndicatorTap)
        
        setupColorPicker()
        
        self.paintColorAccept.type = .paintSelectYes
        self.paintColorCancel.type = .paintSelectCancel
        
        self.paintColorAccept.isHidden = true
        self.paintColorCancel.isHidden = true
        
        // paint selection accept
        self.paintColorAccept.setOnClickListener {
            self.closeColorPicker()
            
            self.paintYes.isHidden = false
            self.paintNo.isHidden = false
            
            self.closePaintPanelButton.isHidden = true
            
            self.surfaceView.endPaintSelection()
        }
        
        // paint selection cancel
        self.paintColorCancel.setOnClickListener {
            self.paintColorIndicator.setPaintColor(color: self.previousColor)
            
            self.closeColorPicker()
            
            self.surfaceView.endPaintSelection()
        }
        
        self.paintYes.type = .yes
        self.paintNo.type = .no
        
        self.paintYes.isHidden = true
        self.paintNo.isHidden = true
        
        
        self.paintYes.setOnClickListener {
            self.surfaceView.endPainting(accept: true)
            
            self.paintYes.isHidden = true
            self.paintNo.isHidden = true
            self.closePaintPanelButton.isHidden = false
            
            self.paintPanelWidth.constant = 0
            self.paintPanel.isHidden = true
        }
        
        self.paintNo.setOnClickListener {
            self.surfaceView.endPainting(accept: false)
            
            self.paintYes.isHidden = true
            self.paintNo.isHidden = true
            self.closePaintPanelButton.isHidden = false
            
            self.surfaceView.startPainting()
        }
    }
    
    // paint color indicator
    @objc func didTapColorIndicator(sender: UITapGestureRecognizer) {
        self.previousColor = SessionSettings.instance.paintColor
        
        self.colorPickerFrameWidth.constant = 370
        self.colorPickerFrame.isHidden = false
        
        self.paintColorAccept.isHidden = false
        // self.paintColorCancel.isHidden = false
        
        self.closePaintPanelButton.isHidden = true
        
        self.colorHandle.color = UIColor(argb: SessionSettings.instance.paintColor)
        
        self.paintYes.isHidden = true
        self.paintNo.isHidden = true
        
        self.surfaceView.startPaintSelection()
    }
    
    @objc func colorPickerValueChange(_ picker: ChromaColorPicker) {
        self.paintColorIndicator.setPaintColor(color: picker.currentHandle!.color.argb()!)
    }
    
    @objc func sliderDidValueChange(_ slider: ChromaBrightnessSlider) {
        self.paintColorIndicator.setPaintColor(color: slider.currentColor.argb()!)
    }
    
    func setupColorPicker() {
        self.colorPickerFrameWidth.constant = 0
        
        self.colorPickerFrame.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xDD111111"))
        
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 50, y: 30, width: 300, height: 300))
        self.colorPickerFrame.addSubview(colorPicker)
        
        colorPicker.borderColor = UIColor.clear

        let brightnessSlider = ChromaBrightnessSlider(frame: CGRect(x: 60, y: 340, width: 280, height: 32))
        self.colorPickerFrame.addSubview(brightnessSlider)

        colorPicker.connect(brightnessSlider)
        
        let handle = ChromaColorHandle()
        handle.color = UIColor(argb: SessionSettings.instance.paintColor)
        colorPicker.addHandle(handle)
        
        self.colorHandle = handle
        
        brightnessSlider.addTarget(self, action: #selector(sliderDidValueChange(_:)), for: .valueChanged)
        colorPicker.addTarget(self, action: #selector(colorPickerValueChange(_:)), for: .valueChanged)
        
        self.colorPickerFrame.isHidden = true
    }
    
    func closeColorPicker() {
        self.colorPickerFrame.isHidden = true
        self.paintColorAccept.isHidden = true
        self.paintColorCancel.isHidden = true
        
        if self.surfaceView.interactiveCanvas.restorePoints.count == 0 {
            self.closePaintPanelButton.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.surfaceView.backgroundColor = UIColor.red
    }
    
    // paint delegate
    
    func notifyPaintingStarted() {
        self.closePaintPanelButton.isHidden = true
        self.paintYes.isHidden = false
        self.paintNo.isHidden = false
    }
    
    func notifyPaintingEnded() {
        self.closePaintPanelButton.isHidden = false
        self.paintYes.isHidden = true
        self.paintNo.isHidden = true
    }
    
    func notifyPaintColorUpdate() {
        self.paintColorIndicator.setPaintColor(color: SessionSettings.instance.paintColor)
    }
}

