//
//  Animator.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/22/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class Animator: NSObject {

    static var context: UIViewController?
    
    static func getSafePoint(view: UIView, parent: UIView, safeViews: [UIView]) -> CGPoint {
        let x = CGFloat(arc4random() % UInt32(parent.frame.size.width)) - view.frame.size.width / 2
        let y = CGFloat(arc4random() % UInt32(parent.frame.size.height)) - view.frame.size.height / 2
        
        let safeViewMargin = CGFloat(10)
        
        for safeView in safeViews {
            if x > safeView.frame.origin.x - safeViewMargin && x < safeView.frame.origin.x + safeView.frame.size.width + safeViewMargin && y > safeView.frame.origin.y - safeViewMargin && y < safeView.frame.origin.y + safeView.frame.size.height + safeViewMargin {
                return getSafePoint(view: view, parent: parent, safeViews: safeViews)
            }
        }
        
        return CGPoint(x: x, y: y)
    }
    
    static func animatePixelColorEffect(view: UIView, parent: UIView, safeViews: [UIView]) {
        let point = getSafePoint(view: view, parent: parent, safeViews: safeViews)
        
        let x = point.x
        let y = point.y
        
        view.frame = CGRect(x: x - view.frame.size.width / 2, y: y - view.frame.size.height / 2, width: view.frame.size.width, height: view.frame.size.height)
        
        view.alpha = 0
        
        var rA = Int(rand() * 256) / 3 + 25
        
        if rand() < 0.15 {
            rA = 255
        }
        
        let rR = Int(rand() * 256)
        let rG = Int(rand() * 256)
        let rB = Int(rand() * 256)
        
        let rD = Int(rand() * 1500) + 250
        let rS = Int(rand() * 1500) + 250
        
        view.backgroundColor = UIColor(red: rR, green: rG, blue: rB, a: rA)
        UIView.animate(withDuration: Double(rD) / 1000, animations: {
            view.alpha = CGFloat(rA) / CGFloat(256)
        }) { (success) in
            Timer.scheduledTimer(withTimeInterval: Double(rS) / 1000, repeats: false) { (tmr) in
                UIView.animate(withDuration: Double(rD) / 1000, animations: {
                    view.alpha = 0
                }, completion: { (success) in
                    if success {
                        if context != nil {
                            self.animatePixelColorEffect(view: view, parent: parent, safeViews: safeViews)
                        } 
                    }
                })
            }
        }
    }
    
    static func rand() -> CGFloat {
        return CGFloat(arc4random() % 1000000) / CGFloat(1000000)
    }
    
    static func animateMenuButtons(views: [UIView], moveOut: Bool) {
        let delays = [CGFloat(0), CGFloat(50) / CGFloat(1000), CGFloat(80) / CGFloat(1000), CGFloat(100) / CGFloat(1000)]
        
        if !moveOut {
            var index = 0
            for view in views {
                view.frame = CGRect(x: view.frame.origin.x + 500, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
                
                view.alpha = 0
                
                Timer.scheduledTimer(withTimeInterval: Double(delays[index]), repeats: false) { (tmr) in
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.15) {
                            view.alpha = 1
                            view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
                        }
                    }
                }
                
                index += 1
            }
        }
        else {
            var index = 0
            for view in views {
                view.frame = CGRect(x: view.frame.origin.x + 500, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
                
                view.alpha = 0
                
                Timer.scheduledTimer(withTimeInterval: Double(delays[index]), repeats: false) { (tmr) in
                    UIView.animate(withDuration: 0.15) {
                        view.frame = CGRect(x: view.frame.origin.x + 500, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
                    }
                }
                
                index += 1
            }
        }
    }
}
