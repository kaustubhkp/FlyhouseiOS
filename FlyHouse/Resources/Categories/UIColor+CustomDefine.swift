//
//  UIColor+CustomDefine.swift
//  FlyHouse
//
//  Created by Kaustubh Patil on 27/01/23.
//

import UIKit

let blackColorCode          = "000000"
let THEME_COLOR_LIGHT        = "282A2A"
let THEME_COLOR_BG          = "EAE5E0"
let navigationBarColor      = THEME_COLOR_BG
let whiteColorCode          = "FFFFFF"
let lightGrayColorCode      = "C6C6C6"
let viewBGColorCode         = whiteColorCode
let placeHolderColorCode    = "A39689"
let currenDoteColorCode     = "FF506F"
let buttonBGColor           = whiteColorCode
let INPUTF_BORDER_COLOR     = "CEC6BC"
let INPUT_VIEW_BG_COLOR     = "F1ECE7"
let ThemeBorderColor        = "2F2F2F"
let THEME_COLOR_BLIGHT      = "1A1A1A"
let THEME_COLOR_BORDER_GREEN = "46974D"
let THEME_COLOR_BORDER_COLOR = "929292"

extension UIColor {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
        
        //cString.substring(from: cString.startIndex.advancedBy(1))
        if (cString.hasPrefix("#")) {
            cString = cString.replacingOccurrences(of: "#", with: "")
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /* Usage:
     * var color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
     * var color2 = UIColor(netHex:0xFFFFFF)
    */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func hexStringToUIColorWithAlpha (hex:String,alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
        
        //cString.substring(from: cString.startIndex.advancedBy(1))
        if (cString.hasPrefix("#")) {
            cString = cString.replacingOccurrences(of: "#", with: "")
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
