//
//  OptionsViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/23/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var optionsTitleAction: ActionButtonView!
    @IBOutlet weak var backAction: ActionButtonView!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var showSignIn = "ShowSignIn"
    
    let panels = ["wood_texture_light.jpg", "wood_texture.png", "marble_2.jpg", "fall_leaves.png", "water_texture.jpg",
    "space_texture.jpg", "metal_floor_1.jpg", "metal_floor_2.jpg", "foil.jpg", "rainbow_foil.jpg", "crystal_1.jpg",
    "crystal_2.jpg", "crystal_3.jpg", "crystal_4.jpg", "crystal_5.jpg", "crystal_6.jpg", "crystal_7.jpg",
    "crystal_8.jpg", "crystal_9.jpg", "crystal_10.jpg"]
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))

        optionsTitleAction.type = .options
        backAction.type = .backSolid
        
        backAction.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }
        
        if SessionSettings.instance.googleAuth {
            signInButton.isEnabled = false
        }
        
        for panel in panels {
            images.append(resizeImage(image: UIImage(named: panel)!, newHeight: 200))
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        self.performSegue(withIdentifier: showSignIn, sender: nil)
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        if SessionSettings.instance.googleAuth {
            signInButton.isEnabled = false
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return panels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PanelBackgroundCell", for: indexPath) as! PanelBackgroundCollectionViewCell
        
        cell.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF333333"))
        
        cell.imageView.contentMode = .scaleToFill
        cell.selectAction.type = .yesLight
        
        cell.selectAction.isHidden = SessionSettings.instance.panelBackgroundName != self.panels[indexPath.item]
        
        cell.imageView.image = images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 230, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SessionSettings.instance.panelBackgroundName = self.panels[indexPath.item]
        
        collectionView.reloadData()
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
}
