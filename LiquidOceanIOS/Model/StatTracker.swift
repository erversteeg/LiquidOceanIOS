//
//  StatTracker.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/22/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

protocol AchievementListener {
    func notifyDisplayAchievement(nextAchievement: [String: Any], displayInterval: Int)
}

class StatTracker: NSObject {

    static let instance = StatTracker()
    
    enum EventType {
        case pixelPaintedWorld
        case pixelPaintedSingle
        case paintReceived
        case pixelOverwriteOut
        case pixelOverwriteIn
        case worldXp
    }
    
    var timer: Timer!
    var cancelTimer: Timer?
    
    var achievementListener: AchievementListener?
    
    var achievementDisplayInterval = 8
    
    // world
    var worldXp = 0
    
    var totalPaintAccrued = 0
    var totalPaintAccruedKey = "total_paint_accrued"
    
    var _numPixelsPaintedWorld: Int = 0
    var numPixelsPaintedWorld: Int {
        set {
            _numPixelsPaintedWorld = newValue
            worldXp = newValue * 20
        }
        get {
            return _numPixelsPaintedWorld
        }
    }
    var numPixelsPaintedWorldKey = "num_pixels_painted_world"
    
    var numPixelOverwritesOut = 0
    var numPixelOverwritesOutKey = "num_pixel_overwrites_out"
    
    var numPixelOverwritesIn = 0
    var numPixelOverwritesInKey = "num_pixel_overwrites_in"
    
    // single play
    var numPixelsPaintedSingle = 0
    var numPixelsPaintedSingleKey = "num_pixels_painted_single"
    
    // achievement thresholds
    let pixelWorldThresholds = [50, 500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000,
    9000, 10000, 15000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000,
    150000, 200000, 250000, 300000, 350000, 400000, 450000, 500000, 550000, 600000,
    650000, 700000, 750000, 800000, 850000, 900000, 950000, 1000000]
    
    let pixelSingleThresholds = [100, 250, 500, 1000, 1500, 2500, 5000, 10000]
    
    let paintAccruedThresholds = [10000, 50000, 100000, 250000, 500000, 1000000, 5000000]
    
    let overwritesInThresholds = [1, 10, 50, 100, 250, 500, 1000, 5000]
    let overwritesOutThresholds = [1, 10, 50, 100, 250, 500, 1000, 5000, 10000]
    
    let levelThresholds = [5000, 11000, 18000, 28000, 45000, 80000, 115000, 160000, 200000, 245000, 300000, 360000,
    435000, 550000, 675000, 820000, 960000, 1120000, 1300000]
    
    private var achievementQueue = [[String: Any]]()
    
    func reportEvent(eventType: EventType, amt: Int) {
        let numPixelsPaintedWorldOld = numPixelsPaintedWorld
        let numPixelsPaintedSingleOld = numPixelsPaintedSingle
        let totalPaintAccruedOld = totalPaintAccrued
        let numPixelOverwritesInOld = numPixelOverwritesIn
        let numPixelOverwritesOutOld = numPixelOverwritesOut
        
        if eventType == .pixelPaintedWorld {
            numPixelsPaintedWorld += amt
            checkAchievements(eventType: eventType, oldVal: numPixelsPaintedWorldOld, newVal: numPixelsPaintedWorld)
            sendDeviceStats(eventType: eventType, amt: numPixelsPaintedWorld)
        }
        else if eventType == .pixelPaintedSingle {
            numPixelsPaintedSingle += amt
            checkAchievements(eventType: eventType, oldVal: numPixelsPaintedSingleOld, newVal: numPixelsPaintedSingle)
            sendDeviceStats(eventType: eventType, amt: numPixelsPaintedSingle)
        }
        else if eventType == .paintReceived {
            totalPaintAccrued += amt
            checkAchievements(eventType: eventType, oldVal: totalPaintAccruedOld, newVal: totalPaintAccrued)
        }
        else if eventType == .pixelOverwriteIn {
            numPixelOverwritesIn += amt
            checkAchievements(eventType: eventType, oldVal: numPixelOverwritesInOld, newVal: numPixelOverwritesIn)
        }
        else if eventType == .pixelOverwriteOut {
            numPixelOverwritesOut += amt
            checkAchievements(eventType: eventType, oldVal: numPixelOverwritesOutOld, newVal: numPixelOverwritesOut)
        }
    }
    
