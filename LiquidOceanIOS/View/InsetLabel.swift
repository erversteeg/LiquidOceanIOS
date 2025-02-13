//
//  InsetLabel.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 11/8/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        super.drawText(in: rect.inset(by: insets))
    }

}
