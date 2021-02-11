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
    
    func downloadCanvasPixels() {
        
        var request = URLRequest(url: URL(string: "https://192.168.200.69:5000/api/v1/canvas/pixels")!)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        request.httpMethod = "GET"

        // var params = ["username":"username", "password":"password"] as Dictionary<String, String>

        // request.HTTPBody = try? JSONSerialization.dataWithJSONObject(params, options: [])

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            
            SessionSettings.instance.userDefaults().set(data, forKey: "arr")
        })

        task.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }

    /*func URLSession(session: URLSession, didReceiveChallenge challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }*/
}
