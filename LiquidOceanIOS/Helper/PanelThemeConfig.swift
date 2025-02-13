//
//  PanelThemeConfig.swift
//  LiquidOceanIOS
//
//  Created by Eric Versteeg on 3/1/21.
//  Copyright © 2021 Eric Versteeg. All rights reserved.
//

import UIKit

class PanelThemeConfig: NSObject {
    
    var darkPaintQtyBar: Bool!
    var inversePaintEventInfo: Bool!
    var paintColorIndicatorLineColor: Int32!
    var actionButtonColor: Int32!
    
    static let panels = ["metal_floor_1.jpg", "metal_floor_2.jpg", "foil.jpg", "rainbow_foil.jpg",
                         "wood_texture_light.jpg", "fall_leaves.png",  "grass.jpg", "amb_6.jpg", "water_texture.jpg",
                         "space_texture.jpg", "crystal_8.jpg", "crystal_10.jpg", "crystal_1.jpg",
    "crystal_2.jpg", "crystal_4.jpg", "crystal_5.jpg", "crystal_6.jpg", "crystal_7.jpg",  "crystal_3.jpg", "amb_2.jpg", "amb_3.jpg", "amb_4.jpg", "amb_5.jpg", "amb_7.jpg", "amb_8.jpg",
    "amb_9.jpg", "amb_10.jpg", "amb_11.jpg", "amb_12.jpg", "amb_13.jpg", "amb_14.jpg", "amb_15.jpg"]
    
    static let panelConfigs = [false, true, false, false, true, true, false, false, false,
                               false, true, true, true, true, true, true, false, false, false,
                               false, true, false, false, false, true, true, false, true, false, true, false, true]
    
    init(darkPaintQtyBar: Bool, inversePaintEventInfo: Bool, paintColorIndicatorLineColor: Int32, actionButtonColor: Int32) {
        super.init()
        
        self.darkPaintQtyBar = darkPaintQtyBar
        self.inversePaintEventInfo = inversePaintEventInfo
        self.paintColorIndicatorLineColor = paintColorIndicatorLineColor
        self.actionButtonColor = actionButtonColor
        
        commonInit()
    }
    
    func commonInit() {
        
    }
    
    static func defaultDarkTheme() -> PanelThemeConfig {
        return PanelThemeConfig(darkPaintQtyBar: true, inversePaintEventInfo: false, paintColorIndicatorLineColor: UIColor.black.argb(), actionButtonColor: UIColor.black.argb())
    }
    
    static func defaultLightTheme() -> PanelThemeConfig {
        return PanelThemeConfig(darkPaintQtyBar: false, inversePaintEventInfo: true, paintColorIndicatorLineColor: UIColor.white.argb(), actionButtonColor: UIColor.white.argb())
    }
    
    static func buildConfig(imageName: String) -> PanelThemeConfig {
        if panels.count == panelConfigs.count {
            let index = panels.firstIndex(of: imageName)!
            if panelConfigs[index] {
                return PanelThemeConfig.defaultDarkTheme()
            }
            else {
                return PanelThemeConfig.defaultLightTheme()
            }
        }
        else {
            return PanelThemeConfig.defaultDarkTheme()
        }
    }
}
