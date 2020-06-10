//
//  ColorSet.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import AppKit.NSColor
import Foundation

struct ColorSet {
    let name: String
    let light: NSColor
    private(set) var dark: NSColor?
    
    init?(name: String, lightHex: String, darkHex: String?) throws {
        guard let light = NSColor(hex: lightHex) else {
            throw ColorParserError.badHexColor
        }
        
        if let darkHex = darkHex {
            guard let dark = NSColor(hex: darkHex) else {
                throw ColorParserError.badHexColor
            }
            
            self.dark = dark
        }
        
        self.name = name
        self.light = light
    }
    
    var json: [String] {
        var lines: [String] = ["\(String(repeating: "\t", count: 1))\"colors\" : ["]
        
        lines.append(contentsOf: colorJson(for: light))
        if let dark = dark {
            lines.appendToLast(newElement: ",")
            lines.append(contentsOf: colorJson(for: dark, appearance: appearances(value: "dark")))
        }
        
        lines.append("\(String(repeating: "\t", count: 1))]")
        return lines
    }
    
    private func appearances(value: String) -> [String] {
        return [
            "\(String(repeating: "\t", count: 3))\"appearances\" : [",
            "\(String(repeating: "\t", count: 4)){",
            "\(String(repeating: "\t", count: 5))\"appearance\" : \"luminosity\",",
            "\(String(repeating: "\t", count: 5))\"value\" : \"\(value)\"",
            "\(String(repeating: "\t", count: 4))}",
            "\(String(repeating: "\t", count: 3))],"
        ]
    }
    
    private func colorJson(for color: NSColor, appearance: [String]? = nil) -> [String] {
        var lines = [
            "\(String(repeating: "\t", count: 2)){",
            "\(String(repeating: "\t", count: 3))\"idiom\" : \"universal\",",
        ]
        
        if let appearance = appearance {
            lines.append(contentsOf: appearance)
        }
        
        lines.append(contentsOf: [
            "\(String(repeating: "\t", count: 3))\"color\" : {",
            "\(String(repeating: "\t", count: 4))\"color-space\" : \"srgb\",",
            "\(String(repeating: "\t", count: 4))\"components\" : {",
            "\(String(repeating: "\t", count: 5))\"red\" : \"\(String(format: "%.2f", color.redComponent))\",",
            "\(String(repeating: "\t", count: 5))\"green\" : \"\(String(format: "%.2f", color.greenComponent))\",",
            "\(String(repeating: "\t", count: 5))\"blue\" : \"\(String(format: "%.2f", color.blueComponent))\",",
            "\(String(repeating: "\t", count: 5))\"alpha\" : \"\(String(format: "%.1f", color.alphaComponent))\"",
            "\(String(repeating: "\t", count: 4))}",
            "\(String(repeating: "\t", count: 3))}",
            "\(String(repeating: "\t", count: 2))}"
        ])
        
        return lines
    }
}
