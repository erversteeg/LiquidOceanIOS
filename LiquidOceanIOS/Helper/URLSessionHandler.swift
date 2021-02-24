//
//  AlamofireManager.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 2/10/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import Foundation
import CFNetwork

class URLSessionHandler: NSObject, URLSessionTaskDelegate {

    static let instance = URLSessionHandler()
    
    func downloadCanvasPixels(completionHandler: @escaping (Bool) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/canvas/pixels")!)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "GET"

        // var params = ["username":"username", "password":"password"] as Dictionary<String, String>

        // request.HTTPBody = try? JSONSerialization.dataWithJSONObject(params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            SessionSettings.instance.userDefaults().set(String(data: data!, encoding: .utf8), forKey: "arr")
            
            DispatchQueue.main.async {
                completionHandler(true)
            }
        })

        task.resume()
    }
    
    func sendDeviceId(completionHandler: @escaping (Bool) -> (Void)) {
        let uniqueId = SessionSettings.instance.uniqueId!
        
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/devices/register")!)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "POST"

        let params = ["uuid": uniqueId] as Dictionary<String, String>

        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            
                SessionSettings.instance.dropsAmt = jsonDict["paint_qty"] as? Int
                SessionSettings.instance.sentUniqueId = true
                
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
            catch {
                
            }
        })

        task.resume()
    }
    
    func sendDeviceStat(eventType: StatTracker.EventType, amt: Int, completionHandler: @escaping (Bool) -> (Void)) {
        let uniqueId = SessionSettings.instance.uniqueId!
        
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/devices/" + uniqueId)!)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "POST"

        var params = [String: Int]()

        var key = ""
        
        switch eventType {
            case .pixelPaintedWorld:
                key = "wt"
            case .pixelPaintedSingle:
                key = "st"
            case .paintReceived:
                key = "tp"
            case .pixelOverwriteIn:
                key = "oi"
            case .pixelOverwriteOut:
                key = "oo"
            default:
                key = ""
        }
        
        params[key] = amt
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let _ = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            
                if error != nil {
                    print("Error updating stat.")
                }
                else {
                    print(key + " updated.")
                }
                
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
            catch {
                
            }
        })

        task.resume()
    }
    
    func getDeviceInfo(completionHandler: @escaping (Bool) -> (Void)) {
        let uniqueId = SessionSettings.instance.uniqueId!
        
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/devices/" + uniqueId + "/info")!)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "GET"

        // let params = ["uuid": uniqueId] as Dictionary<String, String>

        // request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            
                SessionSettings.instance.sentUniqueId = true
                
                SessionSettings.instance.dropsAmt = jsonDict["paint_qty"] as? Int
                SessionSettings.instance.xp = jsonDict["xp"] as! Int
                SessionSettings.instance.displayName = jsonDict["name"] as! String
                
                let pixelsWorld = jsonDict["wt"] as! Int
                let pixelsSingle = jsonDict["st"] as! Int
                let paintReceived = jsonDict["tp"] as! Int
                let overwritesIn = jsonDict["oi"] as! Int
                let overwritesOut = jsonDict["oo"] as! Int
                
                DispatchQueue.main.async {
                    StatTracker.instance.syncStatFromServer(eventType: .pixelPaintedWorld, total: pixelsWorld)
                    StatTracker.instance.syncStatFromServer(eventType: .pixelPaintedSingle, total: pixelsSingle)
                    StatTracker.instance.syncStatFromServer(eventType: .paintReceived, total: paintReceived)
                    StatTracker.instance.syncStatFromServer(eventType: .pixelOverwriteIn, total: overwritesIn)
                    StatTracker.instance.syncStatFromServer(eventType: .pixelOverwriteOut, total: overwritesOut)
                    
                    StatTracker.instance.save()
                    
                    completionHandler(true)
                }
            }
            catch {
                
            }
        })

        task.resume()
    }
    
    func sendApiStatusCheck(completionHandler: @escaping (Bool) -> (Void)) {
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/status")!)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "GET"

        // let params = ["uuid": uniqueId] as Dictionary<String, String>

        // request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                if error != nil || response == nil {
                    DispatchQueue.main.async {
                        completionHandler(false)
                        return
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completionHandler(true)
                    }
                }
                
                // let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                
                
            }
            catch {
                
            }
        })

        task.resume()
    }
    
    func getPaintTimerInfo(completionHandler: @escaping (Bool, Double) -> (Void)) {
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/paint/time/sync")!)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "GET"

        // let params = ["uuid": uniqueId] as Dictionary<String, String>

        // request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                if error != nil || response == nil {
                    DispatchQueue.main.async {
                        completionHandler(false, 0)
                        return
                    }
                }
                else {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    
                    DispatchQueue.main.async {
                        completionHandler(true, jsonDict["s"] as! Double)
                    }
                }
                
            }
            catch {
                
            }
        })

        task.resume()
    }
    
    func sendGoogleToken(token: String, completionHandler: @escaping (Bool) -> (Void)) {
        let uniqueId = SessionSettings.instance.uniqueId!
        
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/devices/" + uniqueId + "/google/auth")!)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "POST"

        let params = ["token_id": token] as Dictionary<String, String>

        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                if error != nil {
                    DispatchQueue.main.async {
                        completionHandler(false)
                    }
                }
                
                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                
                SessionSettings.instance.sentUniqueId = true
                
                SessionSettings.instance.dropsAmt = jsonDict["paint_qty"] as? Int
                SessionSettings.instance.xp = jsonDict["xp"] as! Int
                SessionSettings.instance.displayName = jsonDict["name"] as! String
                
                SessionSettings.instance.googleAuth = true
                SessionSettings.instance.uniqueId = token
                
                SessionSettings.instance.save()
                
                let pixelsWorld = jsonDict["wt"] as! Int
                let pixelsSingle = jsonDict["st"] as! Int
                let paintReceived = jsonDict["tp"] as! Int
                let overwritesIn = jsonDict["oi"] as! Int
                let overwritesOut = jsonDict["oo"] as! Int
                
                DispatchQueue.main.async {
                    StatTracker.instance.syncStatFromServer(eventType: .pixelPaintedWorld, total: pixelsWorld)
                    StatTracker.instance.syncStatFromServer(eventType: .pixelPaintedSingle, total: pixelsSingle)
                    StatTracker.instance.syncStatFromServer(eventType: .paintReceived, total: paintReceived)
                    StatTracker.instance.syncStatFromServer(eventType: .pixelOverwriteIn, total: overwritesIn)
                    StatTracker.instance.syncStatFromServer(eventType: .pixelOverwriteOut, total: overwritesOut)
                    
                    StatTracker.instance.save()
                    
                    completionHandler(true)
                }
            }
            catch {
                
            }
        })

        task.resume()
    }
    
    func downloadPixelHistory(pixelId: Int, completionHandler: @escaping (Bool, [AnyObject]) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/canvas/pixels/" + String(pixelId) + "/history")!)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "GET"

        // var params = ["username":"username", "password":"password"] as Dictionary<String, String>

        // request.HTTPBody = try? JSONSerialization.dataWithJSONObject(params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                
                DispatchQueue.main.async {
                    completionHandler(true, jsonDict["data"] as! [AnyObject])
                }
            }
            catch {
                
            }
        })

        task.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
