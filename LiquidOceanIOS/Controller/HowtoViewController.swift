//
//  HowtoViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 3/1/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class HowtoViewController: UIViewController {

    @IBOutlet weak var backAction: ActionButtonView!
    @IBOutlet weak var howtoTitleAction: ActionButtonView!
    @IBOutlet weak var step1Text: UILabel!
    @IBOutlet weak var step2Text: UILabel!
    
    @IBOutlet weak var paintAction: ActionButtonView!
    @IBOutlet weak var paintQtyBar: PaintQuantityBar!
    
    @IBOutlet weak var artView: ArtView!
    
    @IBOutlet weak var paintEventInfoContainer: UIView!
    @IBOutlet weak var paintEventTimeLabel: UILabel!
    
    @IBOutlet weak var backActionLeading: NSLayoutConstraint!
    @IBOutlet weak var paintEventInfoContainerWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        
        backAction.type = .backSolid
        backAction.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }
        
        paintAction.selectable = false
        paintAction.type = .paint

        howtoTitleAction.type = .howto
        
        artView.showBackground = false
        artView.jsonFile = "mushroom_json"
        
        if view.frame.size.height <= 600 {
            howtoTitleAction.isHidden = true
            
            step1Text.isHidden = true
            paintAction.isHidden = true
            paintQtyBar.isHidden = true
        }
        
        paintEventInfoContainer.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0xFF303030"))
        paintEventInfoContainer.layer.cornerRadius = 20
        
        getPaintTimeInfo()
        
        setupPaintBarTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if view.frame.size.height <= 600 {
            Animator.animateTitleFromTop(titleView: howtoTitleAction)
            
            Animator.animateHorizontalViewEnter(view: step1Text, left: true)
            Animator.animateHorizontalViewEnter(view: paintAction, left: true)
            Animator.animateHorizontalViewEnter(view: paintQtyBar, left: true)
        }
    }

    func setBackground() {
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(argb: Utils.int32FromColorHex(hex: "0xff7755d4")).cgColor, UIColor(argb: Utils.int32FromColorHex(hex: "0xff5576d4")).cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)

        view.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        if step1Text.font.pointSize < step2Text.font.pointSize {
            step2Text.font = UIFont.systemFont(ofSize: step1Text.font.pointSize)
        }
        
        let backX = self.backAction.frame.origin.x
        
        if backX < 0 {
            backActionLeading.constant += 30
        }
    }
    
    func setupPaintBarTap() {
        let tgr = UITapGestureRecognizer(target: self, action: #selector(paintBarTapped))
        paintQtyBar.addGestureRecognizer(tgr)
    }
    
    @objc func paintBarTapped() {
        if paintEventInfoContainer.isHidden {
            paintEventInfoContainer.isHidden = false
        }
        else {
            paintEventInfoContainer.isHidden = true
        }
    }
    
    func getPaintTimeInfo() {
        URLSessionHandler.instance.getPaintTimerInfo { (success, nextPaintTime) -> (Void) in
            if success {
                if nextPaintTime >= 0 {
                    var ts = Int(nextPaintTime)
                    let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (tmr) in
                        ts -= 1
                        
                        if ts == 0 {
                            ts = 300
                        }
                        
                        let m = ts / 60
                        let s = ts % 60
                        
                        self.paintEventTimeLabel.text = String(format: "%02d:%02d", m, s)
                        self.paintEventInfoContainerWidth.constant = self.paintEventTimeLabel.text!.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: self.paintEventTimeLabel.font.pointSize)]).width + 20
                    }
                    timer.fire()
                }
                else {
                    self.paintEventTimeLabel.text = "???"
                }
            }
            else {
                self.paintEventTimeLabel.text = "???"
            }
        }
    }
}
