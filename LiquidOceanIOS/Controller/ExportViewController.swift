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
    
    @IBOutlet weak var artViewHeight: NSLayoutConstraint!
    
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
    
    @IBOutlet weak var backButton: ActionButtonView!
    @IBOutlet weak var backButtonLeading: NSLayoutConstraint!
    
    @IBOutlet weak var artView: ArtView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.type = .backSolid
        
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
    }
    
    override func viewDidLayoutSubviews() {
        if artView.frame.origin.y < (saveButton.frame.origin.y + saveButton.frame.size.height) {
            artViewHeight.constant -= (saveButton.frame.origin.y + saveButton.frame.size.height) - artView.frame.origin.y + 10
        }
        
        let backX = self.backButton.frame.origin.x
        if backX < 0 {
            backButtonLeading.constant += 30
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
