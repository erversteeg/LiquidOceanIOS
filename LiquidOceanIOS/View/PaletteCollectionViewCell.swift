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

class PaletteCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numColorsLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: PaletteCollectionViewCellDelegate?
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        let gr = UILongPressGestureRecognizer(target: self, action: #selector(didTouchCell(sender:)))
        gr.minimumPressDuration = 0
        gr.cancelsTouchesInView = false
        
        scrollView.delegate = self
        scrollView.isUserInteractionEnabled = false
        
        //contentView.addGestureRecognizer(gr)
    }
    
    @objc func didTouchCell(sender: UITouchGestureRecognizer) {
        if sender.state == .began {
            nameLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xffdf7126"))
            
            let selectedCell = delegate?.getSelectedPaletteCollectionViewCell()
            if selectedCell != nil && selectedCell != self {
                selectedCell?.nameLabel.textColor = UIColor.white
            }
        }
        else if sender.state == .cancelled {
            nameLabel.textColor = UIColor.white
            
            let selectedCell = delegate?.getSelectedPaletteCollectionViewCell()
            if selectedCell != nil {
                selectedCell?.nameLabel.textColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xffdf7126"))
            }
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
    
    func resetOrDelete() {
        if scrollView.contentOffset.x < self.frame.size.width / 2 {
            scrollView .setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        else {
            scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: true)
            delegate?.deletePaletteCell(cell: self)
        }
    }
    
    func onIndexPath(indexPath: IndexPath) {
        let pgr = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
        contentView.addGestureRecognizer(pgr)
    }
}
