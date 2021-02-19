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
    
    var _art: [InteractiveCanvas.RestorePoint]?
    var art: [InteractiveCanvas.RestorePoint]? {
        set {
            _art = newValue
            artView.art = _art
        }
        get {
            return _art
        }
    }
    
    
    var delegate: ExportViewControllerDelegate?
    
    @IBOutlet weak var backButton: ActionButtonView!
    @IBOutlet weak var artView: ArtView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.type = .back
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
