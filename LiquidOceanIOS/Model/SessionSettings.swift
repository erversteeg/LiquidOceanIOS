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
    
    private var _dropsAmt: Int = 0
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
    
    var darkIcons = false
    
    var backgroundColorIndex = 0
    
    var paintQtyDelegates = [PaintQtyDelegate]()
    
    var numRecentColors = 8
    
    var xp = 0
    
    var displayName = ""
    
    var artShowcase: [[InteractiveCanvas.RestorePoint]]?
    
    var showcaseIndex = 0
    
    var googleAuth = false
    
    var nextPaintTime: Double!
    
    var timeSync: Double {
        set {
            nextPaintTime = Date().timeIntervalSince1970 + newValue
        }
        get {
            return 0
        }
    }
    
    var panelBackgroundName = ""
    
    func save() {        
        userDefaults().set(uniqueId, forKey: "installation_id")
        userDefaults().set(dropsAmt, forKey: "drops_amt")
        userDefaults().set(sentUniqueId, forKey: "sent_unique_id")
        userDefaults().set(paintColor, forKey: "paint_color")
        userDefaults().set(darkIcons, forKey: "dark_icons")
        userDefaults().set(backgroundColorIndex, forKey: "background_color")
        userDefaults().set(numRecentColors, forKey: "num_recent_colors")
        userDefaults().set(xp, forKey: "xp")
        userDefaults().set(displayName, forKey: "display_name")
        userDefaults().set(artShowcaseJsonString(), forKey: "art_showcase_json")
        userDefaults().set(googleAuth, forKey: "google_auth")
        userDefaults().set(panelBackgroundName, forKey: "panel_background")
    }
    
    func load() {
        uniqueId = userDefaultsString(forKey: "installation_id", defaultVal: UUID().uuidString)
        
        sentUniqueId = userDefaultsBool(forKey: "sent_unique_id", defaultVal: false)
        
        paintColor = userDefaultsInt32(forKey: "paint_color", defaultVal: Utils.int32FromColorHex(hex: "0xFFFFFFFF"))
        
        darkIcons = userDefaultsBool(forKey: "dark_icons", defaultVal: false)
        
        backgroundColorIndex = userDefaultsInt(forKey: "background_color", defaultVal: 0)
        
        numRecentColors = userDefaultsInt(forKey: "num_recent_colors", defaultVal: 8)
        
        xp = userDefaultsInt(forKey: "xp", defaultVal: 0)
        
        displayName = userDefaultsString(forKey: "display_name", defaultVal: "")
        
        artShowcase = loadArtShowcase(jsonStr: userDefaultsString(forKey: "art_showcase_json", defaultVal: ""))
        
        googleAuth = userDefaultsBool(forKey: "google_auth", defaultVal: false)
        
        panelBackgroundName = userDefaultsString(forKey: "panel_background", defaultVal: "")
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
            return userDefaults().object(forKey: forKey) as! Int
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
    
    // art showcase
    private func artShowcaseJsonString() -> String? {
        if let artShowcase = self.artShowcase {
            var ret = [[[String: Int32]]]()
            
            for i in artShowcase.indices {
                let art = artShowcase[i]
                
                var restorePoints = [[String: Int32]]()
                for j in art.indices {
                    let restorePoint = art[j]
                    var dict = [String: Int32]()
                    
                    dict["x"] = Int32(restorePoint.x)
                    dict["y"] = Int32(restorePoint.y)
                    dict["color"] = restorePoint.color
                    
                    restorePoints.append(dict)
                }
                
                ret.append(restorePoints)
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: ret, options: [])
                
                return String(data: jsonData, encoding: .utf8)
            }
            catch {
                
            }
        }
        
        return nil
    }
    
    func loadArtShowcase(jsonStr: String?) -> [[InteractiveCanvas.RestorePoint]]? {
        if let jsonStr = jsonStr {
            if jsonStr == "[null]" || jsonStr == "" {
                return nil
            }
            
            var showcase = [[InteractiveCanvas.RestorePoint]]()
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: jsonStr.data(using: .utf8)!, options: []) as! [[[String: Int32]]]
                
                for i in jsonArray.indices {
                    let artJsonArray = jsonArray[i]
                    
                    var art = [InteractiveCanvas.RestorePoint]()
                    
                    for j in artJsonArray.indices {
                        let jsonObj = artJsonArray[j]
                        art.append(InteractiveCanvas.RestorePoint(x: Int(jsonObj["x"]!), y: Int(jsonObj["y"]!), color: jsonObj["color"]!, newColor: jsonObj["color"]!))
                    }
                    
                    showcase.append(art)
                }
                
                return showcase
            }
            catch {
                
            }
        }
        
        return nil
    }
    
    func addToShowcase(art: [InteractiveCanvas.RestorePoint]) {
        if artShowcase == nil {
            artShowcase = [[InteractiveCanvas.RestorePoint]]()
        }
        
        if var artShowcase = self.artShowcase {
            if artShowcase.count < 10 {
                self.artShowcase!.append(art)
            }
            else {
                let rIndex = Int(arc4random() % UInt32(artShowcase.count))
                artShowcase.remove(at: rIndex)
                artShowcase.insert(art, at: rIndex)
            }
        }
    }
}
