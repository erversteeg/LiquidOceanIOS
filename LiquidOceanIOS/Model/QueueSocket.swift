//
//  QueueSocket.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 7/31/22.
//  Copyright © 2022 Eric Versteeg. All rights reserved.
//

import UIKit
import SocketIO

protocol QueueSocketDelegate: AnyObject {
    func notifyQueueConnect()
    func notifyQueueConnectError()
    func notifyAddedToQueue(pos: Int)
    func notifyServiceReady()
}

class QueueSocket: NSObject, URLSessionDelegate {
    
    static let instance = QueueSocket()
    
    weak var queueSocketDelegate: QueueSocketDelegate?
    
    let interval = 10
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    func startSocket() {
        // socket init
        //manager = SocketManager(socketURL: URL(string: "https://192.168.200.69:5010")!, config: [.log(true), .compress, .selfSigned(true), .sessionDelegate(self)])
        
        manager = SocketManager(socketURL: URL(string: "https://ericversteeg.com:5020")!, config: [.log(true), .reconnectAttempts(0)])
        
        socket = manager.defaultSocket
        
        socket.connect()
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print(data)
            self.socket.emit("add_to_queue", self.socket.sid!, completion: nil)
            self.queueSocketDelegate?.notifyQueueConnect()
        }
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print(data)
        }
        
        socket.on(clientEvent: .error) { (data, ack) in
            print(data)
            self.socket.disconnect()
            self.queueSocketDelegate?.notifyQueueConnectError()
        }
        
        socket.on("added_to_queue") { (data, ack) in
            print("Added to queue.")
            self.queueSocketDelegate?.notifyAddedToQueue(pos: data[0] as! Int)
        }
        
        socket.on("service_ready") { (data, ack) in
            print("Service ready!")
            
            if !((data[0] as! [String: Any])["start"] as! Bool) {
                return
            }
            
            self.queueSocketDelegate?.notifyServiceReady()
        }
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    /*func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }*/
}


