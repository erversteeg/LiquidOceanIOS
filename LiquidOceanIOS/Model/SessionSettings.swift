//
//  SessionSettings.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import Foundation
import UIKit

class SessionSettings: NSObject {

    static var instance = SessionSettings()
    
    var interactiveCanvas: InteractiveCanvas!
    
    func save() {
        interactiveCanvas.save()
    }
    
    func load() {
        
    }
    
    func userDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
}
