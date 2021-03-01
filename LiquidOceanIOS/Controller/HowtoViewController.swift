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
    
    @IBOutlet weak var paintAction: ActionButtonView!
    @IBOutlet weak var paintQtyBar: PaintQuantityBar!
    
    @IBOutlet weak var artView: ArtView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backAction.type = .backSolid
        backAction.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }
        
        paintAction.selectable = false
        paintAction.type = .paint

        howtoTitleAction.type = .howto
        
        artView.showBackground = false
        artView.jsonFile = "mushroom_json"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
