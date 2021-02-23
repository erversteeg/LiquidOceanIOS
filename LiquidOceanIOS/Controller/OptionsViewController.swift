//
//  OptionsViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/23/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet weak var optionsTitleAction: ActionButtonView!
    @IBOutlet weak var backAction: ActionButtonView!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var showSignIn = "ShowSignIn"
    
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
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        self.performSegue(withIdentifier: showSignIn, sender: nil)
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        if SessionSettings.instance.googleAuth {
            signInButton.isEnabled = false
        }
    }
}
