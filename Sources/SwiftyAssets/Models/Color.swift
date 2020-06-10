//
//  ColorSet.swift
//  SwiftyAssets
//
//  Created by Jean-Charles Neboit on 08/02/2020.
//

import Foundation

struct ColorSet {
    let name: String
    let lightHex: String
    let darkHex: String?
    
    var json: [String] {
        var lines: [String] = ["\(String(repeating: "\t", count: 1))\"colors\" : ["]
        
        lines.append(contentsOf: colorJson(for: lightHex))
        if let dark = darkHex {
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
    
    private func colorJson(for hex: String, appearance: [String]? = nil) -> [String] {
        guard let color = SRGBColor(hex: hex) else {
            return []
        }
        
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
            "\(String(repeating: "\t", count: 5))\"red\" : \"\(String(format: "%.2f", color.red))\",",
            "\(String(repeating: "\t", count: 5))\"green\" : \"\(String(format: "%.2f", color.green))\",",
            "\(String(repeating: "\t", count: 5))\"blue\" : \"\(String(format: "%.2f", color.blue))\",",
            "\(String(repeating: "\t", count: 5))\"alpha\" : \"\(String(format: "%.1f", color.alpha))\"",
            "\(String(repeating: "\t", count: 4))}",
            "\(String(repeating: "\t", count: 3))}",
            "\(String(repeating: "\t", count: 2))}"
        ])
        
        return lines
    }
}
