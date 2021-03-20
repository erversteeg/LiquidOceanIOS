//
//  InteractiveCanvasSocket.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 3/16/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit
import SocketIO

protocol InteractiveCanvasSocketConnectionDelegate: AnyObject {
    func notifySocketConnect()
    func notifySocketConnectionError()
}

class InteractiveCanvasSocket: NSObject, URLSessionDelegate {
    
    static let instance = InteractiveCanvasSocket()
    
    weak var socketStatusDelegate: InteractiveCanvasSocketStatusDelegate?
    weak var socketConnectionDelegate: InteractiveCanvasSocketConnectionDelegate?
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    var checkStatusReceived = false
    var checkEventTimeout = 20.0
    
    func startSocket() {
        // socket init
        //manager = SocketManager(socketURL: URL(string: "https://192.168.200.69:5010")!, config: [.log(true), .compress, .selfSigned(true), .sessionDelegate(self)])
        
        manager = SocketManager(socketURL: URL(string: "https://ericversteeg.com:5010")!, config: [.log(true), .reconnectAttempts(3)])
        
        socket = manager.defaultSocket
        
        socket.connect()
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print(data)
            self.socketConnectionDelegate?.notifySocketConnect()
        }
        
        socket.on(clientEvent: .disconnect) { (data, ack) in
            print(data)
        }
        
        socket.on(clientEvent: .error) { (data, ack) in
            print(data)
            
            DispatchQueue.main.async {
                self.socketConnectionDelegate?.notifySocketConnectionError()
            }
        }
        
        socket.on("check_success") { (data, ack) in
            self.checkStatusReceived = true
        }
    }
    
    func sendSocketStatusCheck() {
        socket.emit("check_event")
        
        self.checkStatusReceived = false
        Timer.scheduledTimer(withTimeInterval: checkEventTimeout, repeats: false) { (tmr) in
            if !self.checkStatusReceived {
                self.socketStatusDelegate?.notifySocketError()
            }
        }
    }
    
    /*func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }*/
}
