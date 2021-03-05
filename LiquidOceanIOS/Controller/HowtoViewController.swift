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
    
    @IBOutlet weak var paintAction: ActionButtonView!
    @IBOutlet weak var paintQtyBar: PaintQuantityBar!
    
    @IBOutlet weak var artView: ArtView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        
        backAction.type = .back
        backAction.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }
        
        paintAction.selectable = false
        paintAction.type = .paint

        howtoTitleAction.type = .howto
        
        artView.showBackground = false
        artView.jsonFile = "mushroom_json"
        
        howtoTitleAction.isHidden = true
        
        step1Text.isHidden = true
        paintAction.isHidden = true
        paintQtyBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Animator.animateTitleFromTop(titleView: howtoTitleAction)
        
        Animator.animateHorizontalViewEnter(view: step1Text, left: true)
        Animator.animateHorizontalViewEnter(view: paintAction, left: true)
        Animator.animateHorizontalViewEnter(view: paintQtyBar, left: true)
    }

    func setBackground() {
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(argb: Utils.int32FromColorHex(hex: "0xff7755d4")).cgColor, UIColor(argb: Utils.int32FromColorHex(hex: "0xff5576d4")).cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)

        view.layer.insertSublayer(gradient, at: 0)
    }
}
