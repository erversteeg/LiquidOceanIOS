//
//  ActionButtonFrame.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/18/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class ActionButtonFrame: UIView {

    weak var _actionButtonView: ActionButtonView?
    weak var actionButtonView: ActionButtonView? {
        set {
            _actionButtonView = newValue
            
            backgroundColor = UIColor.clear
        }
        get {
            return _actionButtonView
        }
    }
    
    var clickHandler: (() -> Void)?

    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        commonInit()
    }
    
    func commonInit() {
        let dgr = UIDrawGestureRecognizer(target: self, action: #selector(onTouchAction(sender:)))
        addGestureRecognizer(dgr)
    }
    
    @objc func onTouchAction(sender: UIDrawGestureRecognizer) {
        if sender.state == .began {
            actionButtonView?.selected = true
        }
        else if sender.state == .changed {
            actionButtonView?.selected = true
        }
        else if sender.state == .ended {
            actionButtonView?.selected = false
            clickHandler?()
        }
    }
    
    func setOnClickListener(handler: @escaping () -> Void) {
        self.clickHandler = handler
    }
}
