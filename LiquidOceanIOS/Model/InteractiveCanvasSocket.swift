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
    func notifySocketDisconnect()
    func notifySocketConnectionError()
}

protocol InteractiveCanvasSocketLatencyDelegate: AnyObject {
    func notifyLatency()
    func notifyConnectionCount()
}

class InteractiveCanvasSocket: NSObject, URLSessionDelegate {
    
    static let instance = InteractiveCanvasSocket()
    
    weak var socketConnectionDelegate: InteractiveCanvasSocketConnectionDelegate?
    weak var latencyDelegate: InteractiveCanvasSocketLatencyDelegate?
    
    var manager: SocketManager!
    var socket: SocketIOClient? = nil
    
    private var latencyTask: Task<(), any Error>? = nil
    var lastPingTime = 0.0
    
    var latency = -1
    var connectionCount = 0
    
    func startSocket(server: Server) {
        // socket init
        //manager = SocketManager(socketURL: URL(string: "https://192.168.200.69:5010")!, config: [.log(true), .compress, .selfSigned(true), .sessionDelegate(self)])
        
        manager = SocketManager(socketURL: URL(string: server.socketUrl())!, config: [.log(true), .reconnectAttempts(3)])
        
        socket = manager.defaultSocket
        
        socket?.connect()
        
        socket?.on(clientEvent: .connect) { (data, ack) in
            print(data)
            self.socket?.emit("connect2")
            self.startLatencyTask()
            self.socketConnectionDelegate?.notifySocketConnect()
        }
        
        socket?.on(clientEvent: .disconnect) { (data, ack) in
            print(data)
            
            DispatchQueue.main.async {
                self.socketConnectionDelegate?.notifySocketDisconnect()
            }
        }
        
        socket?.on(clientEvent: .error) { (data, ack) in
            print(data)
            
            DispatchQueue.main.async {
                self.socketConnectionDelegate?.notifySocketConnectionError()
            }
        }
        
        socket?.on("res") { (data, ack) in
            let latency = Int(1000 * (NSDate().timeIntervalSince1970 - self.lastPingTime))
            self.latency = latency
            self.latencyDelegate?.notifyLatency()
            print("latency check: got latency \(latency)")
        }
        
        socket?.on("cnt") { (data, ack) in
            let count = data[0] as! Int
            self.connectionCount = count
            self.latencyDelegate?.notifyConnectionCount()
            print("latency check: get connection count \(count)")
        }
    }
    
    func disconnect() {
        self.socketConnectionDelegate = nil
        socket?.disconnect()
    }
    
    func startLatencyTask() {
        if self.latencyTask != nil {
            return
        }
        
        self.latencyTask = Task {
            while !Task.isCancelled {
                print("Sending latency check")
                InteractiveCanvasSocket.instance.socket?.emit("lat")
                InteractiveCanvasSocket.instance.socket?.emit("con")
                self.lastPingTime = NSDate().timeIntervalSince1970
                try await Task.sleep(for: .seconds(15))
            }
        }
    }
    
    func cancelLatencyTask() {
        self.latencyTask?.cancel()
        self.latencyTask = nil
    }
    
    /*func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }*/
}
