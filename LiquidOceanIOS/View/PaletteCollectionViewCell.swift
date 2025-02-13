//
//  PaletteCollectionViewCell.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 10/29/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol PaletteCollectionViewCellDelegate: AnyObject {
    func getSelectedPaletteCollectionViewCell() -> PaletteCollectionViewCell?
    func deletePaletteCell(cell: PaletteCollectionViewCell)
}

class PaletteCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numColorsLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: PaletteCollectionViewCellDelegate?
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        let gr = UITouchGestureRecognizer(target: self, action: #selector(didTouchCell(sender:)))
        gr.cancelsTouchesInView = false
        
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = false
        
        gr.delegate = self
        //contentView.addGestureRecognizer(gr)
        
        let pgr = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        pgr.cancelsTouchesInView = false
        
        pgr.delegate = self
        //contentView.addGestureRecognizer(pgr)
    }
    
    @objc func didTouchCell(sender: UITouchGestureRecognizer) {
        if sender.state == .began {
            
        }
        else if sender.state == .cancelled {
            
        }
    }
    
    @objc func didPan(sender: UIPanGestureRecognizer) {
        let view = sender.view!
        
        let translation = sender.translation(in: view.superview)
        
        if (nameLabel.text != "Recent Color") {
            scrollView.contentOffset = CGPoint(x: -translation.x, y: 0)
        }
        
        if sender.state == .ended {
            resetOrDelete()
        }
    }
    
    func highlight() {
        nameLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xffdf7126"))
        
        let selectedCell = delegate?.getSelectedPaletteCollectionViewCell()
        if selectedCell != nil && selectedCell != self {
            selectedCell?.nameLabel.textColor = UIColor.white
        }
    }
    
    func unhighlight() {
        nameLabel.textColor = UIColor.white
        
        let selectedCell = delegate?.getSelectedPaletteCollectionViewCell()
        if selectedCell != nil {
            selectedCell?.nameLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xffdf7126"))
        }
    }
    
    func resetOrDelete() {
        if scrollView.contentOffset.x < self.frame.size.width / 2 {
            scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else {
            scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: true)
            delegate?.deletePaletteCell(cell: self)
        }
    }
    
    func onRecycle(indexPath: IndexPath) {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
