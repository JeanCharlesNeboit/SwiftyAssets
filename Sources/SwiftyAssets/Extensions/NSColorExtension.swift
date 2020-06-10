//
//  NSColorExtension.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import AppKit.NSColor
import Foundation

extension NSColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    var toHex: String? {
        return toHex()
    }
    
    func toHex(withAlpha: Bool = false) -> String? {
        guard let components = cgColor.components else {
            return nil
        }
        
        var r: Float?
        var g: Float?
        var b: Float?
        var a: Float?
        
        if components.count >= 3 {
            r = Float(components[0])
            g = Float(components[1])
            b = Float(components[2])
            a = Float(1.0)
            
            if components.count >= 4 {
                a = Float(components[3])
            }
        } else if components.count >= 1 {
            let gray = Float(components[0])
            r = gray
            g = gray
            b = gray
            
            if components.count >= 2 {
                a = Float(components[1])
            }
        }
        
        guard let red = r, let green = g, let blue = b, let alpha = a else {
            return nil
        }
        
        if withAlpha {
            return String(format: "#%02lx%02lx%02lx%02lx", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255), lroundf(alpha * 255))
        } else {
            return String(format: "#%02lx%02lx%02lx", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
        }
    }
}
