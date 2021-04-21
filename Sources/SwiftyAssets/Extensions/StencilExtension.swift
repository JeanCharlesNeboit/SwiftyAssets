//
//  StencilExtension.swift
//  
//
//  Created by Jean-Charles Neboit on 18/03/2021.
//

import Stencil

public extension Stencil.Extension {
    func registerCustomExtensions() {
        registerStringsFilters()
        registerTags()
    }
    
    private func registerTags() {
        registerRemoveExtraNewLinesForceNewLineTag()
    }
    
    private func registerStringsFilters() {
        registerStringsExtraNewLinesFilter()
    }
    
    private func registerStringsExtraNewLinesFilter() {
        registerFilter("removeExtraNewLines") { value -> Any? in
            if let content = value as? String {
                var lines = content.split(whereSeparator: \.isNewline).map { String($0) }
                
                lines = lines.compactMap { line in
                    let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedLine.isEmpty else { return nil }
                    return line
                }
                
                if let first = lines.first {
                    lines[0] = first.trimmingCharacters(in: .whitespacesAndNewlines)
                }

                let result = lines.joined(separator: "\n")
                return result.replacingOccurrences(of: "FORCE_NEW_LINE", with: "")
            }
            return value
        }
    }
    
    private func registerRemoveExtraNewLinesForceNewLineTag() {
        registerSimpleTag("removeExtraNewLinesForceNewLine") { value -> String in
            return "FORCE_NEW_LINE"
        }
    }
}
