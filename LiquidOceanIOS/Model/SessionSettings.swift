//
//  SessionSettings.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import Foundation
import UIKit

protocol PaintQtyDelegate {
    func notifyPaintQtyChanged(qty: Int)
}

class SessionSettings: NSObject {

    static var instance = SessionSettings()
    
    var interactiveCanvas: InteractiveCanvas!
    var uniqueId: String!
    
    private var _dropsAmt: Int!
    var dropsAmt: Int! {
        get {
            return _dropsAmt
        }
        set {
            _dropsAmt = newValue
            for delegate in self.paintQtyDelegates {
                delegate.notifyPaintQtyChanged(qty: newValue)
            }
        }
    }
    
    var sentUniqueId: Bool!
    
    var paintColor: Int32!
    
    var maxPaintAmt = 1000
    
    var paintQtyDelegates = [PaintQtyDelegate]()
    
    func save() {        
        userDefaults().set(uniqueId, forKey: "installation_id")
        userDefaults().set(dropsAmt, forKey: "drops_amt")
        userDefaults().set(sentUniqueId, forKey: "sent_unique_id")
        userDefaults().set(paintColor, forKey: "paint_color")
    }
    
    func load() {
        uniqueId = userDefaultsString(forKey: "installation_id", defaultVal: UUID().uuidString)
        
        sentUniqueId = userDefaultsBool(forKey: "sent_unique_id", defaultVal: false)
        
        paintColor = userDefaultsInt32(forKey: "paint_color", defaultVal: Utils.int32FromColorHex(hex: "0xFFFFFFFF"))
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
    
    func userDefaultsInt32(forKey: String, defaultVal: Int32) -> Int32 {
        if userDefaultsHasKey(key: forKey) {
            return userDefaults().object(forKey: forKey) as! Int32
        }
        else {
            return defaultVal
        }
    }
}
