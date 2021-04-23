//
//  ImageSet.swift
//  Basic
//
//  Created by Jean-Charles Neboit on 15/04/2020.
//

import Foundation

enum ImageRenderingFormat: String {
    case png
    case svg
    
    var fileExtension: Extension {
        switch self {
        case .png:
            return .png
        case .svg:
            return .svg
        }
    }
}

struct ImageSet {
    // MARK: - Properties
    let name: String
    private(set) var format: ImageRenderingFormat = .png
    private(set) var width: Int?
    private(set) var height: Int?
    
    var isSingleScale: Bool {
        format == .svg
    }
    
    // MARK: - Initialization
    init(name: String, format formatString: String?, width: Int?, height: Int?) throws {
        if let rawValue = formatString,
           let format = ImageRenderingFormat(rawValue: rawValue) {
            self.format = format
        }
        
        if format == .png,
            width == nil && height == nil {
            throw ImagesParserError.noDimensions(key: name)
        }
        
        if let width = width,
           width <= 0 {
            throw ImagesParserError.badDimensions
        }
        
        if let height = height,
           height <= 0 {
            throw ImagesParserError.badDimensions
        }
        
        self.name = name
        self.width = width
        self.height = height
    }
    
    // MARK: -
    func formattedName(with scale: Scale? = nil) -> String {
        guard let scale = scale else { return name }
        return "\(name)@\(scale.name)"
    }
    
    func json(ext: String) -> [String] {
        var lines: [String] = ["\(String(repeating: "\t", count: 1))\"images\" : ["]
        
        if isSingleScale {
            lines.append("\(String(repeating: "\t", count: 2)){")
            lines.append("\(String(repeating: "\t", count: 3))\"filename\" : \"\(name)\(ext)\",")
            lines.append("\(String(repeating: "\t", count: 3))\"idiom\" : \"universal\"")
            lines.append("\(String(repeating: "\t", count: 2))}")
        } else {
            for (i, scale) in ImageSet.Scale.allCases.enumerated() {
                lines.append("\(String(repeating: "\t", count: 2)){")
                lines.append("\(String(repeating: "\t", count: 3))\"filename\" : \"\(formattedName(with: scale))\(ext)\",")
                lines.append("\(String(repeating: "\t", count: 3))\"idiom\" : \"universal\",")
                lines.append("\(String(repeating: "\t", count: 3))\"scale\" : \"\(scale.name)\"")
                
                if i != ImageSet.Scale.allCases.count - 1 {
                    lines.append("\(String(repeating: "\t", count: 2))},")
                } else {
                    lines.append("\(String(repeating: "\t", count: 2))}")
                }
            }
        }
    
        lines.append("\(String(repeating: "\t", count: 1))]")
        return lines
    }
}

extension ImageSet {
    enum Scale: CaseIterable {
        case x1
        case x2
        case x3
        
        var name: String {
            switch self {
            case .x1:
                return "1x"
            case .x2:
                return "2x"
            case .x3:
                return "3x"
            }
        }
        
        var multiplier: Int {
            switch self {
            case .x1:
                return 1
            case .x2:
                return 2
            case .x3:
                return 3
            }
        }
    }
}
