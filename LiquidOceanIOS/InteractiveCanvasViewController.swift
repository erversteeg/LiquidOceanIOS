//
//  ViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import FlexColorPicker

class InteractiveCanvasViewController: UIViewController, InteractiveCanvasPaintDelegate, ColorPickerDelegate, InteractiveCanvasPixelHistoryDelegate {
    
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
    
    @IBOutlet weak var exportAction: ActionButtonView!
    @IBOutlet weak var changeBackgroundAction: ActionButtonView!
    
    @IBOutlet weak var toolboxButton: ActionButtonView!
    
    @IBOutlet weak var pixelHistoryView: UIView!
    
    var previousColor: Int32!
    
    var pixelHistoryViewController: PixelHistoryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SessionSettings.instance.interactiveCanvas = self.surfaceView.interactiveCanvas
        
        self.surfaceView.interactiveCanvas.paintDelegate = self
        self.surfaceView.interactiveCanvas.pixelHistoryDelegate = self
        
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: self.view.frame.size.height))
        backgroundImage.image = UIImage(named: "wood_texture_light.jpg")
        backgroundImage.contentMode = .scaleToFill
        
        self.backButton.type = .back
        self.backButton.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }
        
        self.paintPanelWidth.constant = 0
        self.colorPickerFrameWidth.constant = 0
        
        self.paintPanel.insertSubview(backgroundImage, at: 0)
        
        toggleToolbox(open: false)
        
        // action buttons
        self.paintPanelButton.type = .paint
        self.closePaintPanelButton.type = .closePaint
        self.exportAction.type = .export
        self.changeBackgroundAction.type = .changeBackground
        self.toolboxButton.type = .clickable
        
        self.toolboxButton.setOnClickListener {
            self.toggleToolbox(open: self.exportAction.isHidden)
        }
        
        self.changeBackgroundAction.setOnClickListener {
            SessionSettings.instance.backgroundColorIndex += 1
            if SessionSettings.instance.backgroundColorIndex == self.surfaceView.interactiveCanvas.numBackgrounds {
                SessionSettings.instance.backgroundColorIndex = 0
            }
            
            SessionSettings.instance.darkIcons = (SessionSettings.instance.backgroundColorIndex == 1 || SessionSettings.instance.backgroundColorIndex == 3)
            
            self.exportAction.setNeedsDisplay()
            self.changeBackgroundAction.setNeedsDisplay()
            self.paintPanelButton.setNeedsDisplay()
            self.backButton.setNeedsDisplay()
            
            SessionSettings.instance.save()
            
            self.surfaceView.interactiveCanvas.drawCallback?.notifyCanvasRedraw()
        }
        
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
        self.paintColorCancel.isHidden = false
        
        self.closePaintPanelButton.isHidden = true
        
        // self.colorHandle.color = UIColor(argb: SessionSettings.instance.paintColor)
        
        self.paintYes.isHidden = true
        self.paintNo.isHidden = true
        
        self.surfaceView.startPaintSelection()
    }
    
    func closeColorPicker() {
        self.colorPickerFrame.isHidden = true
        self.paintColorAccept.isHidden = true
        self.paintColorCancel.isHidden = true
        
        if self.surfaceView.interactiveCanvas.restorePoints.count == 0 {
            self.closePaintPanelButton.isHidden = false
        }
    }
    
    func toggleToolbox(open: Bool) {
        if open {
            self.exportAction.isHidden = false
            self.changeBackgroundAction.isHidden = false
        }
        else {
            self.exportAction.isHidden = true
            self.changeBackgroundAction.isHidden = true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ColorPickerEmbed" {
            let colorPickerViewController = segue.destination as! CustomColorPickerViewController
            colorPickerViewController.delegate = self
            colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.paintColor)
        }
        else if segue.identifier == "PixelHistoryEmbed" {
            segue.destination.modalPresentationStyle = .overCurrentContext
            self.pixelHistoryViewController = segue.destination as! PixelHistoryViewController
        }
    }
    
    // color picker delegate
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        SessionSettings.instance.paintColor = selectedColor.argb()
        self.paintColorIndicator.setNeedsDisplay()
    }
    
    // pixel history delegate
    func notifyShowPixelHistory(data: [AnyObject], screenPoint: CGPoint) {
        
        self.pixelHistoryViewController.data = data
        self.pixelHistoryViewController.collectionView.reloadData()
        
        var x = screenPoint.x + 10
        var y = screenPoint.y - 130
        
        if x < 0 {
            x = 20
        }
        else if x + self.pixelHistoryView.frame.size.width > self.view.frame.size.width {
            x = self.view.frame.size.width - self.pixelHistoryView.frame.size.width - 20
        }
        
        if y < 0 {
            y = 20
        }
        else if y + self.pixelHistoryView.frame.size.height > self.view.frame.size.height {
            y = self.view.frame.size.height - self.pixelHistoryView.frame.size.height - 20
        }
        
        self.pixelHistoryView.frame = CGRect(x: CGFloat(x), y: CGFloat(y),
                                             width: self.pixelHistoryView.frame.size.width,
                                             height: self.pixelHistoryView.frame.size.height)
        
        self.pixelHistoryView.isHidden = false
    }
    
    func notifyHidePixelHistory() {
        self.pixelHistoryView.isHidden = true
    }
}

