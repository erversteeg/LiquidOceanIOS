//
//  OptionsViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/23/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import FlexColorPicker

class OptionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, ColorPickerDelegate {
    
    @IBOutlet weak var colorPickerContainerView: UIView!
    @IBOutlet weak var colorPickerDoneButton: UIButton!
    @IBOutlet weak var colorPickerCancelButton: UIButton!

    @IBOutlet weak var panelTextureTitle: UILabel!
    @IBOutlet weak var panelsCollectionView: UICollectionView!
    
    @IBOutlet weak var optionsTitleAction: ActionButtonView!
    @IBOutlet weak var backAction: ActionButtonView!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var pincodeButton: UIButton!
    
    @IBOutlet weak var showPaintBarContainer: UIView!
    @IBOutlet weak var showPaintBarSwitch: UISwitch!
    
    @IBOutlet weak var showPaintCircleContainer: UIView!
    @IBOutlet weak var showPaintCircleSwitch: UISwitch!
    
    @IBOutlet weak var paintMeterColorContainer: UIView!
    @IBOutlet weak var paintMeterColorColorView: UIView!
    @IBOutlet weak var paintMeterColorResetButton: UIButton!
    
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var changeNameTextField: UITextField!
    
    @IBOutlet weak var canvasLockBorderContainer: UIView!
    @IBOutlet weak var canvasLockBorderSwitch: UISwitch!
   
    @IBOutlet weak var canvasLockColorContainer: UIView!
    @IBOutlet weak var canvasLockColorColorView: UIView!
    @IBOutlet weak var canvasLockColorResetButton: UIButton!
    
    @IBOutlet weak var gridLineColorContainer: UIView!
    @IBOutlet weak var gridLineColorColorView: UIView!
    @IBOutlet weak var gridLineColorResetButton: UIButton!
    
    @IBOutlet weak var circlePaletteContainer: UIView!
    @IBOutlet weak var circlePaletteSwitch: UISwitch!
    
    @IBOutlet weak var squarePaletteContainer: UIView!
    @IBOutlet weak var squarePaletteSwitch: UISwitch!
    
    @IBOutlet weak var paletteOutlineContainer: UIView!
    @IBOutlet weak var paletteOutlineSwitch: UISwitch!
    
    @IBOutlet weak var paletteSizeContainer: UIView!
    @IBOutlet weak var paletteSizeLabel: UILabel!
    @IBOutlet weak var paletteSizeMinusAction: ActionButtonView!
    @IBOutlet weak var paletteSizeMinusFrame: ActionButtonFrame!
    @IBOutlet weak var paletteSizePlusAction: ActionButtonView!
    @IBOutlet weak var paletteSizePlusFrame: ActionButtonFrame!
    
    @IBOutlet weak var promptBackContainer: UIView!
    @IBOutlet weak var promptBackSwitch: UISwitch!
    
    @IBOutlet weak var recentColorsContainer: UIView!
    @IBOutlet weak var recentColorsAmtLabel1: UILabel!
    @IBOutlet weak var recentColorsAmtLabel2: UILabel!
    @IBOutlet weak var recentColorsAmtLabel3: UILabel!
    @IBOutlet weak var recentColorsAmtLabel4: UILabel!
    @IBOutlet weak var recentColorsAmtLabel5: UILabel!
    @IBOutlet weak var recentColorsAmtLabel6: UILabel!
    @IBOutlet weak var recentColorsAmtLabel7: UILabel!
    @IBOutlet weak var recentColorsAmtLabel8: UILabel!
    
    @IBOutlet weak var rightHandedContainer: UIView!
    @IBOutlet weak var rightHandedSwitch: UISwitch!
    
    @IBOutlet weak var smallActionButtonsContainer: UIView!
    @IBOutlet weak var smallActionButtonsSwitch: UISwitch!
    
    @IBOutlet weak var creditsScrollView: UIScrollView!
    
    @IBOutlet weak var backActionLeading: NSLayoutConstraint!
    
    weak var colorPickerViewController: CustomColorPickerViewController!
    
    var showSignIn = "ShowSignIn"
    var showPincode = "ShowPincode"
    
    var images = [UIImage]()
    
    var alertTextField: UITextField!
    
    var checkedName: String!
    
    var panels = PanelThemeConfig.panels
    
    var selectingPaintMeterColor = false
    var selectingGridLineColor = false
    var selectingCanvasLockColor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()

