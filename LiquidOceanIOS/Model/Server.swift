//
//  Server.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 8/6/22.
//  Copyright © 2022 Eric Versteeg. All rights reserved.
//

import Foundation

class Server: NSObject {
    
    var uid = 0
    var name = ""
    var color: Int32 = 0
    var baseUrl = ""
    var iconUrl = ""
    var iconLink = ""
    var showBanner = false
    var bannerText = ""
    var pixelInterval = 0
    var maxPixels = 0
    var accessKey = ""
    var adminKey = ""
    var isAdmin = false
    var uuid = ""
    var apiPort = 0
    var altPort = 0
    var socketPort = 0
    var queuePort = 0
    
    func serviceUrl() -> String {
        return "\(baseUrl):\(apiPort)/"
    }
    
    func socketUrl() -> String {
        return "\(baseUrl):\(socketPort)/"
    }
    
    func queueSocketUrl() -> String {
        return "\(baseUrl):\(queuePort)/"
    }
    
    func serviceAltUrl() -> String {
        return "\(baseUrl):\(altPort)/"
    }
    
    func toDictionary() -> [String: Any] {
        var jsonObj = [String: Any]()
        
        jsonObj["id"] = uid
        jsonObj["name"] = name
        jsonObj["color"] = color
        jsonObj["base_url"] = baseUrl
        jsonObj["pixel_interval"] = pixelInterval
        jsonObj["max_pixels"] = maxPixels
        jsonObj["access_key"] = accessKey
        jsonObj["admin_key"] = adminKey
        jsonObj["is_admin"] = isAdmin
        jsonObj["uuid"] = uuid
        jsonObj["api_port"] = apiPort
        jsonObj["alt_port"] = altPort
        jsonObj["socket_port"] = socketPort
        jsonObj["queue_port"] = queuePort
        
        return jsonObj
    }
}