    func syncStatFromServer(eventType: EventType, total: Int) {
        let numPixelsPaintedWorldOld = numPixelsPaintedWorld
        let numPixelsPaintedSingleOld = numPixelsPaintedSingle
        let totalPaintAccruedOld = totalPaintAccrued
        let numPixelOverwritesInOld = numPixelOverwritesIn
        let numPixelOverwritesOutOld = numPixelOverwritesOut
        
        if eventType == .pixelPaintedWorld {
            numPixelsPaintedWorld = total
            checkAchievements(eventType: eventType, oldVal: numPixelsPaintedWorldOld, newVal: numPixelsPaintedWorld)
        }
        else if eventType == .pixelPaintedSingle {
            numPixelsPaintedSingle = total
            checkAchievements(eventType: eventType, oldVal: numPixelsPaintedSingleOld, newVal: numPixelsPaintedSingle)
        }
        if eventType == .paintReceived {
            totalPaintAccrued = total
            checkAchievements(eventType: eventType, oldVal: totalPaintAccruedOld, newVal: totalPaintAccrued)
        }
        else if eventType == .pixelOverwriteIn {
            numPixelOverwritesIn = total
            checkAchievements(eventType: eventType, oldVal: numPixelOverwritesInOld, newVal: numPixelOverwritesIn)
        }
        else if eventType == .pixelOverwriteOut {
            numPixelOverwritesOut = total
            checkAchievements(eventType: eventType, oldVal: numPixelOverwritesOutOld, newVal: numPixelOverwritesOut)
        }
    }
    
    private func sendDeviceStats(eventType: EventType, amt: Int) {
        URLSessionHandler.instance.sendDeviceStat(eventType: eventType, amt: amt) { (success) -> (Void) in
            if success {
                
            }
        }
    }
    
    private func checkAchievements(eventType: EventType, oldVal: Int, newVal: Int) {
        var thresholdsPassed = 0
        
        if eventType == .pixelPaintedWorld {
            thresholdsPassed = pixelWorldThresholds.count
            for i in pixelWorldThresholds.indices {
                let threshold = pixelWorldThresholds[pixelWorldThresholds.count - 1 - i]
                if threshold > oldVal && threshold <= newVal {
                    enqueueAchievement(eventType: eventType, threshold: threshold, thresholdsPassed: thresholdsPassed)
                    return
                }
                thresholdsPassed -= 1
            }
            
            let oldXp = oldVal * 20
            let newXp = newVal * 20
            
            for i in levelThresholds.indices {
                let threshold = levelThresholds[levelThresholds.count - 1 - i]
                if threshold > oldXp && threshold <= newXp {
                    enqueueAchievement(eventType: .worldXp, threshold: threshold, thresholdsPassed: thresholdsPassed)
                    return
                }
            }
        }
        else if eventType == .pixelPaintedSingle {
            thresholdsPassed = pixelSingleThresholds.count
            for i in pixelSingleThresholds.indices {
                let threshold = pixelSingleThresholds[pixelSingleThresholds.count - 1 - i]
                if threshold > oldVal && threshold <= newVal {
                    enqueueAchievement(eventType: eventType, threshold: threshold, thresholdsPassed: thresholdsPassed)
                    return
                }
                thresholdsPassed -= 1
            }
        }
        else if eventType == .paintReceived {
            thresholdsPassed = paintAccruedThresholds.count
            for i in paintAccruedThresholds.indices {
                let threshold = paintAccruedThresholds[paintAccruedThresholds.count - 1 - i]
                if threshold > oldVal && threshold <= newVal {
                    enqueueAchievement(eventType: eventType, threshold: threshold, thresholdsPassed: thresholdsPassed)
                    return
                }
                thresholdsPassed -= 1
            }
        }
        else if eventType == .pixelOverwriteIn {
            thresholdsPassed = overwritesInThresholds.count
            for i in overwritesInThresholds.indices {
                let threshold = overwritesInThresholds[overwritesInThresholds.count - 1 - i]
                if threshold > oldVal && threshold <= newVal {
                    enqueueAchievement(eventType: eventType, threshold: threshold, thresholdsPassed: thresholdsPassed)
                    return
                }
                thresholdsPassed -= 1
            }
        }
        else if eventType == .pixelOverwriteOut {
            thresholdsPassed = overwritesOutThresholds.count
            for i in overwritesOutThresholds.indices {
                let threshold = overwritesOutThresholds[overwritesOutThresholds.count - 1 - i]
                if threshold > oldVal && threshold <= newVal {
                    enqueueAchievement(eventType: eventType, threshold: threshold, thresholdsPassed: thresholdsPassed)
                    return
                }
                thresholdsPassed -= 1
            }
        }
    }
    
    private func enqueueAchievement(eventType: EventType, threshold: Int, thresholdsPassed: Int) {
        var dict = [String: Any]()
        dict["event_type"] = eventType
        dict["threshold"] = threshold
        dict["thresholds_passed"] = thresholdsPassed
        
        achievementQueue.append(dict)
        
        if achievementListener != nil && achievementQueue.count == 1 {
            displayAchievements()
        }
    }
    
