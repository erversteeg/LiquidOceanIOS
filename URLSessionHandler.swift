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
                
                DispatchQueue.main.async {
                    completionHandler(true)
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
