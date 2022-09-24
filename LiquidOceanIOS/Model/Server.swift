//
//  Server.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 8/6/22.
//  Copyright © 2022 Eric Versteeg. All rights reserved.
//

import Foundation

class Server: NSObject {
    
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
    
    func serviceUrl() -> String {
        return "\(baseUrl):5000/"
    }
    
    func socketUrl() -> String {
        return "\(baseUrl):5010/"
    }
    
    func queueSocketUrl() -> String {
        return "\(baseUrl):5020/"
    }
    
    func serviceAltUrl() -> String {
        return "\(baseUrl):5030/"
    }
    
    func toDictionary() -> [String: Any] {
        var jsonObj = [String: Any]()
        
        jsonObj["name"] = name
        jsonObj["color"] = color
        jsonObj["base_url"] = baseUrl
        jsonObj["pixel_interval"] = pixelInterval
        jsonObj["max_pixels"] = maxPixels
        jsonObj["access_key"] = accessKey
        jsonObj["admin_key"] = adminKey
        jsonObj["is_admin"] = isAdmin
        jsonObj["uuid"] = uuid
        
        return jsonObj
    }
}
