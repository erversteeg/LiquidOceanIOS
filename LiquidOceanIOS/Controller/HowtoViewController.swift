//
//  HowtoViewController.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 3/1/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class HowtoViewController: UIViewController {

    @IBOutlet weak var backButton: ActionButtonFrame!
    @IBOutlet weak var backAction: ActionButtonView!
    
    @IBOutlet weak var howtoTitleLabel: UILabel!
    
    @IBOutlet weak var step1Text: UILabel!
    @IBOutlet weak var step2Text: UILabel!
    @IBOutlet weak var step3Text: UILabel!
    @IBOutlet weak var step4Text: UILabel!
    @IBOutlet weak var step5Text: UILabel!
    @IBOutlet weak var step6Text: UILabel!
    @IBOutlet weak var step7Text: UILabel!
    @IBOutlet weak var step8Text: UILabel!
    @IBOutlet weak var step9Text: UILabel!
    @IBOutlet weak var step10Text: UILabel!
    
    @IBOutlet weak var paintAction: ActionButtonView!
    @IBOutlet weak var exportAction: ActionButtonView!
    @IBOutlet weak var changeBackgroundAction: ActionButtonView!
    @IBOutlet weak var gridLineAction: ActionButtonView!
    @IBOutlet weak var summaryAction: ActionButtonView!
    @IBOutlet weak var dotAction1: ActionButtonView!
    @IBOutlet weak var dotAction2: ActionButtonView!
    @IBOutlet weak var frameAction: ActionButtonView!
    @IBOutlet weak var dotAction3: ActionButtonView!
    
    @IBOutlet weak var backActionLeading: NSLayoutConstraint!
    
    @IBOutlet weak var recentColorsContainerWidth: NSLayoutConstraint!
    @IBOutlet weak var recentColorsContainerHeight: NSLayoutConstraint!
    
    weak var recentColorsViewController: RecentColorsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        
        backButton.actionButtonView = backAction
        backAction.type = .backSolid
        
        backButton.setOnClickListener {
            self.performSegue(withIdentifier: "UnwindToMenu", sender: nil)
        }
        
        paintAction.isStatic = true
        exportAction.isStatic = true
        changeBackgroundAction.isStatic = true
        gridLineAction.isStatic = true
        summaryAction.isStatic = true
        dotAction1.isStatic = true
        dotAction2.isStatic = true
        frameAction.isStatic = true
        dotAction3.isStatic = true
        
        paintAction.type = .paint
        exportAction.type = .export
        changeBackgroundAction.type = .changeBackground
        gridLineAction.type = .gridLines
        summaryAction.type = .summary
        dotAction1.type = .dot
        dotAction2.type = .dot
        frameAction.type = .frame
        dotAction3.type = .dot
        
        if view.frame.size.height <= 600 {
            howtoTitleLabel.isHidden = true
            
            step1Text.isHidden = true
            paintAction.isHidden = true
        }
        
        let stepLabels = [step1Text, step2Text, step3Text, step4Text, step5Text,
                          step6Text, step7Text, step8Text, step9Text, step10Text]
        for label in stepLabels {
            setStepBackground(label: label!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if view.frame.size.height <= 600 {
            Animator.animateTitleFromTop(titleView: howtoTitleLabel)
            
            Animator.animateHorizontalViewEnter(view: step1Text, left: true)
            Animator.animateHorizontalViewEnter(view: paintAction, left: true)
        }
    }

    func setBackground() {
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(argb: Utils.int32FromColorHex(hex: "0xff5576d4")).cgColor, UIColor(argb: Utils.int32FromColorHex(hex: "0xff7755d4")).cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)

        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setStepBackground(label: UILabel) {
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(argb: Utils.int32FromColorHex(hex: "0x99FFFFFF")).cgColor
        
        label.backgroundColor = UIColor(argb: Utils.int32FromColorHex(hex: "0x33000000"))
    }
    
    override func viewDidLayoutSubviews() {
        if step1Text.font.pointSize < step2Text.font.pointSize {
            step2Text.font = UIFont.systemFont(ofSize: step1Text.font.pointSize)
        }
        
        let backX = self.backAction.frame.origin.x
        
        if backX < 0 {
            backActionLeading.constant += 30
        }
        
        let colorStrs = ["000000", "222034", "45283C", "663931", "8F563B", "DF7126", "D9A066", "EEC39A",
                      "FBF236", "99E550", "6ABE30", "37946E", "4B692F", "524B24", "323C39", "3F3F74"]
        
        var colors = [Int32]()
        for colorStr in colorStrs {
            colors.append(Utils.int32FromColorHex(hex: "0xFF" + colorStr))
        }
        
        setupColorPalette(colors: colors.reversed())
    }
    
    func setupColorPalette(colors: [Int32]) {
        let itemWidth = self.recentColorsViewController.itemWidth
        let itemHeight = self.recentColorsViewController.itemWidth
        let margin = self.recentColorsViewController.itemMargin
        
        self.recentColorsContainerWidth.constant = itemWidth * 4 + margin * 3
        
        let numRows = (colors.count - 1) / 4 + 1
        self.recentColorsContainerHeight.constant = itemHeight * CGFloat(numRows) + margin * CGFloat(numRows - 1)
        
        self.recentColorsViewController.data = colors.reversed()
        self.recentColorsViewController.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecentColorsEmbed" {
            self.recentColorsViewController = segue.destination as? RecentColorsViewController
            self.recentColorsViewController.isStatic = true
        }
    }
}
