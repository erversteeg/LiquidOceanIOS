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
            
                SessionSettings.instance.dropsAmt = jsonDict["paint_qty"] as? Int
                SessionSettings.instance.sentUniqueId = true
                
                SessionSettings.instance.xp = jsonDict["xp"] as! Int
                SessionSettings.instance.displayName = jsonDict["name"] as! String
                
                StatTracker.instance.numPixelsPaintedWorld = jsonDict["wt"] as! Int
                StatTracker.instance.numPixelsPaintedSingle = jsonDict["st"] as! Int
                
                let paintReceived = jsonDict["st"] as! Int
                let overwritesIn = jsonDict["oi"] as! Int
                let overwritesOut = jsonDict["oo"] as! Int
                
                DispatchQueue.main.async {
                    StatTracker.instance.reportEvent(eventType: .paintReceived, amt: 10000)
                    StatTracker.instance.reportEvent(eventType: .pixelOverwriteIn, amt: 2000)
                    StatTracker.instance.reportEvent(eventType: .pixelOverwriteOut, amt: 2000)
                    
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
