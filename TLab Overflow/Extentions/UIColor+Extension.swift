//
//  UIColor+Extension.swift
//  Bali United
//
//  Created by Rifat Firdaus on 1/12/17.
//  Copyright © 2017 Suitmedia. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0x0000FF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            //            let hexColor = hexString.substring(from: start) //deprecated
            let hexColor = hexString[..<start]
            if hexColor.count == 6 || hexColor.count == 8 {
                let scanner = Scanner(string: String(hexColor))
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    if hexColor.count == 6 {
                        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                        b = CGFloat((hexNumber & 0x0000ff)) / 255
                        a = CGFloat(1.0)
                    } else {
                        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                        a = CGFloat(hexNumber & 0x000000ff) / 255
                    }
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    class var smBackgroundPrimary: UIColor { return UIColor(red: 246, green: 248, blue: 250) }
    class var smBackgroundSecondary: UIColor { return UIColor.white }
    
    static func primary(alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: 244, green: 67, blue: 54) //Red
    }
    static func primaryLow(alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: 239, green: 83, blue: 80) //rgb(239,83,80)
    }
    
    static func accent(alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: 158, green: 158, blue: 158) //Dark tangerine
    }
    
    static func mantis(alpha: CGFloat = 1) -> UIColor {
        return UIColor(hex: 0xfcb61e, alpha: alpha)
    }
    
    static func mediumJungleGreen() -> UIColor { //background
        return UIColor(hex: 0x2a2a2a)
    }
    
    static func white(alpha: CGFloat = 1) -> UIColor {
        return UIColor(hex: 0xFFFFFF, alpha: alpha)
    }
}
