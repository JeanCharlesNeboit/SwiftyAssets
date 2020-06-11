//
//  ImageSet.swift
//  Basic
//
//  Created by Jean-Charles Neboit on 15/04/2020.
//

import Foundation

struct ImageSet {
    let name: String
    let width: Int?
    let height: Int?
    
    init?(name: String, width: String?, height: String?) throws {
        guard width?.notEmptyOrNil != nil || height?.notEmptyOrNil != nil else {
            throw ImagesParserError.noDimensions
        }
        
        guard width?.isNumeric == true || width?.notEmptyOrNil == nil,
            height?.isNumeric == true || height?.notEmptyOrNil == nil else {
            throw ImagesParserError.badDimensions
        }

        let _width = Int(width ?? "") ?? nil
        let _height = Int(height ?? "") ?? nil
        
        self.name = name
        self.width = _width
        self.height = _height
    }
    
    func name(with scale: Scale) -> String {
        return "\(name)@\(scale.name)"
    }
    
    func json(ext: String) -> [String] {
        var lines: [String] = ["\(String(repeating: "\t", count: 1))\"images\" : ["]
        
        for (i, scale) in ImageSet.Scale.allCases.enumerated() {
            lines.append("\(String(repeating: "\t", count: 2)){")
            lines.append("\(String(repeating: "\t", count: 3))\"filename\" : \"\(name(with: scale)).\(ext)\",")
            lines.append("\(String(repeating: "\t", count: 3))\"idiom\" : \"universal\",")
            lines.append("\(String(repeating: "\t", count: 3))\"scale\" : \"\(scale.name)\"")
            
            if i != ImageSet.Scale.allCases.count - 1 {
                lines.append("\(String(repeating: "\t", count: 2))},")
            } else {
                lines.append("\(String(repeating: "\t", count: 2))}")
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