    func displayAchievements() {
        if achievementQueue.count > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: Double(achievementDisplayInterval), repeats: true) { (tmr) in
                DispatchQueue.main.async {
                    print("Queue size is " + String(self.achievementQueue.count))
                    
                    let nextAchievement = self.achievementQueue.remove(at: 0)
                    
                    if self.achievementQueue.count == 0 {
                        self.cancelTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (tmr) in
                            self.timer.invalidate()
                        }
                    }
                    else {
                        self.cancelTimer?.invalidate()
                    }
                    
                    self.achievementListener?.notifyDisplayAchievement(nextAchievement: nextAchievement, displayInterval: self.achievementDisplayInterval)
                }
            }
            timer.fire()
        }
    }
    
    func getAchievementProgressString(eventType: EventType) -> String {
        switch eventType {
            case .pixelPaintedSingle:
                return thresholdsPassedString(progress: numPixelsPaintedSingle, thresholds: pixelSingleThresholds)
            case .pixelPaintedWorld:
                return thresholdsPassedString(progress: numPixelsPaintedWorld, thresholds: pixelWorldThresholds)
            case .pixelOverwriteIn:
                return thresholdsPassedString(progress: numPixelOverwritesIn, thresholds: overwritesInThresholds)
            case .pixelOverwriteOut:
                return thresholdsPassedString(progress: numPixelOverwritesOut, thresholds: overwritesOutThresholds)
            case .paintReceived:
                return thresholdsPassedString(progress: totalPaintAccrued, thresholds: paintAccruedThresholds)
            default:
                return ""
        }
    }
    
    func thresholdsPassed(eventType: EventType) -> Int {
        switch eventType {
            case .pixelPaintedSingle:
                return thresholdsPassed(progress: numPixelsPaintedSingle, thresholds: pixelSingleThresholds)
            case .pixelPaintedWorld:
                return thresholdsPassed(progress: numPixelsPaintedWorld, thresholds: pixelWorldThresholds)
            case .pixelOverwriteIn:
                return thresholdsPassed(progress: numPixelOverwritesIn, thresholds: overwritesInThresholds)
            case .pixelOverwriteOut:
                return thresholdsPassed(progress: numPixelOverwritesOut, thresholds: overwritesOutThresholds)
            case .paintReceived:
                return thresholdsPassed(progress: totalPaintAccrued, thresholds: paintAccruedThresholds)
            default:
                return 0
        }
    }
    
    func load() {
        totalPaintAccrued = SessionSettings.instance.userDefaultsInt(forKey: totalPaintAccruedKey, defaultVal: 0)
        numPixelsPaintedWorld = SessionSettings.instance.userDefaultsInt(forKey: numPixelsPaintedWorldKey, defaultVal: 0)
        numPixelsPaintedSingle = SessionSettings.instance.userDefaultsInt(forKey: numPixelsPaintedSingleKey, defaultVal: 0)
        numPixelOverwritesIn = SessionSettings.instance.userDefaultsInt(forKey: numPixelOverwritesInKey, defaultVal: 0)
        numPixelOverwritesOut = SessionSettings.instance.userDefaultsInt(forKey: numPixelOverwritesOutKey, defaultVal: 0)
    }
    
    func save() {
        SessionSettings.instance.userDefaults().set(totalPaintAccrued, forKey: totalPaintAccruedKey)
        SessionSettings.instance.userDefaults().set(numPixelsPaintedSingle, forKey: numPixelsPaintedSingleKey)
        SessionSettings.instance.userDefaults().set(numPixelsPaintedWorld, forKey: numPixelsPaintedWorldKey)
        SessionSettings.instance.userDefaults().set(numPixelOverwritesIn, forKey: numPixelOverwritesInKey)
        SessionSettings.instance.userDefaults().set(numPixelOverwritesOut, forKey: numPixelOverwritesOutKey)
    }
    
    func thresholdsPassedString(progress: Int, thresholds: [Int]) -> String {
        var count = 0
        for i in thresholds.indices {
            let threshold = thresholds[i]
            if threshold > progress {
                return String(count) +  " / " + String(thresholds.count)
            }
            count += 1
        }
        return String(thresholds.count) +  " / " + String(thresholds.count)
    }
    
    func thresholdsPassed(progress: Int, thresholds: [Int]) -> Int {
        var count = 0
        for i in thresholds.indices {
            let threshold = thresholds[i]
            if threshold > progress {
                return count
            }
            count += 1
        }
        return thresholds.count
    }
    
    func getWorldLevel() -> Int {
        var count = 0
        for i in levelThresholds.indices {
            let threshold = levelThresholds[i]
            if threshold > worldXp {
                return count + 1
            }
            count += 1
        }
        return levelThresholds.count + 1
    }
}