        optionsTitleAction.selectable = false
        optionsTitleAction.type = .options
        
        backAction.type = .backSolid
        
        backAction.setOnClickListener {
            if (!self.creditsScrollView.isHidden) {
                self.creditsScrollView.isHidden = true
            }
            else {
                self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
            }
        }
        
        if SessionSettings.instance.googleAuth {
            signInButton.isEnabled = false
        }
        
        for panel in panels {
            images.append(UIImage(named: panel)!)
        }
        
        var tgr = UITapGestureRecognizer(target: self, action: #selector(tappedTextureTitle))
        panelTextureTitle.addGestureRecognizer(tgr)
        
        checkedName = SessionSettings.instance.displayName
        changeNameTextField.text = SessionSettings.instance.displayName
        
        // show paint bar
        showPaintBarContainer.layer.borderColor = UIColor.white.cgColor
        showPaintBarContainer.layer.borderWidth = 2
        showPaintBarSwitch.isOn = SessionSettings.instance.showPaintBar
        
        // show paint circle
        showPaintCircleContainer.layer.borderColor = UIColor.white.cgColor
        showPaintCircleContainer.layer.borderWidth = 2
        showPaintCircleSwitch.isOn = SessionSettings.instance.showPaintCircle
        
        // paint meter color
        paintMeterColorContainer.layer.borderColor = UIColor.white.cgColor
        paintMeterColorContainer.layer.borderWidth = 2
        
        paintMeterColorColorView.backgroundColor = UIColor(argb: SessionSettings.instance.paintIndicatorColor)
        
        tgr = UITapGestureRecognizer(target: self, action: #selector(tappedPaintMeterColorView(sender:)))
        paintMeterColorColorView.addGestureRecognizer(tgr)
        
        // canvas lock border
        canvasLockBorderContainer.layer.borderColor = UIColor.white.cgColor
        canvasLockBorderContainer.layer.borderWidth = 2
        canvasLockBorderSwitch.isOn = SessionSettings.instance.canvasLockBorder
        
        // canvas lock color
        canvasLockColorContainer.layer.borderColor = UIColor.white.cgColor
        canvasLockColorContainer.layer.borderWidth = 2
        canvasLockColorColorView.backgroundColor = UIColor(argb: SessionSettings.instance.canvasLockColor)
        
        // grid line color
        gridLineColorContainer.layer.borderColor = UIColor.white.cgColor
        gridLineColorContainer.layer.borderWidth = 2
        
        tgr = UITapGestureRecognizer(target: self, action: #selector(tappedGridLineColorView(sender:)))
        gridLineColorColorView.addGestureRecognizer(tgr)
        
        tgr = UITapGestureRecognizer(target: self, action: #selector(tappedCanvasLockColorView(sender:)))
        canvasLockColorColorView.addGestureRecognizer(tgr)
        
        if SessionSettings.instance.gridLineColor != 0 {
            gridLineColorColorView.backgroundColor = UIColor(argb: SessionSettings.instance.gridLineColor)
        }
        
        // circle palette
        circlePaletteContainer.layer.borderColor = UIColor.white.cgColor
        circlePaletteContainer.layer.borderWidth = 2
        circlePaletteSwitch.isOn = SessionSettings.instance.paintIndicatorFill
        
        // square palette
        squarePaletteContainer.layer.borderColor = UIColor.white.cgColor
        squarePaletteContainer.layer.borderWidth = 2
        squarePaletteSwitch.isOn = SessionSettings.instance.paintIndicatorSquare
        
        // palette outline
        paletteOutlineContainer.layer.borderColor = UIColor.white.cgColor
        paletteOutlineContainer.layer.borderWidth = 2
        paletteOutlineSwitch.isOn = SessionSettings.instance.paintIndicatorOutline
        
        // palette size
        paletteSizeContainer.layer.borderColor = UIColor.white.cgColor
        paletteSizeContainer.layer.borderWidth = 2
        paletteSizeLabel.text = String(SessionSettings.instance.paintIndicatorWidth)
        
        paletteSizeMinusFrame.actionButtonView = paletteSizeMinusAction
        paletteSizePlusFrame.actionButtonView = paletteSizePlusAction
        
        paletteSizeMinusAction.type = .dot
        paletteSizePlusAction.type = .dot
        
        // prompt back
        promptBackContainer.layer.borderColor = UIColor.white.cgColor
        promptBackContainer.layer.borderWidth = 2
        promptBackSwitch.isOn = SessionSettings.instance.promptBack
        
        // recent colors
        recentColorsContainer.layer.borderColor = UIColor.white.cgColor
        recentColorsContainer.layer.borderWidth = 2
    
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
        
        self.recentColorsAmtLabel1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRecentColorLabel1(sender:))))
        self.recentColorsAmtLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRecentColorLabel2(sender:))))
        self.recentColorsAmtLabel3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRecentColorLabel3(sender:))))
        self.recentColorsAmtLabel4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRecentColorLabel4(sender:))))
        self.recentColorsAmtLabel5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRecentColorLabel5(sender:))))
        self.recentColorsAmtLabel6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRecentColorLabel6(sender:))))
        self.recentColorsAmtLabel7.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRecentColorLabel7(sender:))))
        self.recentColorsAmtLabel8.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedRecentColorLabel8(sender:))))
        
        paletteSizeMinusFrame.setOnClickListener {
            var value = Int(self.paletteSizeLabel.text!)! - 1
            if value == 0 { value = 1 }
            
            self.paletteSizeLabel.text = String(value)
            SessionSettings.instance.paintIndicatorWidth = value
        }
        
        paletteSizePlusFrame.setOnClickListener {
            var value = Int(self.paletteSizeLabel.text!)! + 1
            if value == 6 { value = 5 }
            
            self.paletteSizeLabel.text = String(value)
            SessionSettings.instance.paintIndicatorWidth = value
        }
        
        // right-handed
        rightHandedContainer.layer.borderColor = UIColor.white.cgColor
        rightHandedContainer.layer.borderWidth = 2
        rightHandedSwitch.isOn = SessionSettings.instance.rightHanded
        
        // small action buttons
        smallActionButtonsContainer.layer.borderColor = UIColor.white.cgColor
        smallActionButtonsContainer.layer.borderWidth = 2
        smallActionButtonsSwitch.isOn = SessionSettings.instance.smallActionButtons
        
        if SessionSettings.instance.pincodeSet {
            signInButton.isEnabled = false
            pincodeButton.setTitle("Change Access Pincode", for: .normal)
        }
        else {
            pincodeButton.setTitle("Set Access Pincode", for: .normal)
        }
        
        // before animation
        if view.frame.size.height <= 600 {
            optionsTitleAction.isHidden = true
            
            panelTextureTitle.isHidden = true
            panelsCollectionView.isHidden = true
            rightHandedContainer.isHidden = true
            canvasLockBorderContainer.isHidden = true
            canvasLockColorContainer.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        let backX = self.backAction.frame.origin.x
        if backX < 0 {
            backActionLeading.constant += 30
        }
        
        if SessionSettings.instance.panelBackgroundName != "" {
            panelsCollectionView.scrollToItem(at: IndexPath(item: panels.firstIndex(of: SessionSettings.instance.panelBackgroundName)!, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if view.frame.size.height <= 600 {
            Animator.animateTitleFromTop(titleView: optionsTitleAction)
            
            Animator.animateHorizontalViewEnter(view: panelTextureTitle, left: false)
            Animator.animateHorizontalViewEnter(view: panelsCollectionView, left: true)
            Animator.animateHorizontalViewEnter(view: rightHandedContainer, left: false)
            Animator.animateHorizontalViewEnter(view: canvasLockBorderContainer, left: true)
            Animator.animateHorizontalViewEnter(view: canvasLockColorContainer, left: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if SessionSettings.instance.changedGoogleAuth {
            URLSessionHandler.instance.getDeviceInfo { (success) -> (Void) in
                if success {
                    self.changeNameTextField.text = SessionSettings.instance.displayName
                }
            }
        }
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender == circlePaletteSwitch {
            SessionSettings.instance.paintIndicatorFill = sender.isOn
            if sender.isOn && squarePaletteSwitch.isOn {
                squarePaletteSwitch.setOn(false, animated: true)
                SessionSettings.instance.paintIndicatorSquare = false
            }
        }
        else if sender == squarePaletteSwitch {
            SessionSettings.instance.paintIndicatorSquare = sender.isOn
            if sender.isOn && circlePaletteSwitch.isOn {
                circlePaletteSwitch.setOn(false, animated: true)
                SessionSettings.instance.paintIndicatorFill = false
            }
        }
        else if sender == paletteOutlineSwitch {
            SessionSettings.instance.paintIndicatorOutline = sender.isOn
        }
        else if sender == promptBackSwitch {
            SessionSettings.instance.promptBack = sender.isOn
        }
        else if sender == canvasLockBorderSwitch {
            SessionSettings.instance.canvasLockBorder = sender.isOn
        }
        else if sender == showPaintBarSwitch {
            SessionSettings.instance.showPaintBar = sender.isOn
            if sender.isOn && showPaintCircleSwitch.isOn {
                showPaintCircleSwitch.setOn(false, animated: true)
                SessionSettings.instance.showPaintCircle = false
            }
        }
        else if sender == showPaintCircleSwitch {
            SessionSettings.instance.showPaintCircle = sender.isOn
            if sender.isOn && showPaintBarSwitch.isOn {
                showPaintBarSwitch.setOn(false, animated: true)
                SessionSettings.instance.showPaintBar = false
            }
        }
        else if sender == rightHandedSwitch {
            SessionSettings.instance.rightHanded = sender.isOn
        }
        else if sender == smallActionButtonsSwitch {
            SessionSettings.instance.smallActionButtons = sender.isOn
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        if sender == paintMeterColorResetButton {
            SessionSettings.instance.paintIndicatorColor = Utils.int32FromColorHex(hex: "0xff999999")
            paintMeterColorColorView.backgroundColor = UIColor(argb: SessionSettings.instance.paintIndicatorColor)
        }
        else if sender == gridLineColorResetButton {
            SessionSettings.instance.gridLineColor = 0
            gridLineColorColorView.backgroundColor = UIColor.white
        }
        else if sender == canvasLockColorResetButton {
            SessionSettings.instance.canvasLockColor = Utils.int32FromColorHex(hex: "0x66ff0000")
            canvasLockColorColorView.backgroundColor = UIColor(argb: SessionSettings.instance.canvasLockColor)
        }
    }
    
    @objc func tappedTextureTitle() {
        creditsScrollView.isHidden = false
    }
    
    @objc func tappedPaintMeterColorView(sender: UIView) {
        colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.paintIndicatorColor)
        
        colorPickerContainerView.isHidden = false
        colorPickerContainerView.alpha = 0
        
        colorPickerCancelButton.isHidden = false
        colorPickerCancelButton.alpha = 0
        
        colorPickerDoneButton.isHidden = false
        colorPickerDoneButton.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.colorPickerContainerView.alpha = 1
            self.colorPickerCancelButton.alpha = 1
            self.colorPickerDoneButton.alpha = 1
        }
        
        selectingPaintMeterColor = true
    }
    
    @objc func tappedGridLineColorView(sender: UIView) {
        if SessionSettings.instance.gridLineColor == 0 {
            colorPickerViewController.selectedColor = UIColor.white
        }
        else {
            colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.gridLineColor)
        }
        
        colorPickerContainerView.isHidden = false
        colorPickerContainerView.alpha = 0
        
        colorPickerCancelButton.isHidden = false
        colorPickerCancelButton.alpha = 0
        
        colorPickerDoneButton.isHidden = false
        colorPickerDoneButton.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.colorPickerContainerView.alpha = 1
            self.colorPickerCancelButton.alpha = 1
            self.colorPickerDoneButton.alpha = 1
        }
        
        selectingGridLineColor = true
    }
    
    @objc func tappedCanvasLockColorView(sender: UIView) {
        colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.canvasLockColor)
        
        colorPickerContainerView.isHidden = false
        colorPickerContainerView.alpha = 0
        
        colorPickerCancelButton.isHidden = false
        colorPickerCancelButton.alpha = 0
        
        colorPickerDoneButton.isHidden = false
        colorPickerDoneButton.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.colorPickerContainerView.alpha = 1
            self.colorPickerCancelButton.alpha = 1
            self.colorPickerDoneButton.alpha = 1
        }
        
        selectingCanvasLockColor = true
    }
    
    @objc func tappedRecentColorLabel1(sender: UITapGestureRecognizer) {
        let view = sender.view!
        SessionSettings.instance.numRecentColors = Int((view as! UILabel).text!)!
        
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
    }
    
    @objc func tappedRecentColorLabel2(sender: UITapGestureRecognizer) {
        let view = sender.view!
        SessionSettings.instance.numRecentColors = Int((view as! UILabel).text!)!
           
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
    }
    
    @objc func tappedRecentColorLabel3(sender: UITapGestureRecognizer) {
        let view = sender.view!
        SessionSettings.instance.numRecentColors = Int((view as! UILabel).text!)!
           
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
    }
    
    @objc func tappedRecentColorLabel4(sender: UITapGestureRecognizer) {
        let view = sender.view!
        SessionSettings.instance.numRecentColors = Int((view as! UILabel).text!)!
           
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
    }
    
    @objc func tappedRecentColorLabel5(sender: UITapGestureRecognizer) {
        let view = sender.view!
        SessionSettings.instance.numRecentColors = Int((view as! UILabel).text!)!
           
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
    }
    
    @objc func tappedRecentColorLabel6(sender: UITapGestureRecognizer) {
        let view = sender.view!
        SessionSettings.instance.numRecentColors = Int((view as! UILabel).text!)!
           
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
    }
    
    @objc func tappedRecentColorLabel7(sender: UITapGestureRecognizer) {
        let view = sender.view!
        SessionSettings.instance.numRecentColors = Int((view as! UILabel).text!)!
           
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
    }
    
    @objc func tappedRecentColorLabel8(sender: UITapGestureRecognizer) {
        let view = sender.view!
        SessionSettings.instance.numRecentColors = Int((view as! UILabel).text!)!
           
        selectRecentColorLabel(amt: SessionSettings.instance.numRecentColors)
    }
    
    @IBAction func colorPickerCancelPressed(_ sender: Any) {
        if selectingPaintMeterColor {
            paintMeterColorColorView.backgroundColor = UIColor(argb: SessionSettings.instance.paintIndicatorColor)
            colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.paintIndicatorColor)
            
            selectingPaintMeterColor = false
        }
        else if selectingCanvasLockColor {
            canvasLockColorColorView.backgroundColor = UIColor(argb: SessionSettings.instance.canvasLockColor)
            colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.canvasLockColor)
            
            selectingCanvasLockColor = false
        }
        else if selectingGridLineColor {
            if SessionSettings.instance.gridLineColor == 0 {
                gridLineColorColorView.backgroundColor = UIColor.white
                colorPickerViewController.selectedColor = UIColor.white
            }
            else {
                gridLineColorColorView.backgroundColor = UIColor(argb: SessionSettings.instance.gridLineColor)
                colorPickerViewController.selectedColor = UIColor(argb: SessionSettings.instance.gridLineColor)
            }
            
            selectingGridLineColor = false
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.colorPickerContainerView.alpha = 0
            self.colorPickerCancelButton.alpha = 0
            self.colorPickerDoneButton.alpha = 0
        }) { (success) in
            if success {
                self.colorPickerContainerView.isHidden = true
                self.colorPickerCancelButton.isHidden = true
                self.colorPickerDoneButton.isHidden = true
            }
        }
    }
    
    @IBAction func colorSelectDonePressed(_ sender: Any) {
        let color = self.colorPickerViewController.selectedColor
    
        if selectingPaintMeterColor {
            SessionSettings.instance.paintIndicatorColor = color.argb()!
            
            selectingPaintMeterColor = false
        }
        else if selectingGridLineColor {
            SessionSettings.instance.gridLineColor = color.argb()!
            
            selectingGridLineColor = false
        }
        else if selectingCanvasLockColor {
            SessionSettings.instance.canvasLockColor = color.argb()!
            
            selectingCanvasLockColor = false
        }
        
        UIView.animate(withDuration: 0.2) {
            self.colorPickerContainerView.alpha = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.colorPickerContainerView.alpha = 0
            self.colorPickerCancelButton.alpha = 0
            self.colorPickerDoneButton.alpha = 0
        }) { (success) in
            if success {
                self.colorPickerContainerView.isHidden = true
                self.colorPickerCancelButton.isHidden = true
                self.colorPickerDoneButton.isHidden = true
            }
        }
    }
    
    func selectRecentColorLabel(amt: Int) {
        let labels = [recentColorsAmtLabel1, recentColorsAmtLabel2, recentColorsAmtLabel3, recentColorsAmtLabel4,
        recentColorsAmtLabel5, recentColorsAmtLabel6, recentColorsAmtLabel7, recentColorsAmtLabel8]
        
        for label in labels {
            let labelAmt = Int(label!.text!)
            if amt == labelAmt {
                label!.textColor = UIColor(argb: ActionButtonView.altGreenColor)
            }
            else {
                label!.textColor = UIColor(argb: ActionButtonView.whiteColor)
            }
        }
    }
    
    // sign-in
    @IBAction func signInPressed(_ sender: Any) {
        self.performSegue(withIdentifier: showSignIn, sender: nil)
    }
    
    // pincode
    @IBAction func pincodePressed() {
        self.performSegue(withIdentifier: showPincode, sender: nil)
    }
    
    @IBAction func singlePlayReset(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Please understand that resetting your single play will permanently erase your current single play canvas, to proceed please type DELETE in all caps.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            self.alertTextField = textField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            if self.alertTextField.text != nil && self.alertTextField.text == "DELETE" {
                UserDefaults.standard.removeObject(forKey: "arr_single")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func changeNamePressed(_ sender: Any) {
        URLSessionHandler.instance.updateDisplayName(name: self.checkedName) { (success) -> (Void) in
            if success {
                SessionSettings.instance.displayName = self.checkedName
                
                self.changeNameButton.isEnabled = false
                self.changeNameButton.setTitle("Updated", for: .disabled)
                
                self.changeNameTextField.isEnabled = false
                self.changeNameTextField.layer.borderWidth = 0
            }
        }
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        if SessionSettings.instance.googleAuth {
            signInButton.isEnabled = false
        }
        
        changeNameTextField.text = SessionSettings.instance.displayName
        
        if SessionSettings.instance.pincodeSet {
            signInButton.isEnabled = false
            pincodeButton.setTitle("Change Access Pincode", for: .normal)
        }
        else {
            pincodeButton.setTitle("Set Access Pincode", for: .normal)
        }
    }
    
    // panel collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PanelBackgroundCell", for: indexPath) as! PanelBackgroundCollectionViewCell
        
        let backgroundName = self.panels[indexPath.item]
        
        cell.imageView.contentMode = .scaleAspectFit
        
        cell.selectAction.colorMode = .white
        cell.selectAction.type = .yes
        
        if SessionSettings.instance.panelBackgroundName != backgroundName {
            cell.selectAction.isHidden = true
        }
        else {
            cell.selectAction.isHidden = false
        }
        
        cell.imageView.image = images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // let offsetX = collectionView.contentOffset.x
        SessionSettings.instance.panelBackgroundName = self.panels[indexPath.item]
        
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.changeNameButton.isEnabled = false
        textField.layer.borderWidth = 0
        return true
    }
    
    // ui textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        let name = textField.text
        if (name != nil) {
            if name!.count > 20 {
                self.changeNameButton.isEnabled = false
                
                textField.layer.borderWidth = 2
                textField.layer.borderColor = UIColor(argb: ActionButtonView.redColor).cgColor
                
                return false
            }
            
            URLSessionHandler.instance.sendNameCheck(name: name!.trimmingCharacters(in: .whitespacesAndNewlines)) { (success) -> (Void) in
                if success {
                    self.changeNameButton.isEnabled = true
                    self.checkedName = name!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    textField.layer.borderWidth = 2
                    textField.layer.borderColor = UIColor(argb: ActionButtonView.greenColor).cgColor
                }
                else {
                    self.changeNameButton.isEnabled = false
                    
                    textField.layer.borderWidth = 2
                    textField.layer.borderColor = UIColor(argb: ActionButtonView.redColor).cgColor
                }
            }
        }
        
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindToMenu" {
            SessionSettings.instance.save()
        }
        else if segue.identifier == "ColorPickerEmbed" {
            colorPickerViewController = segue.destination as! CustomColorPickerViewController
            colorPickerViewController.delegate = self
        }
        else if segue.identifier == "ShowPincode" {
            let pincodeViewContoller = segue.destination as! PincodeViewController
            
            if SessionSettings.instance.pincodeSet {
                pincodeViewContoller.mode = pincodeViewContoller.modeChangePincode
            }
            else {
                pincodeViewContoller.mode = pincodeViewContoller.modeSetPincode
            }
        }
    }
    
    // color picker delegate
    func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        if selectingPaintMeterColor {
            paintMeterColorColorView.backgroundColor = selectedColor
        }
        else if selectingGridLineColor {
            gridLineColorColorView.backgroundColor = selectedColor
        }
        else if selectingCanvasLockColor {
            canvasLockColorColorView.backgroundColor = selectedColor
        }
    }
    
    func setBackground() {
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(argb: Utils.int32FromColorHex(hex: "0xff000000")).cgColor, UIColor(argb: Utils.int32FromColorHex(hex: "0xff333333")).cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)

        view.layer.insertSublayer(gradient, at: 0)
    }
}
