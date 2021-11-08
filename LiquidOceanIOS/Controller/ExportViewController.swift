//
//  ExportViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/18/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol ExportViewControllerDelegate: AnyObject {
    func notifyExportViewControllerBackPressed()
}

class ExportViewController: UIViewController {

    @IBOutlet weak var saveButton: ActionButtonFrame!
    @IBOutlet weak var saveActionView: ActionButtonView!
    
    @IBOutlet weak var shareButton: ActionButtonFrame!
    @IBOutlet weak var shareActionView: ActionButtonView!
    
    @IBOutlet weak var artViewWidth: NSLayoutConstraint!
    @IBOutlet weak var artViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var screenSizeLabel: UILabel!
    @IBOutlet weak var actualSizeLabel: UILabel!
    @IBOutlet weak var artSizeSwitch: UISwitch!
    
    @IBOutlet weak var artSizeSwitchTop: NSLayoutConstraint!
    
    var _art: [InteractiveCanvas.RestorePoint]?
    var art: [InteractiveCanvas.RestorePoint]? {
        set {
            _art = newValue
            artView.showBackground = true
            artView.art = _art
            
            if let art = art {
                if art.count > 0 {
                    SessionSettings.instance.addToShowcase(art: art)
                    SessionSettings.instance.save()
                }
            }
        }
        get {
            return _art
        }
    }
    
    var delegate: ExportViewControllerDelegate?
    
    @IBOutlet weak var backButton: ActionButtonFrame!
    @IBOutlet weak var backAction: ActionButtonView!
    
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var artView: ArtView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.actionButtonView = backAction
        backAction.type = .backSolid
        
        backButton.setOnClickListener {
            self.delegate?.notifyExportViewControllerBackPressed()
        }
        
        saveActionView.type = .save
        saveButton.actionButtonView = saveActionView
        
        saveButton.setOnClickListener {
            self.artView.saveArtToPhotos()
        }
        
        shareActionView.type = .share
        shareButton.actionButtonView = shareActionView
        
        shareButton.setOnClickListener {
            // set up activity view controller
            let imageToShare = self.artView.getArtImage()
            let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view

            // exclude some activity types from the list (optional)
            // activityViewController.excludedActivityTypes = [ActivityType.airDrop, ActivityType.postToFacebook]

            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        screenSizeLabel.addGestureRecognizer(UITouchGestureRecognizer(target: self, action: #selector(touchedScreenSizeLabel(sender:))))
        
        actualSizeLabel.addGestureRecognizer(UITouchGestureRecognizer(target: self, action: #selector(touchedActualSizeLabel(sender:))))
    }
    
    override func viewDidLayoutSubviews() {
        if artView.frame.origin.y < (saveButton.frame.origin.y + saveButton.frame.size.height) {
            artViewHeight.constant -= (saveButton.frame.origin.y + saveButton.frame.size.height) - artView.frame.origin.y + 10
        }
        
        let backX = self.backButton.frame.origin.x
        if backX < 0 {
            backButtonLeading.constant += 30
        }
        
        if view.frame.size.height > 600 {
            artViewWidth.constant = view.frame.size.width - 130
            artViewHeight.constant = view.frame.size.height - 200
            
            artSizeSwitchTop.constant = 45
        }
        
        artView.setNeedsDisplay()
    }
    
    @IBAction func artSizeValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            actualSize()
        }
        else {
            screenSize()
        }
    }

    @objc func touchedScreenSizeLabel(sender: UITouchGestureRecognizer) {
        if sender.state == .began {
            artSizeSwitch.isOn = true
            artSizeValueChanged(artSizeSwitch)
        }
    }
    
    @objc func touchedActualSizeLabel(sender: UITouchGestureRecognizer) {
        if sender.state == .began {
            artSizeSwitch.isOn = false
            artSizeValueChanged(artSizeSwitch)
        }
    }
    
    func screenSize() {
        screenSizeLabel.isHidden = false
        actualSizeLabel.isHidden = true
        
        artView.actualSize = false
    }
    
    func actualSize() {
        screenSizeLabel.isHidden = true
        actualSizeLabel.isHidden = false
        
        artView.actualSize = true
    }
}
