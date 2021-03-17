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
    
    var chunk1: [[Int32]]!
    var chunk2: [[Int32]]!
    var chunk3: [[Int32]]!
    var chunk4: [[Int32]]!
    
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
    
    var showGridLines = true
    
    var firstContributorName = ""
    var secondContributorName = ""
    var thirdContributorName = ""
    
    var paintIndicatorFill = false
    var paintIndicatorSquare = true
    var paintIndicatorOutline = true
    var paintIndicatorWidth = 4
    
    var gridLineColor: Int32 = 0
    
    var promptBack = false
    
    var canvasLockBorder = false
    var canvasLockColor: Int32 = 0
    
    var showPaintBar = true
    var showPaintCircle = false
    
    var shortTermPixels = [InteractiveCanvas.ShortTermPixel]()
    
    var paintIndicatorColor: Int32 = 0
    
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
        userDefaults().set(showGridLines, forKey: "show_grid_lines")
        userDefaults().set(paintIndicatorFill, forKey: "paint_indicator_fill")
        userDefaults().set(paintIndicatorSquare, forKey: "paint_indicator_square")
        userDefaults().set(paintIndicatorOutline, forKey: "paint_indicator_outline")
        userDefaults().set(paintIndicatorWidth, forKey: "paint_indicator_width")
        userDefaults().set(gridLineColor, forKey: "grid_line_color")
        userDefaults().set(promptBack, forKey: "prompt_back")
        userDefaults().set(canvasLockBorder, forKey: "canvas_lock_border")
        userDefaults().set(canvasLockColor, forKey: "canvas_lock_color")
        userDefaults().set(showPaintBar, forKey: "show_paint_bar")
        userDefaults().set(showPaintCircle, forKey: "show_paint_circle")
        userDefaults().set(paintIndicatorColor, forKey: "paint_indicator_color")
    }
    
    func quickSave() {
        userDefaults().set(uniqueId, forKey: "installation_id")
        userDefaults().set(sentUniqueId, forKey: "sent_unique_id")
        userDefaults().set(googleAuth, forKey: "google_auth")
        userDefaults().set(dropsAmt, forKey: "drops_amt")
        userDefaults().set(paintColor, forKey: "paint_color")
        userDefaults().set(backgroundColorIndex, forKey: "background_color")
        userDefaults().set(showGridLines, forKey: "show_grid_lines")
    }
    
    func load() {
        uniqueId = userDefaultsString(forKey: "installation_id", defaultVal: UUID().uuidString)
        
        sentUniqueId = userDefaultsBool(forKey: "sent_unique_id", defaultVal: false)
        
        paintColor = userDefaultsInt32(forKey: "paint_color", defaultVal: Utils.int32FromColorHex(hex: "0xFFFFFFFF"))
        
        darkIcons = userDefaultsBool(forKey: "dark_icons", defaultVal: false)
        
        backgroundColorIndex = userDefaultsInt(forKey: "background_color", defaultVal: 0)
        
        numRecentColors = userDefaultsInt(forKey: "num_recent_colors", defaultVal: 16)
        
        xp = userDefaultsInt(forKey: "xp", defaultVal: 0)
        
        displayName = userDefaultsString(forKey: "display_name", defaultVal: "")
        
        artShowcase = loadArtShowcase(jsonStr: userDefaultsString(forKey: "art_showcase_json", defaultVal: ""))
        
        googleAuth = userDefaultsBool(forKey: "google_auth", defaultVal: false)
        
        panelBackgroundName = userDefaultsString(forKey: "panel_background", defaultVal: "amb_15.jpg")
        
        showGridLines = userDefaultsBool(forKey: "show_grid_lines", defaultVal: true)
        
        paintIndicatorFill = userDefaultsBool(forKey: "paint_indicator_fill", defaultVal: false)
        
        paintIndicatorSquare = userDefaultsBool(forKey: "paint_indicator_square", defaultVal: true)
        
        paintIndicatorOutline = userDefaultsBool(forKey: "paint_indicator_outline", defaultVal: false)
        
        paintIndicatorWidth = userDefaultsInt(forKey: "paint_indicator_width", defaultVal: 3)
        
        gridLineColor = userDefaultsInt32(forKey: "grid_line_color", defaultVal: 0)
        
        promptBack = userDefaultsBool(forKey: "prompt_back", defaultVal: false)
        
        canvasLockBorder = userDefaultsBool(forKey: "canvas_lock_border", defaultVal: false)
        
        canvasLockColor = userDefaultsInt32(forKey: "canvas_lock_color", defaultVal: Utils.int32FromColorHex(hex: "0x66FF0000"))
        
        showPaintBar = userDefaultsBool(forKey: "show_paint_bar", defaultVal: true)
        
        showPaintCircle = userDefaultsBool(forKey: "show_paint_circle", defaultVal: false)
        
        paintIndicatorColor = userDefaultsInt32(forKey: "paint_indicator_color", defaultVal: Utils.int32FromColorHex(hex: "0xff999999"))
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
    
    func addShortTermPixels(pixels: [InteractiveCanvas.ShortTermPixel]) {
        for pixel in pixels {
            shortTermPixels.append(pixel)
        }
    }
    
    func updateShortTermPixels() {
        shortTermPixels.removeAll(where: {
            Date().timeIntervalSince1970 - $0.time > 60 * 2
        })
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
    
    func defaultArtShowcase() {
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "leaf_json")!)
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "water_drop_json")!)
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "doughnut_json")!)
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "bird_json")!)
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "rainbow_badge")!)
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "hfs_json")!)
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "paint_bucket_json")!)
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "fire_badge_json")!)
        SessionSettings.instance.addToShowcase(art: ArtView.artFromJsonFile(named: "fries_json")!)
    }
}
