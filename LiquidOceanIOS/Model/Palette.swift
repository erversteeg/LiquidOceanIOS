//
//  Palette.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 10/29/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class Palette: NSObject {
    static var maxColors = 32
    
    var name: String
    var colors = [Int32]()
    
    var displayName: String {
        get {
            if name.count > 12 {
                return name.prefix(10) + "..."
            }
            else {
                return name
            }
        }
    }
    
    init(name: String) {
        self.name = name
        
        super.init()
    }
    
    func addColor(color: Int32) {
        if !colors.contains(color) {
            colors.append(color)
        }
    }
    
    func removeColor(color: Int32) {
        if colors.contains(color) {
            colors.remove(at: colors.firstIndex(of: color)!)
        }
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        
        dictionary["name"] = name
        dictionary["colors"] = colors
        
        return dictionary
    }
}
