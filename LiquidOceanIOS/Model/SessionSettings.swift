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
    var uniqueId: String!
    
    var dropsAmt: Int!
    
    var sentUniqueId: Bool!
    
    var paintColor: Int!
    
    func save() {        
        userDefaults().set(uniqueId, forKey: "installation_id")
        userDefaults().set(dropsAmt, forKey: "drops_amt")
        userDefaults().set(sentUniqueId, forKey: "sent_unique_id")
        userDefaults().set(paintColor, forKey: "paint_color")
    }
    
    func load() {
        uniqueId = userDefaultsString(forKey: "installation_id", defaultVal: UUID().uuidString)
        
        sentUniqueId = userDefaultsBool(forKey: "sent_unique_id", defaultVal: false)
        
        paintColor = userDefaultsInt(forKey: "paint_color", defaultVal: 0xFFFFFFFF)
    }
    
    func userDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func userDefaultsHasKey(key: String) -> Bool {
        return userDefaults().object(forKey: key) != nil
    }
    
    func userDefaultsString(forKey: String, defaultVal: String) -> String {
        if userDefaultsHasKey(key: forKey) {
            return userDefaults().object(forKey: forKey) as! String
        }
        else {
            return defaultVal
        }
    }
    
    func userDefaultsBool(forKey: String, defaultVal: Bool) -> Bool {
        if userDefaultsHasKey(key: forKey) {
            return userDefaults().bool(forKey: forKey)
        }
        else {
            return defaultVal
        }
    }
    
    func userDefaultsInt(forKey: String, defaultVal: Int) -> Int {
        if userDefaultsHasKey(key: forKey) {
            return userDefaults().integer(forKey: forKey)
        }
        else {
            return defaultVal
        }
    }
}
