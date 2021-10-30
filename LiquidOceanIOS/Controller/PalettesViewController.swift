//
//  PalettesViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 10/28/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol PalettesViewControllerDelegate: AnyObject {
    func notifyPaletteSelected(palette: Palette, index: Int)
}

class PalettesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addPaletteButton: ActionButtonFrame!
    @IBOutlet weak var addPaletteAction: ActionButtonView!
    
    @IBOutlet weak var paletteNameTextField: UITextField!
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    weak var delegate: PalettesViewControllerDelegate?
    
    let palettesHeaderViewReuseId = "PalettesHeaderView"
    let paletteCellReuseId = "PaletteCell"
    
    let maxPaletteNameInput = 50
    
    var _palettes = [Palette]()
    var palettes: [Palette] {
        set {
            _palettes = newValue
            collectionView.reloadData()
        }
        get {
            return _palettes
        }
    }
    
    private var _hideTitle = false
    var hideTitle: Bool {
        set {
            _hideTitle = newValue
            collectionView.reloadSections(IndexSet(integer: 0))
        }
        get {
            return _hideTitle
        }
    }
    
    override func viewDidLoad() {
        addPaletteAction.type = .add
        addPaletteAction.darkIcons = false
        addPaletteButton.actionButtonView = addPaletteAction
        
        addPaletteButton.setOnClickListener {
            self.startNameInput()
        }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(sender:)))
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        collectionView.addGestureRecognizer(lpgr)
    }
    
    override func viewDidLayoutSubviews() {
        setBackground()
    }
    
    @objc func didLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let point = sender.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: point)!
            
            if indexPath.item > 0 {
                showPaletteRemoveAlert(palette: palettes[indexPath.item], atIndexPath: indexPath)
            }
        }
    }
    
    func showPaletteRemoveAlert(palette: Palette, atIndexPath: IndexPath) {
        let alertVC = UIAlertController(title: nil, message: "Remove " + palette.name + "?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.removePalette(palette: palette, atIndexPath: atIndexPath)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func reset() {
        if palettes.count > 0 {
            self.collectionView.scrollToItem(at: IndexPath(item: SessionSettings.instance.selectedPaletteIndex, section: 0), at: .centeredVertically, animated: true)
        }
    }
    
    func selectedPaletteCollectionViewCell() -> PaletteCollectionViewCell? {
        let visibleCells = collectionView.visibleCells
        for cell in visibleCells {
            let indexPath = collectionView.indexPath(for: cell)!
            if indexPath.item == SessionSettings.instance.selectedPaletteIndex {
                return cell as? PaletteCollectionViewCell
            }
        }
        
        return nil
    }
    
    func paletteCellAtIndexPath(indexPath: IndexPath) -> PaletteCollectionViewCell? {
        let visibleCells = collectionView.visibleCells
        for cell in visibleCells {
            let cellIndexPath = collectionView.indexPath(for: cell)!
            if indexPath.item == cellIndexPath.item {
                return cell as? PaletteCollectionViewCell
            }
        }
        return nil
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return palettes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let palette = palettes[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: paletteCellReuseId, for: indexPath) as! PaletteCollectionViewCell
        
        cell.nameLabel.text = palette.displayName
        
        if SessionSettings.instance.selectedPaletteIndex == indexPath.item {
            cell.nameLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xffdf7126"))
        }
        else {
            cell.nameLabel.textColor = UIColor.white
        }
        
        if palette.colors.count == 1 {
            cell.numColorsLabel.text = String(palette.colors.count) + " color"
        }
        else {
            if palette.name == "Recent Color" {
                cell.numColorsLabel.text = String(SessionSettings.instance.numRecentColors) + " colors"
            }
            else {
                cell.numColorsLabel.text = String(palette.colors.count) + " colors"
            }
        }
        
        //cell.delegate = self
        
        //cell.onRecycle(indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: palettesHeaderViewReuseId, for: indexPath)
        
        view.isHidden = hideTitle
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        SessionSettings.instance.selectedPaletteIndex = index
        delegate?.notifyPaletteSelected(palette: palettes[index], index: index)
    }
    
    func setBackground() {
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(argb: Utils.int32FromColorHex(hex: "0xff000000")).cgColor, UIColor(argb: Utils.int32FromColorHex(hex: "0xff333333")).cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)

        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var addedPalette = false
        
        let name = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.count > 0 {
            let regex = try! NSRegularExpression(pattern: "^[\\d\\w\\s]+$", options: [])
            let result = regex.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.count))
            
            if result != nil && name.count < maxPaletteNameInput {
                var nameExists = false
                for palette in SessionSettings.instance.palettes {
                    if palette.name == name {
                        nameExists = true
                    }
                }
                
                if !nameExists {
                    SessionSettings.instance.addPalette(name: name)
                    self._palettes = SessionSettings.instance.palettes
                    
                    self.collectionView.insertItems(at: [IndexPath(item: palettes.count - 1, section: 0)])
                    
                    addedPalette = true
                }
            }
        }
        
        textField.resignFirstResponder()
        self.endNameInput(addedPalette: addedPalette)
        
        return true
    }
    
    func startNameInput() {
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
        
        self.addPaletteButton.isHidden = true
        self.hideTitle = true
        
        self.paletteNameTextField.isHidden = false
        self.paletteNameTextField.becomeFirstResponder()
    }
    
    func endNameInput(addedPalette: Bool) {
        self.addPaletteButton.isHidden = false
        self.hideTitle = false
        
        self.paletteNameTextField.text = ""
        self.paletteNameTextField.isHidden = true
        
        if addedPalette {
            self.collectionView.scrollToItem(at: IndexPath(item: palettes.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    func getSelectedPaletteCollectionViewCell() -> PaletteCollectionViewCell? {
        return selectedPaletteCollectionViewCell()
    }
    
    func removePalette(palette: Palette, atIndexPath: IndexPath) {
        let index = atIndexPath.item
        if index > 0 {
            collectionView.deleteItems(at: [atIndexPath])
            
            if SessionSettings.instance.selectedPaletteIndex == index {
                SessionSettings.instance.selectedPaletteIndex = 0
            }
            
            SessionSettings.instance.palettes.remove(at: index)
            palettes = SessionSettings.instance.palettes
        }  
    }
    
    func indexPathInCollectionView(cell: UICollectionViewCell) -> IndexPath {
        return collectionView.indexPath(for: cell)!
    }
}

