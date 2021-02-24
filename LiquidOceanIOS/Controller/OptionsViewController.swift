//
//  OptionsViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/23/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    @IBOutlet weak var optionsTitleAction: ActionButtonView!
    @IBOutlet weak var backAction: ActionButtonView!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var changeNameTextField: UITextField!
    
    var showSignIn = "ShowSignIn"
    
    let panels = ["wood_texture_light.jpg", "wood_texture.png", "marble_2.jpg", "fall_leaves.png", "water_texture.jpg",
    "space_texture.jpg", "metal_floor_1.jpg", "metal_floor_2.jpg", "foil.jpg", "rainbow_foil.jpg", "crystal_1.jpg",
    "crystal_2.jpg", "crystal_3.jpg", "crystal_4.jpg", "crystal_5.jpg", "crystal_6.jpg", "crystal_7.jpg",
    "crystal_8.jpg", "crystal_9.jpg", "crystal_10.jpg"]
    
    var images = [UIImage]()
    
    var alertTextField: UITextField!
    
    var checkedName: String!
    
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
        
        checkedName = SessionSettings.instance.displayName
        changeNameTextField.text = SessionSettings.instance.displayName
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        self.performSegue(withIdentifier: showSignIn, sender: nil)
    }
    
    @IBAction func singlePlayReset(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Resetting your single play will permanently erase your single play canvas. To proceed please type PROCEED", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            self.alertTextField = textField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
            if self.alertTextField.text != nil && self.alertTextField.text == "PROCEED" {
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
}
